-- MINI UI - Estrutura Base (Estilo da Imagem)
-- Adapte as funções internas conforme o jogo.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- CONFIGURAÇÕES DE ESTADO
-- ==========================================
local State = {
    AutoKick = false,
    AutoBuy = false,
    InvisAngle = 180,
    StealSpeed = 20,
    AutoDestroy = false
}

-- ==========================================
-- CRIAÇÃO DA INTERFACE (UI)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MiniUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Size = UDim2.new(0, 200, 0, 280)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "I Mini UI"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Parent = MainFrame

-- Separador
local Sep = Instance.new("Frame")
Sep.Size = UDim2.new(1, -20, 0, 1)
Sep.Position = UDim2.new(0, 10, 0, 30)
Sep.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Sep.BorderSizePixel = 0
Sep.Parent = MainFrame

-- Container de Scroll (para os botões)
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -10, 1, -40)
Scroll.Position = UDim2.new(0, 5, 0, 35)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 2
Scroll.CanvasSize = UDim2.new(0, 0, 1.5, 0)
Scroll.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 6)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Scroll

-- ==========================================
-- FUNÇÕES AUXILIARES PARA CRIAR BOTÕES
-- ==========================================
local function CreateLabel(text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(150, 150, 150)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = Scroll
    return lbl
end

local function CreateButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 28)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Parent = Scroll
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ==========================================
-- SEÇÃO: AUTO
-- ==========================================
CreateLabel("AUTO")

-- Auto Kick (Sai do jogo)
local kickBtn = CreateButton("Auto Kick [OFF]", function()
    State.AutoKick = not State.AutoKick
    kickBtn.Text = "Auto Kick " .. (State.AutoKick and "[ON]" or "[OFF]")
    if State.AutoKick then
        -- Lógica para sair do jogo (Kick local)
        -- O Roblox permite que o cliente se auto-expulse.
        LocalPlayer:Kick("Auto Kick Ativado")
    end
end)

-- Auto Buy (Placeholder)
CreateButton("Auto Buy [OFF]", function()
    -- Lógica específica do jogo aqui
    print("Auto Buy toggle")
end)

-- ==========================================
-- SEÇÃO: PRESETS
-- ==========================================
CreateLabel("PRESETS")

-- Slider Simples (Visual e Funcional para Speed)
local speedFrame = Instance.new("Frame")
speedFrame.Size = UDim2.new(1, 0, 0, 50)
speedFrame.BackgroundTransparency = 1
speedFrame.Parent = Scroll

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.5, 0, 0, 20)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Steal Speed"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 12
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = speedFrame

local speedValue = Instance.new("TextLabel")
speedValue.Size = UDim2.new(0.5, 0, 0, 20)
speedValue.Position = UDim2.new(0.5, 0, 0, 0)
speedValue.BackgroundTransparency = 1
speedValue.Text = tostring(State.StealSpeed)
speedValue.TextColor3 = Color3.fromRGB(255, 255, 255)
speedValue.Font = Enum.Font.GothamBold
speedValue.TextSize = 12
speedValue.TextXAlignment = Enum.TextXAlignment.Right
speedValue.Parent = speedFrame

-- Barra de fundo do slider
local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(1, 0, 0, 6)
barBg.Position = UDim2.new(0, 0, 0, 25)
barBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
barBg.BorderSizePixel = 0
barBg.Parent = speedFrame

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(0, 3)
barCorner.Parent = barBg

-- Preenchimento do slider
local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0.2, 0, 1, 0) -- 20% inicial
barFill.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
barFill.BorderSizePixel = 0
barFill.Parent = barBg

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0, 3)
fillCorner.Parent = barFill

-- Botão invisível para arrastar o slider
local dragBtn = Instance.new("TextButton")
dragBtn.Size = UDim2.new(1, 0, 1, 0)
dragBtn.BackgroundTransparency = 1
dragBtn.Text = ""
dragBtn.Parent = barBg

local isDragging = false

dragBtn.MouseButton1Down:Connect(function()
    isDragging = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)

RunService.RenderStepped:Connect(function()
    if isDragging then
        local mouse = UserInputService:GetMouseLocation()
        local barPos = barBg.AbsolutePosition
        local barSize = barBg.AbsoluteSize
        local relativeX = math.clamp((mouse.X - barPos.X) / barSize.X, 0, 1)
        
        barFill.Size = UDim2.new(relativeX, 0, 1, 0)
        -- Mapear 0-1 para 0-100 (exemplo de range)
        State.StealSpeed = math.floor(relativeX * 100)
        speedValue.Text = tostring(State.StealSpeed)
    end
end)

-- ==========================================
-- SEÇÃO: SESSÃO
-- ==========================================
CreateLabel("SESSION")

CreateButton("Rejoin", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end)

CreateButton("Kick (Y)", function()
    LocalPlayer:Kick("Kick Manual")
end)

-- ==========================================
-- SEÇÃO: QUICK ACTIONS
-- ==========================================
CreateLabel("QUICK ACTIONS")

CreateButton("Drop Brainrot", function()
    -- Lógica para dropar o item
    print("Drop")
end)

CreateButton("Instant Reset", function()
    if LocalPlayer.Character then
        LocalPlayer.Character:BreakJoints()
    end
end)

CreateButton("TP", function()
    -- Lógica de teleporte
    print("TP")
end)

CreateButton("Clone", function()
    -- Lógica de clone
    print("Clone")
end)

-- ==========================================
-- FOOTER: AUTO DESTROY
-- ==========================================
local footerFrame = Instance.new("Frame")
footerFrame.Size = UDim2.new(1, 0, 0, 30)
footerFrame.Position = UDim2.new(0, 0, 1, -30)
footerFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
footerFrame.BorderSizePixel = 0
footerFrame.Parent = MainFrame

local footerLabel = Instance.new("TextLabel")
footerLabel.Size = UDim2.new(0.6, 0, 1, 0)
footerLabel.Position = UDim2.new(0, 10, 0, 0)
footerLabel.BackgroundTransparency = 1
footerLabel.Text = "Auto Destroy..."
footerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
footerLabel.Font = Enum.Font.Gotham
footerLabel.TextSize = 12
footerLabel.TextXAlignment = Enum.TextXAlignment.Left
footerLabel.Parent = footerFrame

local destroyToggle = Instance.new("TextButton")
destroyToggle.Size = UDim2.new(0.3, 0, 0, 20)
destroyToggle.Position = UDim2.new(0.65, 0, 0.5, -10)
destroyToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
destroyToggle.BorderSizePixel = 0
destroyToggle.Text = "OFF"
destroyToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
destroyToggle.Font = Enum.Font.GothamBold
destroyToggle.TextSize = 10
destroyToggle.Parent = footerFrame

local dc = Instance.new("UICorner")
dc.CornerRadius = UDim.new(0, 4)
dc.Parent = destroyToggle

destroyToggle.MouseButton1Click:Connect(function()
    State.AutoDestroy = not State.AutoDestroy
    destroyToggle.Text = State.AutoDestroy and "ON" or "OFF"
    destroyToggle.BackgroundColor3 = State.AutoDestroy and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(40, 40, 40)
end)
