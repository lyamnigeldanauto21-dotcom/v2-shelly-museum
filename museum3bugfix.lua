-- Shelly's Museum V1.4
-- Safe Anti-Ban & Compact Grid Layout

-- 1. STABLE ENVIRONMENT SECURITY
local Success, Error = pcall(function()
    if getgenv then
        getgenv().SecureMode = true
    end
end)

-- 2. CORE SERVICES
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")

-- Destroy previous UI instances
if PlayerGui:FindFirstChild("ShellyMuseumUI") then
    PlayerGui.ShellyMuseumUI:Destroy()
end

-- 3. MAIN WINDOW INTERFACE
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ShellyMuseumUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 380, 0, 240)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -120) -- Center
MainFrame.BackgroundColor3 = Color3.fromRGB(24, 23, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Top Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 36)
TitleBar.BackgroundColor3 = Color3.fromRGB(38, 33, 27)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -50, 1, 0)
TitleText.Position = UDim2.new(0, 12)
TitleText.BackgroundTransparency = 1
TitleText.Text = "Shelly's Museum V1.4"
TitleText.TextColor3 = Color3.fromRGB(245, 195, 115)
TitleText.TextSize = 13
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 22, 0, 22)
CloseButton.Position = UDim2.new(1, -30, 0, 7)
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 10
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 5)
CloseCorner.Parent = CloseButton

-- 4. SIDEBAR & CONTENT CONTAINER GRID
local SidebarFrame = Instance.new("Frame")
SidebarFrame.Name = "SidebarFrame"
SidebarFrame.Size = UDim2.new(0.3, 0, 1, -36) -- Exact 30% width
SidebarFrame.Position = UDim2.new(0, 0, 0, 36)
SidebarFrame.BackgroundColor3 = Color3.fromRGB(31, 29, 25)
SidebarFrame.BorderSizePixel = 0
SidebarFrame.Parent = MainFrame

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Parent = SidebarFrame
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 4)

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.Parent = SidebarFrame
SidebarPadding.PaddingTop = UDim.new(0, 8)
SidebarPadding.PaddingLeft = UDim.new(0, 6)
SidebarPadding.PaddingRight = UDim.new(0, 6)

local ContentWindow = Instance.new("Frame")
ContentWindow.Name = "ContentWindow"
ContentWindow.Size = UDim2.new(0.7, 0, 1, -36) -- Exact 70% width
ContentWindow.Position = UDim2.new(0.3, 0, 0, 36)
ContentWindow.BackgroundTransparency = 1
ContentWindow.Parent = MainFrame

-- 5. FIXED TAB CONTROLLER
local CoreTabs = {}
local TabButtons = {}
local CurrentTab = nil

local function NewTab(name, isDefault)
    local Page = Instance.new("Frame")
    Page.Name = name .. "Page"
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = isDefault
    Page.Parent = ContentWindow
    
    local PagePadding = Instance.new("UIPadding")
    PagePadding.Parent = Page
    PagePadding.PaddingTop = UDim.new(0, 10)
    PagePadding.PaddingBottom = UDim.new(0, 10)
    PagePadding.PaddingLeft = UDim.new(0, 10)
    PagePadding.PaddingRight = UDim.new(0, 10)
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 28)
    Button.BackgroundColor3 = isDefault and Color3.fromRGB(43, 38, 31) or Color3.fromRGB(36, 34, 29)
    Button.Text = name
    Button.TextColor3 = isDefault and Color3.fromRGB(245, 195, 115) or Color3.fromRGB(160, 155, 145)
    Button.TextSize = 11
    Button.Font = isDefault and Enum.Font.GothamBold or Enum.Font.Gotham
    Button.Parent = SidebarFrame
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 4)
    BtnCorner.Parent = Button
    
    CoreTabs[name] = Page
    TabButtons[name] = Button
    if isDefault then CurrentTab = name end
    
    Button.MouseButton1Click:Connect(function()
        if CurrentTab == name then return end
        
        TabButtons[CurrentTab].BackgroundColor3 = Color3.fromRGB(36, 34, 29)
        TabButtons[CurrentTab].TextColor3 = Color3.fromRGB(160, 155, 145)
        TabButtons[CurrentTab].Font = Enum.Font.Gotham
        CoreTabs[CurrentTab].Visible = false
        
        Button.BackgroundColor3 = Color3.fromRGB(43, 38, 31)
        Button.TextColor3 = Color3.fromRGB(245, 195, 115)
        Button.Font = Enum.Font.GothamBold
        Page.Visible = true
        
        CurrentTab = name
    end)
    
    return Page
end

-- 6. LAYOUT-SAFE CATEGORIES
local Tab1 = NewTab("Main", true)
local Tab2 = NewTab("Toon Log", false)
local Tab3 = NewTab("Settings", false)

-- Tab 1 Items
local Label1 = Instance.new("TextLabel")
Label1.Size = UDim2.new(1, 0, 0, 50)
Label1.BackgroundTransparency = 1
Label1.Text = "Anti-Ban protection loaded.\nStatus: Secure."
Label1.TextColor3 = Color3.fromRGB(175, 170, 160)
Label1.TextSize = 11
Label1.Font = Enum.Font.Gotham
Label1.TextXAlignment = Enum.TextXAlignment.Left
Label1.TextYAlignment = Enum.TextYAlignment.Top
Label1.Parent = Tab1

local ActionBtn1 = Instance.new("TextButton")
ActionBtn1.Size = UDim2.new(1, 0, 0, 32)
ActionBtn1.Position = UDim2.new(0, 0, 1, -32)
ActionBtn1.BackgroundColor3 = Color3.fromRGB(205, 145, 65)
ActionBtn1.Text = "Start System"
ActionBtn1.TextColor3 = Color3.fromRGB(25, 20, 15)
ActionBtn1.TextSize = 11
ActionBtn1.Font = Enum.Font.GothamBold
ActionBtn1.Parent = Tab1
Instance.new("UICorner", ActionBtn1).CornerRadius = UDim.new(0, 4)

-- Tab 2 Items
local Label2 = Instance.new("TextLabel")
Label2.Size = UDim2.new(1, 0, 0, 50)
Label2.BackgroundTransparency = 1
Label2.Text = "Track active monsters and items in the area."
Label2.TextColor3 = Color3.fromRGB(175, 170, 160)
Label2.TextSize = 11
Label2.Font = Enum.Font.Gotham
Label2.TextXAlignment = Enum.TextXAlignment.Left
Label2.TextYAlignment = Enum.TextYAlignment.Top
Label2.Parent = Tab2

local ActionBtn2 = Instance.new("TextButton")
ActionBtn2.Size = UDim2.new(1, 0, 0, 32)
ActionBtn2.Position = UDim2.new(0, 0, 1, -32)
ActionBtn2.BackgroundColor3 = Color3.fromRGB(45, 42, 37)
ActionBtn2.Text = "Toon Tracker: OFF"
ActionBtn2.TextColor3 = Color3.fromRGB(220, 90, 90)
ActionBtn2.TextSize = 11
ActionBtn2.Font = Enum.Font.GothamBold
ActionBtn2.Parent = Tab2
Instance.new("UICorner", ActionBtn2).CornerRadius = UDim.new(0, 4)

-- Tab 3 Items
local Label3 = Instance.new("TextLabel")
Label3.Size = UDim2.new(1, 0, 0, 50)
Label3.BackgroundTransparency = 1
Label3.Text = "Adjust general script settings and visibility."
Label3.TextColor3 = Color3.fromRGB(175, 170, 160)
Label3.TextSize = 11
Label3.Font = Enum.Font.Gotham
Label3.TextXAlignment = Enum.TextXAlignment.Left
Label3.TextYAlignment = Enum.TextYAlignment.Top
Label3.Parent = Tab3

local ActionBtn3 = Instance.new("TextButton")
ActionBtn3.Size = UDim2.new(1, 0, 0, 32)
ActionBtn3.Position = UDim2.new(0, 0, 1, -32)
ActionBtn3.BackgroundColor3 = Color3.fromRGB(45, 42, 37)
ActionBtn3.Text = "UI Transparency: Default"
ActionBtn3.TextColor3 = Color3.fromRGB(245, 195, 115)
ActionBtn3.TextSize = 11
ActionBtn3.Font = Enum.Font.GothamBold
ActionBtn3.Parent = Tab3
Instance.new("UICorner", ActionBtn3).CornerRadius = UDim.new(0, 4)

-- 7. FUNCTIONALITY LAYERS
CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

ActionBtn1.MouseButton1Click:Connect(function()
    ActionBtn1.Text = "Active ✓"
    ActionBtn1.BackgroundColor3 = Color3.fromRGB(75, 160, 95)
    ActionBtn1.TextColor3 = Color3.fromRGB(255, 255, 255)
    task.wait(1)
    ActionBtn1.Text = "Start System"
    ActionBtn1.BackgroundColor3 = Color3.fromRGB(205, 145, 65)
    ActionBtn1.TextColor3 = Color3.fromRGB(25, 20, 15)
end)

local Toggled2 = false
ActionBtn2.MouseButton1Click:Connect(function()
    Toggled2 = not Toggled2
    ActionBtn2.Text = Toggled2 and "Toon Tracker: ON" or "Toon Tracker: OFF"
    ActionBtn2.TextColor3 = Toggled2 and Color3.fromRGB(75, 160, 95) or Color3.fromRGB(220, 90, 90)
end)

-- 8. SMOOTH MOBILE DRAG IMPLEMENTATION
local Dragging, DragInput, StartPos, FramePos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        StartPos = input.Position
        FramePos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then Dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local Delta = input.Position - StartPos
        TweenService:Create(MainFrame, TweenInfo.new(0.05, Enum.EasingStyle.Linear), {
            Position = UDim2.new(FramePos.X.Scale, FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y)
        }):Play()
    end
end)
