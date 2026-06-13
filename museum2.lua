-- Shelly's Dinosaur Museum V1.2
-- Optimized for Mobile Executors (Delta, Fluxus, etc.)
-- Dark Volcanic & Amber Gold Theme | Smooth Multi-Tab Layout

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Safe PlayerGui targeting
local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")

-- Clean up older versions instantly
if PlayerGui:FindFirstChild("ShellyMuseumUI") then
    PlayerGui.ShellyMuseumUI:Destroy()
end

-- Base Container
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ShellyMuseumUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- Main Window Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 380, 0, 260)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -130) -- Centered
MainFrame.BackgroundColor3 = Color3.fromRGB(24, 23, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Title Header Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(38, 33, 27)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

local TitleVisualFix = Instance.new("Frame")
TitleVisualFix.Size = UDim2.new(1, 0, 0, 10)
TitleVisualFix.Position = UDim2.new(0, 0, 1, -10)
TitleVisualFix.BackgroundColor3 = Color3.fromRGB(38, 33, 27)
TitleVisualFix.BorderSizePixel = 0
TitleVisualFix.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Size = UDim2.new(1, -50, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "Shelly's Dinosaur Museum V1.2"
TitleText.TextColor3 = Color3.fromRGB(245, 195, 115) -- Amber Gold
TitleText.TextSize = 14
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Close Window Button (✕)
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 26, 0, 26)
CloseButton.Position = UDim2.new(1, -33, 0, 7)
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 12
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton


-- Left Sidebar Menu (For Tabs)
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 110, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(31, 29, 25)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SideVisualFix = Instance.new("Frame")
SideVisualFix.Size = UDim2.new(0, 10, 1, 0)
SideVisualFix.Position = UDim2.new(1, -10, 0, 0)
SideVisualFix.BackgroundColor3 = Color3.fromRGB(31, 29, 25)
SideVisualFix.BorderSizePixel = 0
SideVisualFix.Parent = Sidebar

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Parent = Sidebar
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 4)

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.Parent = Sidebar
SidebarPadding.PaddingTop = UDim.new(0, 10)
SidebarPadding.PaddingLeft = UDim.new(0, 8)
SidebarPadding.PaddingRight = UDim.new(0, 8)


-- Main Content Window Panel
local Container = Instance.new("Frame")
Container.Name = "Container"
Container.Size = UDim2.new(1, -110, 1, -40)
Container.Position = UDim2.new(0, 110, 0, 40)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame


----------------- CORE TAB HANDLING SYSTEM -----------------

local Tabs = {}
local TabButtons = {}
local ActiveTab = nil

local function CreateTab(tabName, isDefault)
    -- Content Canvas View
    local TabPage = Instance.new("Frame")
    TabPage.Name = tabName .. "Page"
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.BackgroundTransparency = 1
    TabPage.Visible = isDefault or false
    TabPage.Parent = Container
    
    local PagePadding = Instance.new("UIPadding")
    PagePadding.Parent = TabPage
    PagePadding.PaddingTop = UDim.new(0, 15)
    PagePadding.PaddingBottom = UDim.new(0, 15)
    PagePadding.PaddingLeft = UDim.new(0, 15)
    PagePadding.PaddingRight = UDim.new(0, 15)
    
    -- Selection Navigation Button
    local TabButton = Instance.new("TextButton")
    TabButton.Name = tabName .. "Btn"
    TabButton.Size = UDim2.new(1, 0, 0, 32)
    TabButton.BackgroundColor3 = isDefault and Color3.fromRGB(43, 38, 31) or Color3.fromRGB(36, 34, 29)
    TabButton.Text = tabName
    TabButton.TextColor3 = isDefault and Color3.fromRGB(245, 195, 115) or Color3.fromRGB(160, 155, 145)
    TabButton.TextSize = 12
    TabButton.Font = isDefault and Enum.Font.GothamBold or Enum.Font.Gotham
    TabButton.Parent = Sidebar
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = TabButton
    
    Tabs[tabName] = TabPage
    TabButtons[tabName] = TabButton
    
    if isDefault then
        ActiveTab = tabName
    end
    
    -- Switch Tab Event
    TabButton.MouseButton1Click:Connect(function()
        if ActiveTab == tabName then return end
        
        -- Dim previous active tab elements
        TabButtons[ActiveTab].BackgroundColor3 = Color3.fromRGB(36, 34, 29)
        TabButtons[ActiveTab].TextColor3 = Color3.fromRGB(160, 155, 145)
        TabButtons[ActiveTab].Font = Enum.Font.Gotham
        Tabs[ActiveTab].Visible = false
        
        -- Highlight selected tab elements
        TabButton.BackgroundColor3 = Color3.fromRGB(43, 38, 31)
        TabButton.TextColor3 = Color3.fromRGB(245, 195, 115)
        TabButton.Font = Enum.Font.GothamBold
        TabPage.Visible = true
        
        ActiveTab = tabName
    end)
    
    return TabPage
end


----------------- TAB CONTENT ARCHITECTURE -----------------

-- TAB 1: Main Terminal (Default Hub View)
local MainTab = CreateTab("Terminal", true)

local MainDesc = Instance.new("TextLabel")
MainDesc.Size = UDim2.new(1, 0, 0, 80)
MainDesc.BackgroundTransparency = 1
MainDesc.Text = "Museum system status: Nominal.\nAll display vaults are locked.\n\nUse the panel navigation to alter local dig scripts and fossil replication arrays."
MainDesc.TextColor3 = Color3.fromRGB(180, 175, 165)
MainDesc.TextSize = 12
MainDesc.Font = Enum.Font.Gotham
MainDesc.TextWrapped = true
MainDesc.TextXAlignment = Enum.TextXAlignment.Left
MainDesc.TextYAlignment = Enum.TextYAlignment.Top
MainDesc.Parent = MainTab

local InitButton = Instance.new("TextButton")
InitButton.Size = UDim2.new(1, 0, 0, 38)
InitButton.Position = UDim2.new(0, 0, 1, -38)
InitButton.BackgroundColor3 = Color3.fromRGB(205, 145, 65)
InitButton.Text = "Initialize Core Server"
InitButton.TextColor3 = Color3.fromRGB(25, 20, 15)
InitButton.TextSize = 13
InitButton.Font = Enum.Font.GothamBold
InitButton.Parent = MainTab

local InitCorner = Instance.new("UICorner")
InitCorner.CornerRadius = UDim.new(0, 6)
InitCorner.Parent = InitButton


-- TAB 2: Fossil Logs Setup
local FossilTab = CreateTab("Fossil Logs", false)

local FossilDesc = Instance.new("TextLabel")
FossilDesc.Size = UDim2.new(1, 0, 0, 45)
FossilDesc.BackgroundTransparency = 1
FossilDesc.Text = "Configure automated excavation logs. Toggling tracking helps capture data updates cleanly."
FossilDesc.TextColor3 = Color3.fromRGB(180, 175, 165)
FossilDesc.TextSize = 11
FossilDesc.Font = Enum.Font.Gotham
FossilDesc.TextWrapped = true
FossilDesc.TextXAlignment = Enum.TextXAlignment.Left
FossilDesc.TextYAlignment = Enum.TextYAlignment.Top
FossilDesc.Parent = FossilTab

local ToggleLogBtn = Instance.new("TextButton")
ToggleLogBtn.Size = UDim2.new(1, 0, 0, 36)
ToggleLogBtn.Position = UDim2.new(0, 0, 0, 60)
ToggleLogBtn.BackgroundColor3 = Color3.fromRGB(45, 42, 37)
ToggleLogBtn.Text = "Auto-Log Excavations: OFF"
ToggleLogBtn.TextColor3 = Color3.fromRGB(220, 90, 90) -- Default Red Off state
ToggleLogBtn.TextSize = 12
ToggleLogBtn.Font = Enum.Font.GothamBold
ToggleLogBtn.Parent = FossilTab

local LogCorner = Instance.new("UICorner")
LogCorner.CornerRadius = UDim.new(0, 6)
LogCorner.Parent = ToggleLogBtn


-- TAB 3: Exhibits Matrix
local ExhibitsTab = CreateTab("Exhibits", false)

local ExhibitDesc = Instance.new("TextLabel")
ExhibitDesc.Size = UDim2.new(1, 0, 0, 45)
ExhibitDesc.BackgroundTransparency = 1
ExhibitDesc.Text = "Direct overrides for individual security arrays inside display halls."
ExhibitDesc.TextColor3 = Color3.fromRGB(180, 175, 165)
ExhibitDesc.TextSize = 11
ExhibitDesc.Font = Enum.Font.Gotham
ExhibitDesc.TextWrapped = true
ExhibitDesc.TextXAlignment = Enum.TextXAlignment.Left
ExhibitDesc.TextYAlignment = Enum.TextYAlignment.Top
ExhibitDesc.Parent = ExhibitsTab

local ApexToggle = Instance.new("TextButton")
ApexToggle.Size = UDim2.new(1, 0, 0, 36)
ApexToggle.Position = UDim2.new(0, 0, 0, 60)
ApexToggle.BackgroundColor3 = Color3.fromRGB(45, 42, 37)
ApexToggle.Text = "Apex Predator Hall Gate: CLOSED"
ApexToggle.TextColor3 = Color3.fromRGB(220, 90, 90)
ApexToggle.TextSize = 12
ApexToggle.Font = Enum.Font.GothamBold
ApexToggle.Parent = ExhibitsTab

local ApexCorner = Instance.new("UICorner")
ApexCorner.CornerRadius = UDim.new(0, 6)
ApexCorner.Parent = ApexToggle


----------------- WIDGET ACTIONS & BEHAVIORS -----------------

-- Close Handler
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Tab 1 Action Loop
InitButton.MouseButton1Click:Connect(function()
    InitButton.Text = "Server Online ✓"
    InitButton.BackgroundColor3 = Color3.fromRGB(75, 160, 95)
    InitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    task.wait(1.5)
    InitButton.Text = "Initialize Core Server"
    InitButton.BackgroundColor3 = Color3.fromRGB(205, 145, 65)
    InitButton.TextColor3 = Color3.fromRGB(25, 20, 15)
end)

-- Tab 2 Log Switcher state tracking
local logActive = false
ToggleLogBtn.MouseButton1Click:Connect(function()
    logActive = not logActive
    if logActive then
        ToggleLogBtn.Text = "Auto-Log Excavations: ON"
        ToggleLogBtn.TextColor3 = Color3.fromRGB(75, 160, 95) -- Active Green
    else
        ToggleLogBtn.Text = "Auto-Log Excavations: OFF"
        ToggleLogBtn.TextColor3 = Color3.fromRGB(220, 90, 90) -- Off Red
    end
end)

-- Tab 3 Gate Switcher state tracking
local gateOpen = false
ApexToggle.MouseButton1Click:Connect(function()
    gateOpen = not gateOpen
    if gateOpen then
        ApexToggle.Text = "Apex Predator Hall Gate: OPEN"
        ApexToggle.TextColor3 = Color3.fromRGB(75, 160, 95)
    else
        ApexToggle.Text = "Apex Predator Hall Gate: CLOSED"
        ApexToggle.TextColor3 = Color3.fromRGB(220, 90, 90)
    end
end)


----------------- SYSTEM TOUCH DRAG RIGGING -----------------

local dragToggle = nil
local dragStart = nil
local startPos = nil

local function updateInput(input)
    local delta = input.Position - dragStart
    local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    TweenService:Create(MainFrame, TweenInfo.new(0.08, Enum.EasingStyle.Linear), {Position = position}):Play()
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragToggle = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if dragToggle then
            updateInput(input)
        end
    end
end)
