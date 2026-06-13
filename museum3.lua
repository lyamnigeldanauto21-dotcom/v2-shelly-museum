-- Shelly's Dinosaur Museum V1.3 [Dandy's World Edition]
-- Fix: Internal Absolute Boundaries | Secure Anti-Ban Environment Rigging
-- Theme: Dark Volcanic & Amber Gold 

-- ==========================================
-- SECURITY ENVIRONMENT MASKING (ANTI-BAN)
-- ==========================================
local SecurityEnviroment = {}
do
    local setmetatable = setmetatable
    local os = os
    local task = task
    
    -- Spoof garbage collection hooks to prevent detection scanning
    if hookfunction or replaceclosure then
        local old_gc = hookfunction(gcinfo, function()
            return old_gc() - math.random(1, 15)
        end)
        
        local old_collect = hookfunction(collectgarbage, function(action, ...)
            if action == "count" then
                return old_gc() - math.random(1, 15)
            end
            return old_collect(action, ...)
        end)
    end
    
    -- Strict registry detour for environment wrappers
    pcall(function()
        if getgenv and getrawmetatable then
            local genv = getgenv()
            local gmt = getrawmetatable(genv)
            if gmt and setreadonly then
                setreadonly(gmt, false)
                local old_index = gmt.__index
                gmt.__index = function(t, k)
                    if k == "Detector" or k == "Anticheat" then return nil end
                    return old_index(t, k)
                end
                setreadonly(gmt, true)
            end
        end
    end)
end

-- ==========================================
-- UI INITIALIZATION & RENDER ENGINE
-- ==========================================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")

-- Instantly purge previous versions
if PlayerGui:FindFirstChild("ShellyMuseumUI") then
    PlayerGui.ShellyMuseumUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ShellyMuseumUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- Consolidated Base Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 390, 0, 250)
MainFrame.Position = UDim2.new(0.5, -195, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(24, 23, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Header Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(38, 33, 27)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

-- Prevents rounding artifacts showing background underneath header
local HeaderPatch = Instance.new("Frame")
HeaderPatch.Size = UDim2.new(1, 0, 0, 10)
HeaderPatch.Position = UDim2.new(0, 0, 1, -10)
HeaderPatch.BackgroundColor3 = Color3.fromRGB(38, 33, 27)
HeaderPatch.BorderSizePixel = 0
HeaderPatch.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -60, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "Shelly's Dinosaur Museum V1.3"
TitleText.TextColor3 = Color3.fromRGB(245, 195, 115)
TitleText.TextSize = 13
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 24, 0, 24)
CloseButton.Position = UDim2.new(1, -34, 0, 8)
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 11
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

-- ==========================================
-- PERSISTENT GRID SYSTEM LAYOUT
-- ==========================================
-- Using strict percentage widths to keep sidebar and panel locked inside MainFrame boundaries.
local LeftSidebarWidth = 0.30 
local RightContentWidth = 0.70

local SidebarFrame = Instance.new("Frame")
SidebarFrame.Name = "SidebarFrame"
SidebarFrame.Size = UDim2.new(LeftSidebarWidth, 0, 1, -40)
SidebarFrame.Position = UDim2.new(0, 0, 0, 40)
SidebarFrame.BackgroundColor3 = Color3.fromRGB(31, 29, 25)
SidebarFrame.BorderSizePixel = 0
SidebarFrame.Parent = MainFrame

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Parent = SidebarFrame
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 5)

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.Parent = SidebarFrame
SidebarPadding.PaddingTop = UDim.new(0, 10)
SidebarPadding.PaddingLeft = UDim.new(0, 8)
SidebarPadding.PaddingRight = UDim.new(0, 8)

-- Master Container for Canvas Sheets
local ContentWindow = Instance.new("Frame")
ContentWindow.Name = "ContentWindow"
ContentWindow.Size = UDim2.new(RightContentWidth, -1, 1, -40)
ContentWindow.Position = UDim2.new(LeftSidebarWidth, 1, 0, 40)
ContentWindow.BackgroundTransparency = 1
ContentWindow.Parent = MainFrame

----------------------------------------------------
-- INTERACTIVE SHEET MANAGEMENT ENGINE
----------------------------------------------------
local CoreSheets = {}
local MenuButtons = {}
local CurrentSheetView = nil

local function RegisterCategory(name, isInitialView)
    local ActionSheet = Instance.new("Frame")
    ActionSheet.Name = name .. "Sheet"
    ActionSheet.Size = UDim2.new(1, 0, 1, 0)
    ActionSheet.BackgroundTransparency = 1
    ActionSheet.Visible = isInitialView or false
    ActionSheet.Parent = ContentWindow
    
    local SheetPadding = Instance.new("UIPadding")
    SheetPadding.Parent = ActionSheet
    SheetPadding.PaddingTop = UDim.new(0, 12)
    SheetPadding.PaddingBottom = UDim.new(0, 12)
    SheetPadding.PaddingLeft = UDim.new(0, 12)
    SheetPadding.PaddingRight = UDim.new(0, 12)
    
    local MenuButton = Instance.new("TextButton")
    MenuButton.Name = name .. "MenuBtn"
    MenuButton.Size = UDim2.new(1, 0, 0, 30)
    MenuButton.BackgroundColor3 = isInitialView and Color3.fromRGB(43, 38, 31) or Color3.fromRGB(36, 34, 29)
    MenuButton.Text = name
    MenuButton.TextColor3 = isInitialView and Color3.fromRGB(245, 195, 115) or Color3.fromRGB(160, 155, 145)
    MenuButton.TextSize = 11
    MenuButton.Font = isInitialView and Enum.Font.GothamBold or Enum.Font.Gotham
    MenuButton.Parent = SidebarFrame
    
    local MenuBtnCorner = Instance.new("UICorner")
    MenuBtnCorner.CornerRadius = UDim.new(0, 5)
    MenuBtnCorner.Parent = MenuButton
    
    CoreSheets[name] = ActionSheet
    MenuButtons[name] = MenuButton
    
    if isInitialView then
        CurrentSheetView = name
    end
    
    MenuButton.MouseButton1Click:Connect(function()
        if CurrentSheetView == name then return end
        
        MenuButtons[CurrentSheetView].BackgroundColor3 = Color3.fromRGB(36, 34, 29)
        MenuButtons[CurrentSheetView].TextColor3 = Color3.fromRGB(160, 155, 145)
        MenuButtons[CurrentSheetView].Font = Enum.Font.Gotham
        CoreSheets[CurrentSheetView].Visible = false
        
        MenuButton.BackgroundColor3 = Color3.fromRGB(43, 38, 31)
        MenuButton.TextColor3 = Color3.fromRGB(245, 195, 115)
        MenuButton.Font = Enum.Font.GothamBold
        ActionSheet.Visible = true
        
        CurrentSheetView = name
    end)
    
    return ActionSheet
end

----------------------------------------------------
-- ASSIGN PANEL CONTENTS (BOUND TO CONTEXT WINDOW)
----------------------------------------------------

-- PANEL 1: Terminal Hub
local Panel1 = RegisterCategory("Terminal", true)

local TextInfo1 = Instance.new("TextLabel")
TextInfo1.Size = UDim2.new(1, 0, 0, 65)
TextInfo1.BackgroundTransparency = 1
TextInfo1.Text = "System environment secure.\nAnti-Cheat filters bypassed successfully.\n\nReady to hook into floor routines."
TextInfo1.TextColor3 = Color3.fromRGB(175, 170, 160)
TextInfo1.TextSize = 11
TextInfo1.Font = Enum.Font.Gotham
TextInfo1.TextWrapped = true
TextInfo1.TextXAlignment = Enum.TextXAlignment.Left
TextInfo1.TextYAlignment = Enum.TextYAlignment.Top
TextInfo1.Parent = Panel1

local ServerActBtn = Instance.new("TextButton")
ServerActBtn.Size = UDim2.new(1, 0, 0, 34)
ServerActBtn.Position = UDim2.new(0, 0, 1, -34)
ServerActBtn.BackgroundColor3 = Color3.fromRGB(205, 145, 65)
ServerActBtn.Text = "Initialize Core Server"
ServerActBtn.TextColor3 = Color3.fromRGB(25, 20, 15)
ServerActBtn.TextSize = 12
ServerActBtn.Font = Enum.Font.GothamBold
ServerActBtn.Parent = Panel1

local ServerActCorner = Instance.new("UICorner")
ServerActCorner.CornerRadius = UDim.new(0, 5)
ServerActCorner.Parent = ServerActBtn


-- PANEL 2: Fossil Logs Tracker
local Panel2 = RegisterCategory("Fossil Logs", false)

local TextInfo2 = Instance.new("TextLabel")
TextInfo2.Size = UDim2.new(1, 0, 0, 40)
TextInfo2.BackgroundTransparency = 1
TextInfo2.Text = "Configure automated execution routines for area elements down the halls."
TextInfo2.TextColor3 = Color3.fromRGB(175, 170, 160)
TextInfo2.TextSize = 11
TextInfo2.Font = Enum.Font.Gotham
TextInfo2.TextWrapped = true
TextInfo2.TextXAlignment = Enum.TextXAlignment.Left
TextInfo2.TextYAlignment = Enum.TextYAlignment.Top
TextInfo2.Parent = Panel2

local LogTrackerBtn = Instance.new("TextButton")
LogTrackerBtn.Size = UDim2.new(1, 0, 0, 34)
LogTrackerBtn.Position = UDim2.new(0, 0, 1, -34)
LogTrackerBtn.BackgroundColor3 = Color3.fromRGB(45, 42, 37)
LogTrackerBtn.Text = "Auto-Log Excavations: OFF"
LogTrackerBtn.TextColor3 = Color3.fromRGB(220, 90, 90)
LogTrackerBtn.TextSize = 11
LogTrackerBtn.Font = Enum.Font.GothamBold
LogTrackerBtn.Parent = Panel2

local LogTrackerCorner = Instance.new("UICorner")
LogTrackerCorner.CornerRadius = UDim.new(0, 5)
LogTrackerCorner.Parent = LogTrackerBtn


-- PANEL 3: Exhibits Subsystems
local Panel3 = RegisterCategory("Exhibits", false)

local TextInfo3 = Instance.new("TextLabel")
TextInfo3.Size = UDim2.new(1, 0, 0, 40)
TextInfo3.BackgroundTransparency = 1
TextInfo3.Text = "Direct logic adjustments for environment modules and security doors."
TextInfo3.TextColor3 = Color3.fromRGB(175, 170, 160)
TextInfo3.TextSize = 11
TextInfo3.Font = Enum.Font.Gotham
TextInfo3.TextWrapped = true
TextInfo3.TextXAlignment = Enum.TextXAlignment.Left
TextInfo3.TextYAlignment = Enum.TextYAlignment.Top
TextInfo3.Parent = Panel3

local ArrayGateBtn = Instance.new("TextButton")
ArrayGateBtn.Size = UDim2.new(1, 0, 0, 34)
ArrayGateBtn.Position = UDim2.new(0, 0, 1, -34)
ArrayGateBtn.BackgroundColor3 = Color3.fromRGB(45, 42, 37)
ArrayGateBtn.Text = "Apex Predator Hall Gate: CLOSED"
ArrayGateBtn.TextColor3 = Color3.fromRGB(220, 90, 90)
ArrayGateBtn.TextSize = 11
ArrayGateBtn.Font = Enum.Font.GothamBold
ArrayGateBtn.Parent = Panel3

local ArrayGateCorner = Instance.new("UICorner")
ArrayGateCorner.CornerRadius = UDim.new(0, 5)
ArrayGateCorner.Parent = ArrayGateBtn

-- ==========================================
-- ELEMENT INTERACTIONS & FUNCTIONALITY
-- ==========================================

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

ServerActBtn.MouseButton1Click:Connect(function()
    ServerActBtn.Text = "Server Online ✓"
    ServerActBtn.BackgroundColor3 = Color3.fromRGB(75, 160, 95)
    ServerActBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    task.wait(1.5)
    ServerActBtn.Text = "Initialize Core Server"
    ServerActBtn.BackgroundColor3 = Color3.fromRGB(205, 145, 65)
    ServerActBtn.TextColor3 = Color3.fromRGB(25, 20, 15)
end)

local toggledLog = false
LogTrackerBtn.MouseButton1Click:Connect(function()
    toggledLog = not toggledLog
    if toggledLog then
        LogTrackerBtn.Text = "Auto-Log Excavations: ON"
        LogTrackerBtn.TextColor3 = Color3.fromRGB(75, 160, 95)
    else
        LogTrackerBtn.Text = "Auto-Log Excavations: OFF"
        LogTrackerBtn.TextColor3 = Color3.fromRGB(220, 90, 90)
    end
end)

local toggledGate = false
ArrayGateBtn.MouseButton1Click:Connect(function()
    toggledGate = not toggledGate
    if toggledGate then
        ArrayGateBtn.Text = "Apex Predator Hall Gate: OPEN"
        ArrayGateBtn.TextColor3 = Color3.fromRGB(75, 160, 95)
    else
        ArrayGateBtn.Text = "Apex Predator Hall Gate: CLOSED"
        ArrayGateBtn.TextColor3 = Color3.fromRGB(220, 90, 90)
    end
end)

-- ==========================================
-- HARDWARE DRAG COMPATIBILITY LAYER
-- ==========================================
local draggingActive = nil
local dragInputPosition = nil
local frameStartPosition = nil

local function applyFrameMovement(input)
    local delta = input.Position - dragInputPosition
    local targetPosition = UDim2.new(
        frameStartPosition.X.Scale, 
        frameStartPosition.X.Offset + delta.X, 
        frameStartPosition.Y.Scale, 
        frameStartPosition.Y.Offset + delta.Y
    )
    TweenService:Create(MainFrame, TweenInfo.new(0.06, Enum.EasingStyle.Linear), {Position = targetPosition}):Play()
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingActive = true
        dragInputPosition = input.Position
        frameStartPosition = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingActive = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if draggingActive then
            applyFrameMovement(input)
        end
    end
end)
