-- 虫子进化 核心外链（无需 _G 储物柜）
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- 直接从外部的全局变量拿 UI（配合主菜单使用）
local TabServer = getgenv().SonyTab
local Window = getgenv().SonyWin

if not TabServer or not Window then
    warn("没拿到 UI 组件，请先加载主菜单")
    return
end

local State = { Enabled = false, CheckStats = true, GodMode = true, AttackDelay = 0.05, AttackPlayers = true, AttackNPC = true }
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
                pcall(function()
                    myHrp.CFrame = CFrame.lookAt(eHrp.Position + (eHrp.CFrame.LookVector * 1) + Vector3.new(0, 2, 0), eHrp.Position)
                    myHrp.Velocity = Vector3.zero 
                end)
                doAttack(currentTarget, c)
            end
        end
    end
end)

-- 画 UI
TabServer:CreateToggle("开启全图飞雷神", false, function(v) State.Enabled = v; currentTarget = nil end)
TabServer:CreateToggle("打不过就跑", true, function(v) State.CheckStats = v end)
TabServer:CreateToggle("锁血无敌", true, function(v) State.GodMode = v end)
TabServer:CreateSlider("攻击速度", 0.01, 0.5, 0.05, function(v) State.AttackDelay = v end)
TabServer:CreateToggle("攻击玩家", true, function(v) State.AttackPlayers = v end)
TabServer:CreateToggle("攻击NPC", true, function(v) State.AttackNPC = v end)
