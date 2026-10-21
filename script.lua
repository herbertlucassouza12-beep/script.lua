-- SUPER DIGGER AIMBOT MENU (Rayfield)
-- Funciona com executores que suportam loadstring e Drawing

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Variáveis de Configuração
local Config = {
    AimbotEnabled = false,
    FOV = 120,
    TargetPart = "Head", -- Opções: "Head", "Torso", "Foot"
    Smoothness = 0.15,
    AimKey = Enum.KeyCode.E -- Tecla para ativar (segurar)
}

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Criar Janela
local Window = Rayfield:CreateWindow({
   Name = "SUPER DIGGER | Aimbot",
   LoadingTitle = "Carregando...",
   LoadingSubtitle = "by SUPER DIGGER",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil,
      FileName = "SuperDiggerAim"
   },
   KeySystem = false
})

-- Aba Principal
local MainTab = Window:CreateTab("Aimbot", 4483362458)

-- Toggle Aimbot
MainTab:CreateToggle({
   Name = "Ativar Aimbot",
   CurrentValue = false,
   Flag = "AimbotToggle",
   Callback = function(Value)
       Config.AimbotEnabled = Value
   end,
})

-- Slider do FOV
MainTab:CreateSlider({
   Name = "FOV (Raio)",
   Range = {10, 500},
   Increment = 1,
   Suffix = "px",
   CurrentValue = 120,
   Flag = "FOVSlider",
   Callback = function(Value)
       Config.FOV = Value
   end,
})

-- Dropdown para escolher a parte do corpo
MainTab:CreateDropdown({
   Name = "Parte do Corpo",
   Options = {"Head", "Torso", "Foot"},
   CurrentOption = "Head",
   Flag = "PartDropdown",
   Callback = function(Option)
       Config.TargetPart = Option
   end,
})

-- Slider de Suavidade (Smooth)
MainTab:CreateSlider({
   Name = "Suavidade (Menor = Mais rápido)",
   Range = {0.01, 1},
   Increment = 0.01,
   Suffix = "",
   CurrentValue = 0.15,
   Flag = "SmoothSlider",
   Callback = function(Value)
       Config.Smoothness = Value
   end,
})

-- Função para pegar a Posição da Peça (Cabeça, Peito ou Pé)
local function GetTargetPosition(character)
    if not character then return nil end
    
    local part = nil
    
    if Config.TargetPart == "Head" then
        part = character:FindFirstChild("Head")
    elseif Config.TargetPart == "Torso" then
        -- Tenta achar o Torso superior ou o HumanoidRootPart
        part = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso") or character:FindFirstChild("HumanoidRootPart")
    elseif Config.TargetPart == "Foot" then
        -- Tenta achar o pé esquerdo ou direito
        part = character:FindFirstChild("LeftFoot") or character:FindFirstChild("RightFoot") or character:FindFirstChild("LeftLeg") or character:FindFirstChild("RightLeg")
    end
    
    return part
end

-- Função para achar o jogador mais próximo do centro da tela (dentro do FOV)
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

-- Loop de Mira (RenderStepped)
RunService.RenderStepped:Connect(function()
    if Config.AimbotEnabled then
        -- Verifica se a tecla está pressionada (padrão E)
        if UserInputService:IsKeyDown(Config.AimKey) then
            local targetPlayer = GetClosestPlayerInFOV()
            
            if targetPlayer then
                local targetPart = GetTargetPosition(targetPlayer.Character)
                if targetPart then
                    -- Calcula a CFrame para olhar para o alvo
                    local lookAt = CFrame.new(Camera.CFrame.Position, targetPart.Position)
                    -- Aplica a suavidade (Lerp)
                    Camera.CFrame = Camera.CFrame:Lerp(lookAt, Config.Smoothness)
                end
            end
        end
    end
end)

-- Desenhar o Círculo do FOV na tela
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1
fovCircle.NumSides = 64
fovCircle.Radius = Config.FOV
fovCircle.Filled = false
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Transparency = 0.7
fovCircle.Visible = true

-- Atualiza o círculo quando o FOV muda
RunService.RenderStepped:Connect(function()
    fovCircle.Position = UserInputService:GetMouseLocation()
    fovCircle.Radius = Config.FOV
end)

Rayfield:Notify({
   Title = "SUPER DIGGER",
   Content = "Menu carregado. Pressione E para mirar.",
   Duration = 5,
   Image = 4483362458,
})
