local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local flying = false
local infJump = false
local bodyVelocity, flyConnection
local char, humanoid, rootpart

local function updateCharacter()
    char = player.Character or player.CharacterAdded:Wait()
    humanoid = char:WaitForChild("Humanoid")
    rootpart = char:WaitForChild("HumanoidRootPart")
    humanoid.WalkSpeed = 100
    humanoid.JumpPower = 200
end
updateCharacter()
player.CharacterAdded:Connect(updateCharacter)

-- DESTRUIR LAVA (INMUNE TOTAL + AUTO RESPAWN)
local function destroyLava()
    pcall(function()
        local gameFolder = workspace:FindFirstChild("GameFolder")
        if gameFolder then
            local lavas = gameFolder:FindFirstChild("Lavas")
            if lavas then lavas:Destroy() end
        end
    end)
end
destroyLava()
workspace.ChildAdded:Connect(function(child)
    if child.Name == "GameFolder" then
        task.wait(1)
        destroyLava()
    end
end)
player.CharacterAdded:Connect(function()
    task.wait(1)
    destroyLava()
end)

-- INF JUMP
UserInputService.JumpRequest:Connect(function()
    if infJump and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- FLY TOGGLE
local function toggleFly()
    flying = not flying
    if flying then
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = rootpart
        flyConnection = RunService.Heartbeat:Connect(function()
            local camera = workspace.CurrentCamera
            local moveVector = humanoid.MoveDirection * 50
            bodyVelocity.Velocity = camera.CFrame:VectorToWorldSpace(moveVector)
        end)
    else
        if flyConnection then flyConnection:Disconnect() end
        if bodyVelocity then bodyVelocity:Destroy() end
    end
end

-- KEYS (OPCIONAL)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        infJump = not infJump
    elseif input.KeyCode == Enum.KeyCode.G then
        toggleFly()
    end
end)

-- DUPE TOOL EN MANO (IDÉNTICO Y FUNCIONAL)
local function dupeTool(times)
    if not char then return end
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then
        for i = 1, times do
            local clone = tool:Clone()
            clone.Parent = player.Backpack
        end
        print("✅ Duplicado '" .. tool.Name .. "' x" .. times .. " (funcionales!)")
    else
        print("❌ Equipa un Tool/Brainrot primero!")
    end
end

-- GUI FÁCIL (MÓVIL/PC)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LavaHackGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 260, 0, 280)
mainFrame.Position = UDim2.new(0, 20, 0.5, -140)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 45)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🔥 LAVA HACK DUPE 🔥"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0.88, 0, 0, 50)
flyButton.Position = UDim2.new(0.06, 0, 0.18, 0)
flyButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
flyButton.Text = "🛩️ Fly: OFF"
flyButton.TextScaled = true
flyButton.Font = Enum.Font.GothamSemibold
flyButton.Parent = mainFrame
flyButton.MouseButton1Click:Connect(toggleFly)

local infJumpButton = Instance.new("TextButton")
infJumpButton.Size = UDim2.new(0.88, 0, 0, 50)
infJumpButton.Position = UDim2.new(0.06, 0, 0.48, 0)
infJumpButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
infJumpButton.Text = "📈 Inf Jump: OFF"
infJumpButton.TextScaled = true
infJumpButton.Font = Enum.Font.GothamSemibold
infJumpButton.Parent = mainFrame
infJumpButton.MouseButton1Click:Connect(function()
    infJump = not infJump
end)

local dupeButton = Instance.new("TextButton")
dupeButton.Size = UDim2.new(0.88, 0, 0, 50)
dupeButton.Position = UDim2.new(0.06, 0, 0.78, 0)
dupeButton.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
dupeButton.Text = "🔄 Dupe x5 (Equipo primero!)"
dupeButton.TextScaled = true
dupeButton.Font = Enum.Font.GothamBold
dupeButton.Parent = mainFrame
dupeButton.MouseButton1Click:Connect(function() dupeTool(5) end)

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 35, 0, 35)
closeButton.Position = UDim2.new(1, -40, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "✕"
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = mainFrame
closeButton.MouseButton1Click:Connect(function() screenGui:Destroy() end)

-- UPDATE BOTONES (COLOR/TEXTO)
task.spawn(function()
    while screenGui.Parent do
        task.wait(0.1)
        flyButton.Text = "🛩️ Fly: " .. (flying and "ON" or "OFF")
        flyButton.BackgroundColor3 = flying and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        infJumpButton.Text = "📈 Inf Jump: " .. (infJump and "ON" or "OFF")
        infJumpButton.BackgroundColor3 = infJump and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    end
end)

print("🎉 ¡Script cargado! | GUI lista | Dupe: Equipa → Botón | Fly:G | Jump:F | ¡Inmune forever! 🚀")
