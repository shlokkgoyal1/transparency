-- // Full Transparent Base Script with GUI by Shlok \\ --
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- CONFIG
local BaseTransparency = 0.7 -- 70% transparent for glass effect
local BaseColor = Color3.fromRGB(255, 255, 255)
local processedBases = {}
local scriptEnabled = true

-- GUI CREATION
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ShlokScriptGUI"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

-- MAIN FRAME
local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 2
Frame.Position = UDim2.new(0.35, 0, 0.3, 0)
Frame.Size = UDim2.new(0, 300, 0, 150)
Frame.Active = true
Frame.Draggable = true
Frame.Visible = true

-- TITLE BAR
local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Text = "Script by Shlok"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

-- TOGGLE BUTTON
local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = Frame
ToggleButton.Size = UDim2.new(1, -20, 0, 40)
ToggleButton.Position = UDim2.new(0, 10, 0, 50)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ToggleButton.Text = "Turn OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 18
ToggleButton.BorderSizePixel = 0

-- CLOSE BUTTON
local CloseButton = Instance.new("TextButton")
CloseButton.Parent = Frame
CloseButton.Size = UDim2.new(0.48, 0, 0, 40)
CloseButton.Position = UDim2.new(0, 10, 0, 100)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.Text = "Close"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 18
CloseButton.BorderSizePixel = 0

-- MINIMIZE BUTTON
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Parent = Frame
MinimizeButton.Size = UDim2.new(0.48, 0, 0, 40)
MinimizeButton.Position = UDim2.new(0.52, 0, 0, 100)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
MinimizeButton.Text = "Minimize"
MinimizeButton.TextColor3 = Color3.fromRGB(0, 0, 0)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 18
MinimizeButton.BorderSizePixel = 0

-- SMALL CIRCLE BUTTON (WHEN MINIMIZED)
local CircleButton = Instance.new("TextButton")
CircleButton.Parent = ScreenGui
CircleButton.Size = UDim2.new(0, 50, 0, 50)
CircleButton.Position = UDim2.new(0.4, 0, 0.3, 0)
CircleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
CircleButton.Text = "S"
CircleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CircleButton.Font = Enum.Font.GothamBold
CircleButton.TextSize = 24
CircleButton.Visible = false
CircleButton.BorderSizePixel = 0
CircleButton.Active = true
CircleButton.Draggable = true
CircleButton.ZIndex = 10
CircleButton.AutoButtonColor = true
CircleButton.ClipsDescendants = true

-- ROUND THE CIRCLE BUTTON
local UICorner = Instance.new("UICorner")
UICorner.Parent = CircleButton
UICorner.CornerRadius = UDim.new(1, 0)

-- FUNCTION TO CHECK IF AN OBJECT IS A BASE
local function isBase(obj)
    if not obj then return false end
    local name = obj.Name:lower()
    return name:find("spawn") or name:find("base") or name:find("team") or
           name:find("home") or name:find("camp") or obj:IsA("SpawnLocation")
end

-- FUNCTION TO MAKE BASE TRANSPARENT (GLASS EFFECT)
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

-- SCAN FOR BASES
local function scanForBases()
    if not scriptEnabled then return end
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if isBase(obj) then
            makeBaseTransparent(obj)
        end
    end
end

-- CLEANUP FUNCTION
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

-- MAIN SCRIPT
local lastScan = tick()
local scanInterval = 2

RunService.RenderStepped:Connect(function()
    if scriptEnabled and tick() - lastScan > scanInterval then
        scanForBases()
        lastScan = tick()
    end
end)

-- TOGGLE BUTTON FUNCTION
ToggleButton.MouseButton1Click:Connect(function()
    scriptEnabled = not scriptEnabled
    if scriptEnabled then
        ToggleButton.Text = "Turn OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        scanForBases()
    else
        ToggleButton.Text = "Turn ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        cleanup()
    end
end)

-- CLOSE BUTTON FUNCTION
CloseButton.MouseButton1Click:Connect(function()
    cleanup()
    ScreenGui:Destroy()
end)

-- MINIMIZE BUTTON FUNCTION
MinimizeButton.MouseButton1Click:Connect(function()
    Frame.Visible = false
    CircleButton.Visible = true
end)

-- RESTORE MAIN FRAME FROM CIRCLE BUTTON
CircleButton.MouseButton1Click:Connect(function()
    Frame.Visible = true
    CircleButton.Visible = false
end)

print("Base Transparency Script by Shlok Loaded!")


