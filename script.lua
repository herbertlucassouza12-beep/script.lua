--[================================================================================]--
-- Project: Functional Tactical UI Hub (Aimbot, Holographic FOV, Antenna ESP)       --
-- Target: Roblox Client Instrumentation (Luau)                                     --
--[================================================================================]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Prevent duplicate instances
if CoreGui:FindFirstChild("TacticalEngineeringHub") then
    CoreGui.TacticalEngineeringHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TacticalEngineeringHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Main Window Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 380)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(50, 50, 70)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Top Bar / Title
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 8)
TopCorner.Parent = TopBar

local FixTop = Instance.new("Frame")
FixTop.Size = UDim2.new(1, 0, 0, 10)
FixTop.Position = UDim2.new(0, 0, 1, -10)
FixTop.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
FixTop.BorderSizePixel = 0
FixTop.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -20, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "TACTICAL INSTRUMENTATION HUB [ACTIVE]"
TitleLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

-- Content Container
local ContentContainer = Instance.new("ScrollingFrame")
ContentContainer.Size = UDim2.new(1, -20, 1, -60)
ContentContainer.Position = UDim2.new(0, 10, 0, 50)
ContentContainer.BackgroundTransparency = 1
ContentContainer.BorderSizePixel = 0
ContentContainer.CanvasSize = UDim2.new(0, 0, 0, 320)
ContentContainer.ScrollBarThickness = 4
ContentContainer.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0, 10)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Parent = ContentContainer

-- State Configuration
local Settings = {
    AimbotEnabled = false,
    FovEnabled = false,
    FovRadius = 150,
    AntennaEnabled = false,
}

-- Helper function to create functional toggles
local function CreateToggle(name, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 36)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 36)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = ContentContainer

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = ToggleFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.GothamMedium
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(190, 190, 210)
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 40, 0, 20)
    ToggleBtn.Position = UDim2.new(1, -50, 0.5, -10)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    ToggleBtn.AutoButtonColor = false
    ToggleBtn.Text = ""
    ToggleBtn.Parent = ToggleFrame

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(1, 0)
    BtnCorner.Parent = ToggleBtn

    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 16, 0, 16)
    Indicator.Position = UDim2.new(0, 2, 0.5, -8)
    Indicator.BackgroundColor3 = Color3.fromRGB(200, 200, 220)
    Indicator.BorderSizePixel = 0
    Indicator.Parent = ToggleBtn

    local IndCorner = Instance.new("UICorner")
    IndCorner.CornerRadius = UDim.new(1, 0)
    IndCorner.Parent = Indicator

    local state = false
    ToggleBtn.MouseButton1Click:Connect(function()
        state = not state
        local targetColor = state and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(45, 45, 60)
        local targetPos = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        
        ToggleBtn.BackgroundColor3 = state and Color3.fromRGB(40, 100, 60) or Color3.fromRGB(45, 45, 60)
        Indicator.Position = targetPos
        Indicator.BackgroundColor3 = targetColor

        if callback then
            callback(state)
        end
    end)
end

-- Hook Toggles to State Flags
CreateToggle("Aimbot (Head Lock - Segure Botão Direito)", function(state)
    Settings.AimbotEnabled = state
end)

CreateToggle("Holographic FOV Circle", function(state)
    Settings.FovEnabled = state
end)

CreateToggle("ESP Antenna (Linha na Cabeça)", function(state)
    Settings.AntennaEnabled = state
end)

-- Draggable Window Logic
local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- FOV Circle Drawing Creation
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 64
FOVCircle.Filled = false
FOVCircle.Transparency = 0.7
FOVCircle.Color = Color3.fromRGB(0, 255, 200)
FOVCircle.Visible = false

-- Antenna Storage Tracking
local AntennaDrawings = {}

local function GetClosestTarget()
    local mouseLocation = UserInputService:GetMouseLocation()
    local closestTarget = nil
    local shortestDistance = Settings.FovRadius

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoid and humanoid.Health > 0 and rootPart then
                -- Opcional: checagem de time (caso o jogo utilize Teams)
                local isEnemy = true
                if LocalPlayer.Team and player.Team and LocalPlayer.Team == player.Team then
                    isEnemy = false
                end

                if isEnemy then
                    local head = player.Character.Head
                    local screenPoint, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - mouseLocation).Magnitude
                        if distance < shortestDistance then
                            shortestDistance = distance
                            closestTarget = head
                        end
                    end
                end
            end
        end
    end
    return closestTarget
end

-- Main Runtime Loop for Features (Aimbot, FOV & Antenas)
RunService.RenderStepped:Connect(function()
    -- 1. FOV Circle Update
    if Settings.FovEnabled then
        FOVCircle.Visible = true
        FOVCircle.Radius = Settings.FovRadius
        FOVCircle.Position = UserInputService:GetMouseLocation()
    else
        FOVCircle.Visible = false
    end

    -- 2. Antenna ESP Update (Linha vertical subindo da cabeça)
    if Settings.AntennaEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local head = player.Character.Head
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                
                if humanoid and humanoid.Health > 0 then
                    if not AntennaDrawings[player] then
                        local line = Drawing.new("Line")
                        line.Thickness = 2
                        line.Color = Color3.fromRGB(255, 50, 50)
                        line.Transparency = 0.8
                        AntennaDrawings[player] = line
                    end

                    local line = AntennaDrawings[player]
                    local topWorldPos = head.Position + Vector3.new(0, 3.5, 0) -- Altura da antena acima da cabeça
                    
                    local headScreen, headOnScreen = Camera:WorldToViewportPoint(head.Position)
                    local topScreen, topOnScreen = Camera:WorldToViewportPoint(topWorldPos)

                    if headOnScreen and topOnScreen then
                        line.From = Vector2.new(headScreen.X, headScreen.Y)
                        line.To = Vector2.new(topScreen.X, topScreen.Y)
                        line.Visible = true
                    else
                        line.Visible = false
                    end
                else
                    if AntennaDrawings[player] then
                        AntennaDrawings[player].Visible = false
                    end
                end
            end
        end
    else
        -- Limpar antenas se desativado
        for _, line in pairs(AntennaDrawings) do
            line.Visible = false
        end
    end

    -- 3. Aimbot Execution (Grudar na cabeça ao segurar Botão Direito do Mouse)
    if Settings.AimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local targetHead = GetClosestTarget()
        if targetHead then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)
        end
    end
end)

-- Limpeza ao sair ou resetar
Players.PlayerRemoving:Connect(function(player)
    if AntennaDrawings[player] then
        AntennaDrawings[player]:Remove()
        AntennaDrawings[player] = nil
    end
end)

print("[+] Tactical Hub successfully loaded and fully functional.")
