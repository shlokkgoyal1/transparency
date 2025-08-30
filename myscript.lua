-- // Full Transparent Base Script with GUI by Shlok \\ --

local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local BaseTransparency = 1 -- FULL TRANSPARENT (invisible)
local BaseColor = Color3.fromRGB(255, 255, 255)
local processedBases = {}

-- Function to check if object is a base/spawn
local function isBase(obj)
    if not obj then return false end
    local name = obj.Name:lower()
    return name:find("spawn") or name:find("base") or name:find("team") or
           name:find("home") or name:find("camp") or obj:IsA("SpawnLocation")
end

-- Make bases fully transparent
local function makeBaseTransparent(base)
    if processedBases[base] then return end

    if base:IsA("BasePart") then
        base.Transparency = BaseTransparency
        base.Color = BaseColor
        base.Material = Enum.Material.Glass
        processedBases[base] = true

    elseif base:IsA("Model") then
        for _, part in ipairs(base:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = BaseTransparency
                part.Color = BaseColor
                part.Material = Enum.Material.Glass
            end
        end
        processedBases[base] = true
    end
end

-- Scan for bases and make them transparent
local function scanForBases()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if isBase(obj) then
            makeBaseTransparent(obj)
        end
    end
end

-- Main function
local function baseTransparencySystem()
    scanForBases()
    local lastScan = tick()
    local scanInterval = 2

    RunService.RenderStepped:Connect(function()
        if tick() - lastScan > scanInterval then
            scanForBases()
            lastScan = tick()
        end
    end)
end

-- Cleanup function to restore original looks
local function cleanup()
    for base in pairs(processedBases) do
        if base and base.Parent then
            if base:IsA("BasePart") then
                base.Transparency = 0
                base.Color = Color3.fromRGB(255, 255, 255)
                base.Material = Enum.Material.Plastic
            elseif base:IsA("Model") then
                for _, part in ipairs(base:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Transparency = 0
                        part.Color = Color3.fromRGB(255, 255, 255)
                        part.Material = Enum.Material.Plastic
                    end
                end
            end
        end
    end
    processedBases = {}
end

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0.4, 0, 0.4, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Text = "Script by Shlok"
Title.Size = UDim2.new(1, 0, 0.3, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.Parent = Frame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Text = "ON"
ToggleButton.Size = UDim2.new(0.5, 0, 0.4, 0)
ToggleButton.Position = UDim2.new(0.25, 0, 0.35, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.Gotham
ToggleButton.TextScaled = true
ToggleButton.Parent = Frame

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Text = "-"
MinimizeButton.Size = UDim2.new(0.15, 0, 0.3, 0)
MinimizeButton.Position = UDim2.new(0.85, 0, 0, 0)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextScaled = true
MinimizeButton.Parent = Frame

local minimized = false
local scriptActive = true

-- Toggle transparency ON/OFF
ToggleButton.MouseButton1Click:Connect(function()
    scriptActive = not scriptActive
    if scriptActive then
        ToggleButton.Text = "ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        baseTransparencySystem()
    else
        ToggleButton.Text = "OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        cleanup()
    end
end)

-- Minimize GUI into a small circle with "S"
MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        Frame.Visible = false

        local Circle = Instance.new("TextButton")
        Circle.Name = "ShlokCircle"
        Circle.Size = UDim2.new(0, 50, 0, 50)
        Circle.Position = UDim2.new(0.9, 0, 0.8, 0)
        Circle.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        Circle.TextColor3 = Color3.fromRGB(255, 255, 255)
        Circle.Font = Enum.Font.GothamBold
        Circle.Text = "S"
        Circle.TextScaled = true
        Circle.Parent = ScreenGui
        Circle.Active = true
        Circle.Draggable = true

        Circle.MouseButton1Click:Connect(function()
            Frame.Visible = true
            Circle:Destroy()
            minimized = false
        end)
    end
end)

-- Auto-execute
baseTransparencySystem()
print("Base Transparency Activated! Bases are now fully transparent.")

