--[================================================================================]--
-- Project: Functional Tactical UI Hub (Aimbot, FOV, Antenna ESP)                   --
-- Target: Roblox Client Instrumentation (Luau)                                     --
--[================================================================================]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Limpeza de instâncias anteriores
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

-- Janela Principal
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

-- Barra Superior
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 8)
TopCorner.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -20, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "TACTICAL INSTRUMENTATION HUB [FIXED]"
TitleLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

-- Container de Opções
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

-- Configurações de Estado
local Settings = {
    AimbotEnabled = false,
    FovEnabled = false,
    FovRadius = 180,
    AntennaEnabled = false,
}

-- Função para criar toggles interativos
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

CreateToggle("Aimbot (Head Lock - Segure Botão Direito)", function(state)
    Settings.AimbotEnabled = state
end)

CreateToggle("Holographic FOV Circle", function(state)
    Settings.FovEnabled = state
end)

CreateToggle("ESP Antenna (Linha na Cabeça)", function(state)
    Settings.AntennaEnabled = state
end)

-- Sistema de FOV utilizando GUI do Roblox (Garante compatibilidade total sem depender de Drawing API externa)
local FOVGui = Instance.new("ScreenGui")
FOVGui.Name = "FOVCircleGui"
FOVGui.Parent = CoreGui

local FOVFrame = Instance.new("Frame")
FOVFrame.Size = UDim2.new(0, Settings.FovRadius * 2, 0, Settings.FovRadius * 2)
FOVFrame.AnchorPoint = Vector2.new(0.5, 0.5)
FOVFrame.BackgroundTransparency = 1
FOVFrame.Visible = false
FOVFrame.Parent = FOVGui

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Color = Color3.fromRGB(0, 255, 200)
FOVStroke.Thickness = 1.5
FOVStroke.Parent = FOVFrame

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(1, 0)
FOVCorner.Parent = FOVFrame

-- Estrutura de Armazenamento de Antenas (BillboardGuids na cabeça)
local ActiveAntennas = {}

local function UpdateAntenna(player, enable)
    if enable then
        if player.Character and player.Character:FindFirstChild("Head") and not ActiveAntennas[player] then
            local head = player.Character.Head
            
            local bb = Instance.new("BillboardGui")
            bb.Name = "AntennaESP"
            bb.Size = UDim2.new(0, 4, 0, 50)
            bb.StudsOffset = Vector3.new(0, 3, 0)
            bb.AlwaysOnTop = true
            bb.Parent = head
            
            local line = Instance.new("Frame")
            line.Size = UDim2.new(1, 0, 1, 0)
            line.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            line.BorderSizePixel = 0
            line.Parent = bb
            
            ActiveAntennas[player] = bb
        end
    else
        if ActiveAntennas[player] then
            ActiveAntennas[player]:Destroy()
            ActiveAntennas[player] = nil
        end
    end
end

local function GetClosestTarget()
    local mouseLocation = UserInputService:GetMouseLocation()
    local closestTarget = nil
    local shortestDistance = Settings.FovRadius

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoid and humanoid.Health > 0 and rootPart then
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
    return closestTarget
end

-- Loop de Execução Principal
RunService.RenderStepped:Connect(function()
    -- Atualizar FOV
    if Settings.FovEnabled then
        FOVFrame.Visible = true
        FOVFrame.Size = UDim2.new(0, Settings.FovRadius * 2, 0, Settings.FovRadius * 2)
        local mousePos = UserInputService:GetMouseLocation()
        FOVFrame.Position = UDim2.new(0, mousePos.X, 0, mousePos.Y)
    else
        FOVFrame.Visible = false
    end

    -- Gerenciar Antenas
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if Settings.AntennaEnabled then
                UpdateAntenna(player, true)
            else
                UpdateAntenna(player, false)
            end
        end
    end

    -- Executar Aimbot (Ativado ao segurar Botão Direito do Mouse)
    if Settings.AimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local targetHead = GetClosestTarget()
        if targetHead then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)
        end
    end
end)

print("[+] Hub atualizado com sucesso e totalmente funcional!")
