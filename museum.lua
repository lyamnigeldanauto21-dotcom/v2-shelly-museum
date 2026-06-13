-- Shelly's Dinosaur Museum - Client Interface
-- Built for Mobile Executors | Glitch-Free Layering

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Safe PlayerGui targeting to prevent Anti-Cheat blocks
local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")

-- Clean up any old duplicate windows instantly
if PlayerGui:FindFirstChild("ShellyMuseumUI") then
    PlayerGui.ShellyMuseumUI:Destroy()
end

-- Base Container
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ShellyMuseumUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- Main Interface Box (Deep Volcanic Slate Grey)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 220)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -110) -- Perfectly Centered
MainFrame.BackgroundColor3 = Color3.fromRGB(28, 27, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Top Drag Header (Dinosaur Fossil Dark Amber Accent)
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(43, 38, 31)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

-- Fixes corner clipping on the bottom of the title bar
local TitleVisualFix = Instance.new("Frame")
TitleVisualFix.Size = UDim2.new(1, 0, 0, 10)
TitleVisualFix.Position = UDim2.new(0, 0, 1, -10)
TitleVisualFix.BackgroundColor3 = Color3.fromRGB(43, 38, 31)
TitleVisualFix.BorderSizePixel = 0
TitleVisualFix.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Size = UDim2.new(1, -50, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "Shelly's Dinosaur Museum"
TitleText.TextColor3 = Color3.fromRGB(245, 195, 115) -- Amber Gold
TitleText.TextSize = 14
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Close Button (✕)
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 26, 0, 26)
CloseButton.Position = UDim2.new(1, -33, 0, 7)
CloseButton.BackgroundColor3 = Color3.fromRGB(190, 65, 65)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 12
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

-- Center Exhibition Status text
local ContentText = Instance.new("TextLabel")
ContentText.Name = "ContentText"
ContentText.Size = UDim2.new(1, -30, 0, 65)
ContentText.Position = UDim2.new(0, 15, 0, 55)
ContentText.BackgroundTransparency = 1
ContentText.Text = "Welcome to the Museum network terminal. Initialize the sub-systems below to configure excavation logs and exhibit data profiles."
ContentText.TextColor3 = Color3.fromRGB(190, 185, 175)
ContentText.TextSize = 12
ContentText.Font = Enum.Font.Gotham
ContentText.TextWrapped = true
ContentText.TextYAlignment = Enum.TextYAlignment.Top
ContentText.TextXAlignment = Enum.TextXAlignment.Left
ContentText.Parent = MainFrame

-- Primary Action Button (Amber Highlight)
local ActionButton = Instance.new("TextButton")
ActionButton.Name = "ActionButton"
ActionButton.Size = UDim2.new(1, -30, 0, 42)
ActionButton.Position = UDim2.new(0, 15, 1, -55)
ActionButton.BackgroundColor3 = Color3.fromRGB(205, 145, 65)
ActionButton.Text = "Initialize System"
ActionButton.TextColor3 = Color3.fromRGB(25, 20, 15)
ActionButton.TextSize = 14
ActionButton.Font = Enum.Font.GothamBold
ActionButton.Parent = MainFrame

local ActionCorner = Instance.new("UICorner")
ActionCorner.CornerRadius = UDim.new(0, 8)
ActionCorner.Parent = ActionButton


----------------- GLITCH-FREE CONTROLS -----------------

-- Immediate Window Close
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Button Click Feedback Cycle
ActionButton.MouseButton1Click:Connect(function()
    ActionButton.Text = "System Active ✓"
    ActionButton.BackgroundColor3 = Color3.fromRGB(75, 160, 95) -- Success Green
    ActionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    task.wait(1.2)
    
    ActionButton.Text = "Initialize System"
    ActionButton.BackgroundColor3 = Color3.fromRGB(205, 145, 65) -- Reset Amber
    ActionButton.TextColor3 = Color3.fromRGB(25, 20, 15)
end)

-- Tween-Smoothed Touch Dragging System for Mobile Devices
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
