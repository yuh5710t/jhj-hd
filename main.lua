local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

local function pickGuiParent()
    local test = Instance.new("ScreenGui")
    local ok = pcall(function() test.Parent = CoreGui end)
    test:Destroy()
    return ok and CoreGui or playerGui
end
local guiParent = pickGuiParent()

local function newCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = radius or UDim.new(0, 10)
    c.Parent = parent
    return c
end

local Theme = {
    BgColor = Color3.fromRGB(15, 15, 18),
    CardColor = Color3.fromRGB(28, 28, 34),
    Accent = Color3.fromRGB(45, 115, 255),
    TextWhite = Color3.fromRGB(240, 240, 245),
    TextGray = Color3.fromRGB(150, 155, 165),
    Line = Color3.fromRGB(50, 50, 60)
}

local mainGui = Instance.new("ScreenGui")
mainGui.Name = "MM2_VIP"
mainGui.ResetOnSpawn = false
mainGui.IgnoreGuiInset = true
mainGui.DisplayOrder = 999999
mainGui.Parent = guiParent

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.fromScale(0.5, 0.5)
mainFrame.Size = UDim2.new(0.85, 0, 0.65, 0)
mainFrame.BackgroundColor3 = Theme.BgColor
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = mainGui
newCorner(mainFrame, UDim.new(0, 12))

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Theme.Line
mainStroke.Thickness = 1.5
mainStroke.Parent = mainFrame

local bgImage = Instance.new("ImageLabel")
bgImage.Size = UDim2.fromScale(1, 1)
bgImage.BackgroundTransparency = 1
bgImage.Image = "https://i.ibb.co/DHnRRvRy/image.png"
bgImage.ScaleType = Enum.ScaleType.Crop
bgImage.ZIndex = 0
bgImage.Parent = mainFrame
newCorner(bgImage, UDim.new(0, 12))

local bgOverlay = Instance.new("Frame")
bgOverlay.Size = UDim2.fromScale(1, 1)
bgOverlay.BackgroundColor3 = Theme.BgColor
bgOverlay.BackgroundTransparency = 0.6
bgOverlay.BorderSizePixel = 0
bgOverlay.ZIndex = 0
bgOverlay.Parent = mainFrame
newCorner(bgOverlay, UDim.new(0, 12))

local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0.3, 0, 1, 0)
sidebar.BackgroundColor3 = Theme.BgColor
sidebar.BackgroundTransparency = 0.3
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 1
sidebar.Parent = mainFrame
newCorner(sidebar, UDim.new(0, 12))

local divider = Instance.new("Frame")
divider.Size = UDim2.new(0, 1, 1, 0)
divider.Position = UDim2.new(0.3, 0, 0, 0)
divider.BackgroundColor3 = Theme.Line
divider.BorderSizePixel = 0
divider.ZIndex = 1
divider.Parent = mainFrame

local logoLabel = Instance.new("TextLabel")
logoLabel.Size = UDim2.new(1, -20, 0, 60)
logoLabel.Position = UDim2.fromOffset(10, 10)
logoLabel.BackgroundTransparency = 1
logoLabel.Text = "👑 影月 | MM2"
logoLabel.TextColor3 = Theme.TextWhite
logoLabel.Font = Enum.Font.GothamBold
logoLabel.TextSize = 16
logoLabel.TextXAlignment = Enum.TextXAlignment.Left
logoLabel.ZIndex = 2
logoLabel.Parent = sidebar

local navContainer = Instance.new("Frame")
navContainer.Size = UDim2.new(1, -20, 1, -160)
navContainer.Position = UDim2.new(0, 10, 0, 70)
navContainer.BackgroundTransparency = 1
navContainer.ZIndex = 2
navContainer.Parent = sidebar

local navLayout = Instance.new("UIListLayout")
navLayout.Padding = UDim.new(0, 4)
navLayout.SortOrder = Enum.SortOrder.LayoutOrder
navLayout.Parent = navContainer

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(1, 0, 0, 40)
btn.BackgroundColor3 = Theme.Accent
btn.BackgroundTransparency = 0.2
btn.Text = "   📊 仪表盘"
btn.TextColor3 = Theme.TextWhite
btn.Font = Enum.Font.GothamMedium
btn.TextSize = 14
btn.TextXAlignment = Enum.TextXAlignment.Left
btn.Parent = navContainer
newCorner(btn, UDim.new(0, 8))local contentArea = Instance.new("Frame")
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(0.7, 0, 1, 0)
contentArea.Position = UDim2.new(0.3, 0, 0, 0)
contentArea.BackgroundTransparency = 1
contentArea.ZIndex = 1
contentArea.Parent = mainFrame

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, -40, 0, 50)
topBar.Position = UDim2.new(0, 20, 0, 15)
topBar.BackgroundTransparency = 1
topBar.ZIndex = 2
topBar.Parent = contentArea

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.fromOffset(36, 36)
closeBtn.AnchorPoint = Vector2.new(1, 0.5)
closeBtn.Position = UDim2.new(1, 0, 0.5, 0)
closeBtn.BackgroundColor3 = Theme.CardColor
closeBtn.Text = "✖"
closeBtn.TextColor3 = Theme.TextWhite
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = topBar
newCorner(closeBtn, UDim.new(0, 8))
closeBtn.MouseButton1Click:Connect(function() mainGui:Destroy() end)

local scrollPage = Instance.new("ScrollingFrame")
scrollPage.Size = UDim2.new(1, -40, 1, -90)
scrollPage.Position = UDim2.new(0, 20, 0, 75)
scrollPage.BackgroundTransparency = 1
scrollPage.ScrollBarThickness = 2
scrollPage.ScrollBarImageColor3 = Theme.Accent
scrollPage.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollPage.ZIndex = 2
scrollPage.Parent = contentArea

local pageLayout = Instance.new("UIListLayout")
pageLayout.Padding = UDim.new(0, 12)
pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
pageLayout.Parent = scrollPage

local function createCard(parent, title, desc, widthScale, position)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(widthScale, -5, 0, 80)
    card.Position = position
    card.BackgroundColor3 = Theme.CardColor
    card.BackgroundTransparency = 0.2
    card.BorderSizePixel = 0
    card.Parent = parent
    newCorner(card, UDim.new(0, 10))
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Theme.Line
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Parent = card

    local tLabel = Instance.new("TextLabel")
    tLabel.Size = UDim2.new(1, -20, 0, 30)
    tLabel.Position = UDim2.fromOffset(15, 10)
    tLabel.BackgroundTransparency = 1
    tLabel.Text = title
    tLabel.TextColor3 = Theme.TextWhite
    tLabel.Font = Enum.Font.GothamBold
    tLabel.TextSize = 15
    tLabel.TextXAlignment = Enum.TextXAlignment.Left
    tLabel.Parent = card

    local dLabel = Instance.new("TextLabel")
    dLabel.Size = UDim2.new(1, -20, 0, 40)
    dLabel.Position = UDim2.fromOffset(15, 35)
    dLabel.BackgroundTransparency = 1
    dLabel.Text = desc
    dLabel.TextColor3 = Theme.TextGray
    dLabel.Font = Enum.Font.Gotham
    dLabel.TextSize = 12
    dLabel.TextWrapped = true
    dLabel.TextXAlignment = Enum.TextXAlignment.Left
    dLabel.TextYAlignment = Enum.TextYAlignment.Top
    dLabel.Parent = card
    return card
end

local function addBtnToCard(card, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromScale(1, 1)
    b.BackgroundTransparency = 1
    b.Text = ""
    b.Parent = card
    b.MouseButton1Click:Connect(callback)
endlocal row1 = Instance.new("Frame")
row1.Size = UDim2.new(1, 0, 0, 80)
row1.BackgroundTransparency = 1
row1.Parent = scrollPage

local cardServer = createCard(row1, "服务器", "当前玩家: " .. #Players:GetPlayers() .. " 人", 0.5, UDim2.new(0, 0, 0, 0))
local cardDelta = createCard(row1, "状态", "运行正常\n执行器: " .. (identifyexecutor and identifyexecutor() or "未知"), 0.5, UDim2.new(0.5, 0, 0, 0))
cardDelta.BackgroundColor3 = Color3.fromRGB(80, 50, 10)

local row2 = Instance.new("Frame")
row2.Size = UDim2.new(1, 0, 0, 80)
row2.BackgroundTransparency = 1
row2.Parent = scrollPage

local cardQQ = createCard(row2, "QQ 群", "点击复制 QQ 群链接", 1, UDim2.new(0, 0, 0, 0))
cardQQ.BackgroundColor3 = Theme.Accent
addBtnToCard(cardQQ, function()
    if setclipboard then
        setclipboard("https://qm.qq.com/cgi-bin/qm/qr?k=你的QQ群号")
        local t = Instance.new("TextLabel", cardQQ)
        t.Size = UDim2.fromScale(1, 1)
        t.BackgroundTransparency = 1
        t.Text = "✅ 已复制"
        t.TextColor3 = Color3.fromRGB(255, 255, 255)
        t.Font = Enum.Font.GothamBold
        t.TextSize = 16
        task.wait(1.5)
        t:Destroy()
    end
end)

local function CreateESP(base, colors1, colors2, colors3, teamname)
    local bb = Instance.new("BillboardGui", playerGui)
    bb.Adornee = base
    bb.ExtentsOffset = Vector3.new(0, 1, 0)
    bb.AlwaysOnTop = true
    bb.Size = UDim2.new(0, 5, 0, 5)
    bb.Name = "tracker"
    local frame = Instance.new("Frame", bb)
    frame.BackgroundTransparency = 0.3
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.new(colors1, colors2, colors3)
    local txtlbl = Instance.new("TextLabel", bb)
    txtlbl.Text = teamname
    txtlbl.BackgroundTransparency = 1
    txtlbl.Position = UDim2.new(0, 0, 0, -35)
    txtlbl.Size = UDim2.new(1, 0, 10, 0)
    txtlbl.Font = "ArialBold"
    txtlbl.FontSize = "Size12"
    txtlbl.TextStrokeTransparency = 0.5
    txtlbl.TextColor3 = Color3.new(colors1, colors2, colors3)
end

local function Clear()
    for _, v in pairs(playerGui:GetChildren()) do
        if v.Name == "tracker" and v:IsA("BillboardGui") then v:Destroy() end
    end
end

local function findmurderer()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then
            for _, item in pairs(v.Backpack:GetChildren()) do
                if item.Name == "Knife" and v.Character and v.Character:FindFirstChild("Head") then
                    CreateESP(v.Character.Head, 255, 0, 0, "凶手")
                end
            end
            if v.Character then
                for _, item in pairs(v.Character:GetChildren()) do
                    if item.Name == "Knife" and v.Character:FindFirstChild("Head") then
                        CreateESP(v.Character.Head, 255, 0, 0, "凶手")
                    end
                end
            end
        end
    end
end

local function findsheriff()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then
            for _, item in pairs(v.Backpack:GetChildren()) do
                if (item.Name == "Revolver" or item.Name == "Gun") and v.Character and v.Character:FindFirstChild("Head") then
                    CreateESP(v.Character.Head, 0, 0, 255, "警察")
                end
            end
            if v.Character then
                for _, item in pairs(v.Character:GetChildren()) do
                    if (item.Name == "Revolver" or item.Name == "Gun") and v.Character:FindFirstChild("Head") then
                        CreateESP(v.Character.Head, 0, 0, 255, "警察")
                    end
                end
            end
        end
    end
endlocal function findplayers()
    findmurderer()
    findsheriff()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            local hasItem = false
            for _, item in pairs(v.Character:GetChildren()) do
                if item.Name == "Knife" or item.Name == "Revolver" or item.Name == "Gun" then hasItem = true end
            end
            if not hasItem then CreateESP(v.Character.Head, 0, 255, 0, "平民") end
        end
    end
end

local function coingrabberfunc()
    for _, child in pairs(workspace:GetDescendants()) do
        if child:IsA("BasePart") and child.Name == "Coin" then
            child.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
        end
    end
end

local row3 = Instance.new("Frame")
row3.Size = UDim2.new(1, 0, 0, 80)
row3.BackgroundTransparency = 1
row3.Parent = scrollPage

local card1 = createCard(row3, "硬币吸取", "瞬间吸走所有硬币", 0.5, UDim2.new(0, 0, 0, 0))
addBtnToCard(card1, function() coingrabberfunc() end)

local card2 = createCard(row3, "警/凶 ESP", "红名凶手，蓝名警察", 0.5, UDim2.new(0.5, 0, 0, 0))
addBtnToCard(card2, function() Clear() findmurderer() findsheriff() end)

local row4 = Instance.new("Frame")
row4.Size = UDim2.new(1, 0, 0, 80)
row4.BackgroundTransparency = 1
row4.Parent = scrollPage

local card3 = createCard(row4, "所有 ESP", "显示所有玩家身份", 0.5, UDim2.new(0, 0, 0, 0))
addBtnToCard(card3, function() Clear() findplayers() end)

local card4 = createCard(row4, "ESP 关闭", "清除透视标记", 0.5, UDim2.new(0.5, 0, 0, 0))
addBtnToCard(card4, function() Clear() end)

local speedActive = false
local card5 = createCard(scrollPage, "跑得快", "点击切换速度", 1, UDim2.new(0, 0, 0, 0))
addBtnToCard(card5, function()
    speedActive = not speedActive
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = speedActive and 32 or 16
    end
end)

local card6 = createCard(scrollPage, "传枪", "把地上的枪传到你脚下", 1, UDim2.new(0, 0, 0, 0))
addBtnToCard(card6, function()
    if workspace:FindFirstChild("GunDrop") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        workspace.GunDrop.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
    end
end)

-- 换成 X光透视（点击开/关）
local xrayActive = false
local card7 = createCard(scrollPage, "X光透视", "点击开启/关闭地图透视", 1, UDim2.new(0, 0, 0, 0))
addBtnToCard(card7, function()
    xrayActive = not xrayActive
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then
            v.LocalTransparencyModifier = xrayActive and 0.75 or 0
        end
    end
end)

-- 换成 传送凶手（穿墙换成了这个）
local card8 = createCard(scrollPage, "传送到凶手", "瞬间飞到凶手身边", 1, UDim2.new(0, 0, 0, 0))
addBtnToCard(card8, function()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            local isMurderer = false
            for _, item in pairs(v.Backpack:GetChildren()) do
                if item.Name == "Knife" then isMurderer = true end
            end
            for _, item in pairs(v.Character:GetChildren()) do
                if item.Name == "Knife" then isMurderer = true end
            end
            if isMurderer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.Head.CFrame
                break
            end
        end
    end
end)

pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollPage.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 20)
end)
