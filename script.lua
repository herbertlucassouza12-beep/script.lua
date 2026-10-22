-- SUPER DIGGER AIMBOT (Câmera Travada / Lock)
-- Cole e execute no seu executor.

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Variáveis de Configuração
local Config = {
    AimbotEnabled = false,
    FOV = 150,
    TargetPart = "Head",
    AimKey = Enum.KeyCode.E
}

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Janela
local Window = Rayfield:CreateWindow({
   Name = "SUPER DIGGER | Aimbot LOCK",
   LoadingTitle = "Carregando...",
   LoadingSubtitle = "by SUPER DIGGER",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

local MainTab = Window:CreateTab("Aimbot", 4483362458)

MainTab:CreateToggle({
   Name = "Ativar Aimbot",
   CurrentValue = false,
   Flag = "AimbotToggle",
   Callback = function(Value)
       Config.AimbotEnabled = Value
   end,
})

MainTab:CreateSlider({
   Name = "FOV (Raio)",
   Range = {10, 800},
   Increment = 1,
   Suffix = "px",
   CurrentValue = 150,
   Flag = "FOVSlider",
   Callback = function(Value)
       Config.FOV = Value
   end,
})

MainTab:CreateDropdown({
   Name = "Parte do Corpo",
   Options = {"Head", "Torso", "Foot"},
   CurrentOption = "Head",
   Flag = "PartDropdown",
   Callback = function(Option)
       Config.TargetPart = Option
   end,
})

-- Função de pegar a peça
local function GetTargetPosition(character)
    if not character then return nil end
    local part = nil
    if Config.TargetPart == "Head" then
        part = character:FindFirstChild("Head")
    elseif Config.TargetPart == "Torso" then
        part = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso") or character:FindFirstChild("HumanoidRootPart")
    elseif Config.TargetPart == "Foot" then
        part = character:FindFirstChild("LeftFoot") or character:FindFirstChild("RightFoot") or character:FindFirstChild("LeftLeg") or character:FindFirstChild("RightLeg")
    end
    return part
end

-- Função de achar o alvo mais próximo no FOV
local function GetClosestPlayerInFOV()
    local closestPlayer = nil
    local shortestDistance = Config.FOV
    local mousePos = UserInputService:GetMouseLocation()
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local targetPart = GetTargetPosition(player.Character)
            if targetPart then
                local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end
    return closestPlayer
end

-- Loop de Mira Instantânea (Lock)
RunService.RenderStepped:Connect(function()
    if Config.AimbotEnabled and UserInputService:IsKeyDown(Config.AimKey) then
        local targetPlayer = GetClosestPlayerInFOV()
        
        if targetPlayer then
            local targetPart = GetTargetPosition(targetPlayer.Character)
            if targetPart then
                -- Pega a posição da câmera e a posição da cabeça
                local cameraPos = Camera.CFrame.Position
                local targetPos = targetPart.Position
                
                -- Calcula a matriz de rotação perfeita (LookAt) e força a câmera
                Camera.CFrame = CFrame.new(cameraPos, targetPos)
            end
        end
    end
end)

-- Círculo do FOV
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1.5
fovCircle.NumSides = 64
fovCircle.Radius = Config.FOV
fovCircle.Filled = false
fovCircle.Color = Color3.fromRGB(0, 255, 136)
fovCircle.Transparency = 0.8
fovCircle.Visible = true

RunService.RenderStepped:Connect(function()
    fovCircle.Position = UserInputService:GetMouseLocation()
    fovCircle.Radius = Config.FOV
end)
