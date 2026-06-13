-- Shelly's Museum V1.5
-- Core Optimization | Retro-Animated Loading Sequence | Visual Engine

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")

-- Prevent duplication crashes
if PlayerGui:FindFirstChild("ShellyMuseumUI") then
    PlayerGui.ShellyMuseumUI:Destroy()
end

-- Screen Container
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ShellyMuseumUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- ==========================================
-- ANIMATED RETRO LOADING SEQUENCE
-- ==========================================
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Name = "LoadingFrame"
LoadingFrame.Size = UDim2.new(0, 260, 0, 90)
LoadingFrame.Position = UDim2.new(0.5, -130, 0.5, -45)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(24, 23, 20)
LoadingFrame.BorderSizePixel = 0
LoadingFrame.Parent = ScreenGui

local LoadCorner = Instance.new("UICorner")
LoadCorner.CornerRadius = UDim.new(0, 8)
LoadCorner.Parent = LoadingFrame

local LoadText = Instance.new("TextLabel")
LoadText.Size = UDim2.new(1, 0, 0, 40)
LoadText.Position = UDim2.new(0, 0, 0, 10)
LoadText.BackgroundTransparency = 1
LoadText.Text = "Loading Database..."
LoadText.TextColor3 = Color3.fromRGB(245, 195, 115)
LoadText.TextSize = 13
LoadText.Font = Enum.Font.GothamBold
LoadText.Parent = LoadingFrame

local BarTrack = Instance.new("Frame")
BarTrack.Size = UDim2.new(0.8, 0, 0, 6)
BarTrack.Position = UDim2.new(0.1, 0, 0, 55)
BarTrack.BackgroundColor3 = Color3.fromRGB(38, 33, 27)
BarTrack.BorderSizePixel = 0
BarTrack.Parent = LoadingFrame
Instance.new("UICorner", BarTrack).CornerRadius = UDim.new(0, 3)

local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(205, 145, 65)
BarFill.BorderSizePixel = 0
BarFill.Parent = BarTrack
Instance.new("UICorner", BarFill).CornerRadius = UDim.new(0, 3)

-- Smooth Loading Simulation
local FillTween = TweenService:Create(BarFill, TweenInfo.new(1.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)})
FillTween:Play()
FillTween.Completed:Wait()

task.wait(0.2)
LoadingFrame:Destroy()

-- ==========================================
-- MAIN INTERFACE HUB (REDUCED AND OPTIMIZED)
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 360, 0, 220)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -110)
MainFrame.BackgroundColor3 = Color3.fromRGB(24, 23, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Top Bar Panel
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
TitleText.Position = UDim2.new(0, 12, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "Shelly's Museum V1.5"
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
Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0, 4)

-- 1-Category Layout Grid Architecture
local SidebarFrame = Instance.new("Frame")
SidebarFrame.Size = UDim2.new(0.28, 0, 1, -36)
SidebarFrame.Position = UDim2.new(0, 0, 0, 36)
SidebarFrame.BackgroundColor3 = Color3.fromRGB(31, 29, 25)
SidebarFrame.BorderSizePixel = 0
SidebarFrame.Parent = MainFrame

local ContentWindow = Instance.new("Frame")
ContentWindow.Size = UDim2.new(0.72, 0, 1, -36)
ContentWindow.Position = UDim2.new(0.28, 0, 0, 36)
ContentWindow.BackgroundTransparency = 1
ContentWindow.Parent = MainFrame

local PagePadding = Instance.new("UIPadding")
PagePadding.Parent = ContentWindow
PagePadding.PaddingTop = UDim.new(0, 12)
PagePadding.PaddingLeft = UDim.new(0, 12)
PagePadding.PaddingRight = UDim.new(0, 12)

-- Primary Visual Category Tab Button
local VisualBtn = Instance.new("TextButton")
VisualBtn.Size = UDim2.new(0.85, 0, 0, 30)
VisualBtn.Position = UDim2.new(0.075, 0, 0, 10)
VisualBtn.BackgroundColor3 = Color3.fromRGB(43, 38, 31)
VisualBtn.Text = "Visual"
VisualBtn.TextColor3 = Color3.fromRGB(245, 195, 115)
VisualBtn.TextSize = 11
VisualBtn.Font = Enum.Font.GothamBold
VisualBtn.Parent = SidebarFrame
Instance.new("UICorner", VisualBtn).CornerRadius = UDim.new(0, 4)

-- List Layout for Buttons inside the Content Window
local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Parent = ContentWindow
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Padding = UDim.new(0, 8)

-- ==========================================
-- OPTIMIZED VISUAL TAB OVERLAYS
-- ==========================================
local function CreateVisualToggle(text)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 36)
    Frame.BackgroundColor3 = Color3.fromRGB(28, 26, 23)
    Frame.BorderSizePixel = 0
    Frame.Parent = ContentWindow
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 4)
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.65, 0, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(185, 180, 170)
    Label.TextSize = 11
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(0, 45, 0, 20)
    Toggle.Position = UDim2.new(1, -55, 0.5, -10)
    Toggle.BackgroundColor3 = Color3.fromRGB(45, 42, 37)
    Toggle.Text = "OFF"
    Toggle.TextColor3 = Color3.fromRGB(220, 90, 90)
    Toggle.TextSize = 9
    Toggle.Font = Enum.Font.GothamBold
    Toggle.Parent = Frame
    Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 4)
    
    -- Optimized State Tweens
    local State = false
    Toggle.MouseButton1Click:Connect(function()
        State = not State
        local TargetColor = State and Color3.fromRGB(75, 160, 95) or Color3.fromRGB(45, 42, 37)
        local TargetTextColor = State and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(220, 90, 90)
        
        TweenService:Create(Toggle, TweenInfo.new(0.12, Enum.EasingStyle.Quad), {
            BackgroundColor3 = TargetColor,
            TextColor3 = TargetTextColor
        }):Play()
        
        Toggle.Text = State and "ON" or "OFF"
    end)
end

-- Deploy Options within boundaries
CreateVisualToggle("Toon Tracker ESP")
CreateVisualToggle("Wall-Chams Engine")

-- ==========================================
-- HARDWARE ACCELERATED INTERACTION (DRAGGING)
-- ==========================================
CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

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
