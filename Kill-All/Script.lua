local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local enabled = false
local fovEnabled = false
local fovSize = 200
local maxFOVSize = 500

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:FindFirstChildOfClass("PlayerGui") or game:GetService("CoreGui")

local fovCircle = Instance.new("Frame")
fovCircle.Size = UDim2.new(0, fovSize, 0, fovSize)
fovCircle.Position = UDim2.new(0.5, -fovSize/2, 0.5, -fovSize/2)
fovCircle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
fovCircle.BackgroundTransparency = 0.6
fovCircle.BorderSizePixel = 0
fovCircle.Visible = false
fovCircle.Parent = screenGui

local uiCornerCircle = Instance.new("UICorner")
uiCornerCircle.CornerRadius = UDim.new(1, 0)
uiCornerCircle.Parent = fovCircle

local uiStrokeCircle = Instance.new("UIStroke")
uiStrokeCircle.Color = Color3.fromRGB(255, 255, 255)
uiStrokeCircle.Transparency = 0.5
uiStrokeCircle.Thickness = 1.5
uiStrokeCircle.Parent = fovCircle

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 140, 0, 45)
toggleBtn.Position = UDim2.new(1, -150, 0.4, 0)
toggleBtn.Text = "Instakill Off"
toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 16
toggleBtn.Parent = screenGui

local uiCornerToggle = Instance.new("UICorner")
uiCornerToggle.CornerRadius = UDim.new(0, 8)
uiCornerToggle.Parent = toggleBtn

local uiStrokeToggle = Instance.new("UIStroke")
uiStrokeToggle.Color = Color3.fromRGB(255, 0, 0)
uiStrokeToggle.Transparency = 0.6
uiStrokeToggle.Parent = toggleBtn

local fovToggleBtn = Instance.new("TextButton")
fovToggleBtn.Size = UDim2.new(0, 140, 0, 45)
fovToggleBtn.Position = UDim2.new(1, -150, 0.5, 0)
fovToggleBtn.Text = "FOV Off"
fovToggleBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
fovToggleBtn.TextColor3 = Color3.new(1, 1, 1)
fovToggleBtn.Font = Enum.Font.GothamBold
fovToggleBtn.TextSize = 16
fovToggleBtn.Parent = screenGui

local uiCornerFOVToggle = Instance.new("UICorner")
uiCornerFOVToggle.CornerRadius = UDim.new(0, 8)
uiCornerFOVToggle.Parent = fovToggleBtn

local uiStrokeFOVToggle = Instance.new("UIStroke")
uiStrokeFOVToggle.Color = Color3.fromRGB(150, 0, 0)
uiStrokeFOVToggle.Transparency = 0.6
uiStrokeFOVToggle.Parent = fovToggleBtn

local fovSizeInput = Instance.new("TextBox")
fovSizeInput.Size = UDim2.new(0, 140, 0, 35)
fovSizeInput.Position = UDim2.new(1, -150, 0.6, 0)
fovSizeInput.Text = tostring(fovSize)
fovSizeInput.PlaceholderText = "FOV Size (0-100)"
fovSizeInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
fovSizeInput.TextColor3 = Color3.new(1, 1, 1)
fovSizeInput.Font = Enum.Font.Gotham
fovSizeInput.TextSize = 14
fovSizeInput.Parent = screenGui

local uiCornerInput = Instance.new("UICorner")
uiCornerInput.CornerRadius = UDim.new(0, 8)
uiCornerInput.Parent = fovSizeInput

local uiStrokeInput = Instance.new("UIStroke")
uiStrokeInput.Color = Color3.fromRGB(100, 100, 100)
uiStrokeInput.Transparency = 0.7
uiStrokeInput.Parent = fovSizeInput

local function updateFOVCircle()
    local actualSize = (fovSize / 100) * maxFOVSize
    fovCircle.Size = UDim2.new(0, actualSize, 0, actualSize)
    fovCircle.Position = UDim2.new(0.5, -actualSize/2, 0.5, -actualSize/2)
end

toggleBtn.MouseButton1Click:Connect(function()
    enabled = not enabled
    toggleBtn.Text = enabled and "Instakill On" or "Instakill Off"
    toggleBtn.BackgroundColor3 = enabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
end)

fovToggleBtn.MouseButton1Click:Connect(function()
    fovEnabled = not fovEnabled
    fovToggleBtn.Text = fovEnabled and "FOV On" or "FOV Off"
    fovToggleBtn.BackgroundColor3 = fovEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(100, 0, 0)
    fovCircle.Visible = fovEnabled
end)

fovSizeInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local value = tonumber(fovSizeInput.Text)
        if value then
            fovSize = math.clamp(value, 0, 100)
            fovSizeInput.Text = tostring(fovSize)
            updateFOVCircle()
        else
            fovSizeInput.Text = tostring(fovSize)
        end
    end
end)

local function shouldAttackPlayer(targetPlayer)
    if not fovEnabled then
        return true
    end

    if not targetPlayer.Character then
        return false
    end

    local camera = workspace.CurrentCamera
    if not camera then
        return false
    end

    local targetHead = targetPlayer.Character:FindFirstChild("Head")
    if not targetHead then
        return false
    end

    local screenPoint, onScreen = camera:WorldToViewportPoint(targetHead.Position)
    if not onScreen then
        return false
    end

    local circleCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    local targetPosition = Vector2.new(screenPoint.X, screenPoint.Y)
    local distance = (targetPosition - circleCenter).Magnitude

    local actualFOVRadius = (fovSize / 100) * maxFOVSize / 2
    return distance <= actualFOVRadius
end

local function getDamageRemote()
    for _, v in next, getnilinstances() do
        if v.Name == "Damage" and v:IsA("RemoteEvent") then
            local parent = v.Parent
            if parent and parent.Name == "Gun_Local" then
                return v
            end
        end
    end

    local character = player.Character
    if character then
        local gun = character:FindFirstChild("AS-VAL")
        if gun and gun:FindFirstChild("Gun_Local") then
            return gun.Gun_Local:FindFirstChild("Damage")
        end
    end
    return nil
end

local function performInstakill()
    local damageRemote = getDamageRemote()
    if not damageRemote then
        return false
    end

    local totalAttacks = 0

    for _, targetPlayer in pairs(Players:GetPlayers()) do
        if not enabled then break end

        if targetPlayer ~= player and targetPlayer.Character then
            if shouldAttackPlayer(targetPlayer) then
                local targetLeftArm = targetPlayer.Character:FindFirstChild("Left Arm")
                local targetHumanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")

                if targetLeftArm and targetHumanoid and targetHumanoid.Health > 0 then
                    for i = 1, 30 do
                        if not enabled then break end

                        pcall(function()
                            damageRemote:FireServer(targetLeftArm)
                            totalAttacks = totalAttacks + 1
                        end)

                        if i % 10 == 0 then
                            task.wait(0.001)
                        end
                    end
                end
            end
        end
    end

    return totalAttacks > 0
end

local function instakillLoop()
    if not enabled then return end

    pcall(performInstakill)

    task.wait(0.05)
end

spawn(function()
    while true do
        if enabled then
            instakillLoop()
        end
        task.wait(0.01)
    end
end)

spawn(function()
    while true do
        if fovEnabled then
            updateFOVCircle()
        end
        task.wait(0.05)
    end
end)