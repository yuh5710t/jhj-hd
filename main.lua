-- 虫子进化 核心外链文件
return function(TabServer, Window, Library)
    -- 引入所需服务
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Workspace = game:GetService("Workspace")

    local State = { 
        Enabled = false, 
        AttackPlayers = true,
        AttackNPC = true,
        GodMode = true,
        CheckStats = true, 
        AttackDelay = 0.05
    }
    local currentTarget = nil

    local function getAttack(model)
        if model:FindFirstChildOfClass("Tool") or model:FindFirstChild("Weapon") then return 100 end
        return 10
    end

    local function findTarget(myHrp, myHum)
        local best, lowestHP = nil, math.huge
        local myHP = myHum.Health
        local myAtk = getAttack(LocalPlayer.Character)

        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("Model") and v ~= LocalPlayer.Character then
                local hum = v:FindFirstChildOfClass("Humanoid")
                local hrp = v:FindFirstChild("HumanoidRootPart")
                if hum and hrp and hum.Health > 0 then
                    local isPlayer = Players:GetPlayerFromCharacter(v) ~= nil
                    local ok = (isPlayer and State.AttackPlayers) or (not isPlayer and State.AttackNPC)
                    if isPlayer then
                        local p = Players:GetPlayerFromCharacter(v)
                        if p and p.Team and LocalPlayer.Team and p.Team == LocalPlayer.Team then ok = false end
                    end
                    if ok and State.CheckStats then
                        if hum.Health > myHP or getAttack(v) > myAtk then ok = false end
                    end
                    if ok and hum.Health < lowestHP then
                        lowestHP = hum.Health
                        best = v
                    end
                end
            end
        end
        return best
    end

    local function doAttack(target, myChar)
        local tool = myChar:FindFirstChildOfClass("Tool")
        if tool then
            pcall(function() tool:Activate() end)
            for _, desc in ipairs(tool:GetDescendants()) do
                if desc:IsA("RemoteEvent") or desc:IsA("RemoteFunction") then
                    pcall(function() desc:FireServer(target, target:FindFirstChild("HumanoidRootPart")) end)
                end
            end
        else
            local hum = target:FindFirstChildOfClass("Humanoid")
            if hum then pcall(function() hum:TakeDamage(10) end) end
        end
    end

    task.spawn(function()
        while task.wait(State.AttackDelay) do
            if not State.Enabled then continue end
            local c = LocalPlayer.Character
            if not c then continue end
            local myHum = c:FindFirstChildOfClass("Humanoid")
            local myHrp = c:FindFirstChild("HumanoidRootPart")
            if not myHum or not myHrp then continue end
            
            if State.GodMode then myHum.Health = myHum.MaxHealth end

            if not currentTarget or not currentTarget.Parent or not currentTarget:FindFirstChild("Humanoid") or currentTarget.Humanoid.Health <= 0 then
                currentTarget = findTarget(myHrp, myHum)
            end

            if currentTarget then
                local eHrp = currentTarget:FindFirstChild("HumanoidRootPart")
                if eHrp then
                    local targetPos = eHrp.Position + (eHrp.CFrame.LookVector * 1) + Vector3.new(0, 2, 0)
                    pcall(function()
                        myHrp.CFrame = CFrame.lookAt(targetPos, eHrp.Position)
                        myHrp.Velocity = Vector3.zero 
                    end)
                    doAttack(currentTarget, c)
                end
            end
        end
    end)

    -- 直接把UI控件画在传进来的 TabServer 上
    TabServer:CreateToggle("开启全图飞雷神扫射", false, function(value)
        State.Enabled = value
        currentTarget = nil
        Window:Notify({ Title = "虫子进化", Content = value and "已开启" or "已关闭", Duration = 2 })
    end)

    TabServer:CreateToggle("打不过就跑 (检测血量/攻击)", true, function(value) State.CheckStats = value end)
    TabServer:CreateToggle("锁血无敌 (防暴毙)", true, function(value) State.GodMode = value end)
    TabServer:CreateSlider("攻击速度 (越小越快)", 0.01, 0.5, 0.05, function(value) State.AttackDelay = value end)
    TabServer:CreateToggle("攻击玩家", true, function(value) State.AttackPlayers = value end)
    TabServer:CreateToggle("攻击NPC", true, function(value) State.AttackNPC = value end)
end
