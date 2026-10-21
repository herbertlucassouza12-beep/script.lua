-- SUPER DIGGER | NPC HEAD TRACKER
-- Para testes no seu próprio jogo Roblox

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Config = {
    Enabled = false,
    FOV = 150,
    Smoothness = 0.35,
    AimKey = Enum.KeyCode.E
}

-- Interface
local Gui = Instance.new("ScreenGui")
Gui.Name = "SuperDigger"
Gui.ResetOnSpawn = false
Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Button = Instance.new("TextButton")
Button.Size = UDim2.fromOffset(190, 45)
Button.Position = UDim2.fromOffset(20, 100)
Button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Button.TextColor3 = Color3.new(1, 1, 1)
Button.Text = "NPC Head Tracker: OFF"
Button.Parent = Gui

Button.MouseButton1Click:Connect(function()
    Config.Enabled = not Config.Enabled
    Button.Text = Config.Enabled
        and "NPC Head Tracker: ON"
        or "NPC Head Tracker: OFF"
end)

-- Círculo visual do FOV
local Circle = Instance.new("Frame")
Circle.Name = "FOVCircle"
Circle.AnchorPoint = Vector2.new(0.5, 0.5)
Circle.Size = UDim2.fromOffset(Config.FOV * 2, Config.FOV * 2)
Circle.BackgroundTransparency = 1
Circle.Position = UDim2.fromScale(0.5, 0.5)
Circle.Parent = Gui

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0, 255, 100)
Stroke.Thickness = 2
Stroke.Parent = Circle

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(1, 0)
Corner.Parent = Circle

-- Localiza a cabeça de um NPC vivo
local function GetClosestNPC()
    local closestHead = nil
    local shortestDistance = Config.FOV
    local mousePos = UserInputService:GetMouseLocation()

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Humanoid") and obj.Health > 0 then
            local character = obj.Parent
            local head = character and character:FindFirstChild("Head")
            local isPlayer = character
                and Players:GetPlayerFromCharacter(character) ~= nil

            if head and head:IsA("BasePart") and not isPlayer then
                local screenPos, visible =
                    Camera:WorldToViewportPoint(head.Position)

                if visible and screenPos.Z > 0 then
                    local distance = (
                        Vector2.new(screenPos.X, screenPos.Y) - mousePos
                    ).Magnitude

                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestHead = head
                    end
                end
            end
        end
    end

    return closestHead
end

RunService.RenderStepped:Connect(function()
    Circle.Size = UDim2.fromOffset(Config.FOV * 2, Config.FOV * 2)
    Circle.Position = UDim2.fromOffset(
        UserInputService:GetMouseLocation().X,
        UserInputService:GetMouseLocation().Y
    )

    if not Config.Enabled
        or not UserInputService:IsKeyDown(Config.AimKey) then
        return
    end

    local head = GetClosestNPC()

    if head then
        local targetCFrame = CFrame.lookAt(
            Camera.CFrame.Position,
            head.Position
        )

        Camera.CFrame = Camera.CFrame:Lerp(
            targetCFrame,
            Config.Smoothness
        )
    end
end)
