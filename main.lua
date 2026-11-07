--源码由司空提供
local UI_URL = "https://sikon.226618.xyz/moon lua UI源码.lua"

local ok, Library = pcall(function()
    return loadstring(game:HttpGet(UI_URL))()
end)

if not ok or type(Library) ~= "table" then
    warn("[索尼中心] UI 库加载失败: " .. tostring(Library))
    return
end

-- ==========================================
-- 1. 启动时先弹出系统原生更新公告（最稳，绝不卡死）
-- ==========================================
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "索尼中心 v1.5 更新",
    Text = "1. 飞雷神瞬移全面优化流畅！\n2. 新增智能监管范围防飞远。\n3. 增加队伍检测防误伤。\n4. 全新 RGB 调色滑块！",
    Duration = 8
})

-- ==========================================
-- 2. 创建主菜单
-- ==========================================
local Window = Library:CreateWindow({
    Name              = "索尼中心",
    Title             = "索尼中心",
    Version           = "v1.5",
    Theme             = "Nord",
    Backdrop          = true,
    ShowBackdrop      = true,
    GradientAnimation = true,
    ConfigFolder      = "索尼中心",
    SearchTab         = false,
    Visible           = true,
})

-- ================= 服务器标签 (飞雷神) =================
local TabServer = Window:CreateTab("服务器")
local PageServer = TabServer:CreateModule("虫子进化", "zap", {})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local State = { 
    Enabled = false, 
    AttackPlayers = true,
    AttackNPC = true,
    CheckStats = true, 
    AttackDelay = 0.05,
    TeamCheck = true,
    MaxDistance = 500
}
local currentTarget = nil
local isTeleporting = false
local TweenService = game:GetService("TweenService")

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
                local dist = (hrp.Position - myHrp.Position).Magnitude
                if dist <= State.MaxDistance then
                    local isPlayer = Players:GetPlayerFromCharacter(v) ~= nil
                    local ok = (isPlayer and State.AttackPlayers) or (not isPlayer and State.AttackNPC)
                    
                    if isPlayer and ok and State.TeamCheck then
                        local p = Players:GetPlayerFromCharacter(v)
                        if p and p.Team == LocalPlayer.Team then ok = false end
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
        
        if not currentTarget or not currentTarget.Parent or not currentTarget:FindFirstChild("Humanoid") or currentTarget.Humanoid.Health <= 0 then
            currentTarget = findTarget(myHrp, myHum)
        end

        if currentTarget then
            local eHrp = currentTarget:FindFirstChild("HumanoidRootPart")
            if eHrp then
                local targetPos = eHrp.Position + (eHrp.CFrame.LookVector * 1) + Vector3.new(0, 2, 0)
                
                pcall(function()
                    if (myHrp.Position - targetPos).Magnitude > 50 then
                        myHrp.CFrame = CFrame.lookAt(targetPos, eHrp.Position)
                    else
                        if not isTeleporting then
                            isTeleporting = true
                            local tween = TweenService:Create(myHrp, TweenInfo.new(0.05, Enum.EasingStyle.Linear), {CFrame = CFrame.lookAt(targetPos, eHrp.Position)})
                            tween:Play()
                            tween.Completed:Connect(function() isTeleporting = false end)
                        end
                    end
                    myHrp.Velocity = Vector3.zero
                end)
                
                doAttack(currentTarget, c)
            end
        end
    end
end)

PageServer:CreateToggle("开启全图飞雷神扫射", false, function(value)
    State.Enabled = value
    currentTarget = nil
end)
PageServer:CreateToggle("队伍检测 (防误伤)", true, function(value) State.TeamCheck = value end)
PageServer:CreateToggle("打不过就跑 (检测血量/攻击)", true, function(value) State.CheckStats = value end)
PageServer:CreateSlider("攻击速度 (越小越快)", 0.01, 0.5, 0.05, function(value) State.AttackDelay = value end)
PageServer:CreateSlider("监管范围 (格)", 50, 1000, 500, function(value) State.MaxDistance = value end)
PageServer:CreateToggle("攻击玩家", true, function(value) State.AttackPlayers = value end)
PageServer:CreateToggle("攻击NPC", true, function(value) State.AttackNPC = value end)

-- ================= 配置标签 =================
local TabConfig = Window:CreateTab("配置")

local PageStyle = TabConfig:CreateModule("外观与主题", "palette", {})
PageStyle:CreateSelector("选择主题", { "Nord", "Rainbow", "Gothic", "Purple", "Creida", "Cherry", "Winter" }, "Nord", function(value)
    Window:SetTheme(value)
end)

local rVal, gVal, bVal = 120, 90, 255
local function updateCustomColor()
    pcall(function() Window:SetCustomTheme(Color3.fromRGB(rVal, gVal, bVal), Color3.fromRGB(rVal, gVal, bVal)) end)
end

PageStyle:CreateSlider("自定义红 (R)", 0, 255, 120, function(v) rVal = v; updateCustomColor() end)
PageStyle:CreateSlider("自定义绿 (G)", 0, 255, 90, function(v) gVal = v; updateCustomColor() end)
PageStyle:CreateSlider("自定义蓝 (B)", 0, 255, 255, function(v) bVal = v; updateCustomColor() end)

PageStyle:CreateToggle("窗口渐变流动", true, function(value) Window:SetGradientAnimation(value) end)

local PageWindow = TabConfig:CreateModule("窗口控制", "layout", {})
PageWindow:CreateButton("隐藏菜单", function() Window:Hide() end)
PageWindow:CreateButton("显示菜单", function() Window:Show() end)
PageWindow:CreateButton("开 / 关 菜单", function() Window:Toggle() end)
PageWindow:CreateKeybind("开关菜单快捷键", Enum.KeyCode.RightShift, function(key) Window:Toggle() end)

local PageSys = TabConfig:CreateModule("系统与配置", "save", {})
PageSys:CreateInput("设置配置名称", "", function(text)
    if text and text ~= "" then _G.ConfigName = text end
end)
PageSys:CreateButton("保存当前配置", function()
    local name = _G.ConfigName or "我的配置"
    local okk, err = pcall(function() Window:SaveConfig(name) end)
    Window:Notify({ Title = okk and "已保存" or "保存失败", Content = okk and name or tostring(err), Duration = 3 })
end)
PageSys:CreateButton("读取当前配置", function()
    local name = _G.ConfigName or "我的配置"
    local okk, err = pcall(function() Window:LoadConfig(name) end)
    Window:Notify({ Title = okk and "已读取" or "读取失败", Content = okk and name or tostring(err), Duration = 3 })
end)
PageSys:CreateButton("删除配置", function()
    local name = _G.ConfigName or "我的配置"
    local okk, err = pcall(function() Window:DeleteConfig(name) end)
    Window:Notify({ Title = okk and "已删除" or "删除失败", Content = okk and name or tostring(err), Duration = 3 })
end)

PageSys:CreateButton("全部恢复默认", function()
    Window:SetTheme("Nord")
    Window:SetGradientAnimation(true)
    Window:Notify({ Title = "重置", Content = "已恢复默认设置", Duration = 3 })
end)

Window:Notify({
    Title    = "索尼中心",
    Content  = "v1.5 加载完毕，祝您游玩愉快！",
    Duration = 5,
})
