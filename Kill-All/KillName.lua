local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

local lastPlayerName = ""

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KillNameGUI"
screenGui.Parent = player:FindFirstChildOfClass("PlayerGui") or game:GetService("CoreGui")

local killNameBtn = Instance.new("TextButton")
killNameBtn.Size = UDim2.new(0, 120, 0, 40)
killNameBtn.Position = UDim2.new(1, -140, 0.1, 20)
killNameBtn.Text = "KILL NAME"
killNameBtn.BackgroundColor3 = Color3.fromRGB(128, 0, 128)
killNameBtn.TextColor3 = Color3.new(1, 1, 1)
killNameBtn.Font = Enum.Font.GothamBold
killNameBtn.TextSize = 16
killNameBtn.Parent = screenGui

local uiCornerBtn = Instance.new("UICorner")
uiCornerBtn.CornerRadius = UDim.new(0, 8)
uiCornerBtn.Parent = killNameBtn

local mainMenu = Instance.new("Frame")
mainMenu.Size = UDim2.new(0, 350, 0, 280)
mainMenu.Position = UDim2.new(0.5, -175, 0.5, -140)
mainMenu.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainMenu.BackgroundTransparency = 0.3
mainMenu.BorderSizePixel = 0
mainMenu.Visible = false
mainMenu.Parent = screenGui

local uiCornerMenu = Instance.new("UICorner")
uiCornerMenu.CornerRadius = UDim.new(0, 12)
uiCornerMenu.Parent = mainMenu

local uiStrokeMenu = Instance.new("UIStroke")
uiStrokeMenu.Color = Color3.fromRGB(128, 0, 128)
uiStrokeMenu.Transparency = 0.5
uiStrokeMenu.Thickness = 1.5
uiStrokeMenu.Parent = mainMenu

local menuTitle = Instance.new("TextLabel")
menuTitle.Size = UDim2.new(1, 0, 0, 50)
menuTitle.BackgroundTransparency = 1
menuTitle.Text = "🎯 Kill by Name"
menuTitle.TextColor3 = Color3.new(1, 1, 1)
menuTitle.TextSize = 24
menuTitle.Font = Enum.Font.GothamBold
menuTitle.Parent = mainMenu

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 10)
closeBtn.Text = "✕"
closeBtn.TextSize = 20
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.Gotham
closeBtn.Parent = mainMenu

local uiCornerClose = Instance.new("UICorner")
uiCornerClose.CornerRadius = UDim.new(0.5, 0)
uiCornerClose.Parent = closeBtn

local instructionLabel = Instance.new("TextLabel")
instructionLabel.Size = UDim2.new(1, -40, 0, 20)
instructionLabel.Position = UDim2.new(0, 20, 0, 60)
instructionLabel.Text = "Enter player name:"
instructionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
instructionLabel.BackgroundTransparency = 1
instructionLabel.TextSize = 14
instructionLabel.Font = Enum.Font.Gotham
instructionLabel.TextXAlignment = Enum.TextXAlignment.Left
instructionLabel.Parent = mainMenu

local playerNameBox = Instance.new("TextBox")
playerNameBox.Size = UDim2.new(1, -40, 0, 40)
playerNameBox.Position = UDim2.new(0, 20, 0, 90)
playerNameBox.PlaceholderText = "Player name..."
playerNameBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
playerNameBox.BackgroundTransparency = 0.2
playerNameBox.TextColor3 = Color3.new(1, 1, 1)
playerNameBox.TextSize = 16
playerNameBox.Font = Enum.Font.Gotham
playerNameBox.ClearTextOnFocus = false
playerNameBox.Parent = mainMenu

local uiCornerTextBox = Instance.new("UICorner")
uiCornerTextBox.CornerRadius = UDim.new(0, 8)
uiCornerTextBox.Parent = playerNameBox

local uiStrokeTextBox = Instance.new("UIStroke")
uiStrokeTextBox.Color = Color3.fromRGB(100, 100, 100)
uiStrokeTextBox.Transparency = 0.7
uiStrokeTextBox.Parent = playerNameBox

local suggestionsList = Instance.new("ScrollingFrame")
suggestionsList.Size = UDim2.new(1, -40, 0, 120)
suggestionsList.Position = UDim2.new(0, 20, 0, 140)
suggestionsList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
suggestionsList.BackgroundTransparency = 0.1
suggestionsList.BorderSizePixel = 0
suggestionsList.ScrollBarThickness = 5
suggestionsList.ScrollBarImageColor3 = Color3.fromRGB(128, 0, 128)
suggestionsList.Visible = false
suggestionsList.Parent = mainMenu

local uiCornerSuggestions = Instance.new("UICorner")
uiCornerSuggestions.CornerRadius = UDim.new(0, 8)
uiCornerSuggestions.Parent = suggestionsList

local suggestionsLayout = Instance.new("UIListLayout")
suggestionsLayout.Padding = UDim.new(0, 4)
suggestionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
suggestionsLayout.Parent = suggestionsList

local executeBtn = Instance.new("TextButton")
executeBtn.Size = UDim2.new(0, 180, 0, 45)
executeBtn.Position = UDim2.new(0.5, -90, 1, -60)
executeBtn.Text = "💀 Execute Kill"
executeBtn.BackgroundColor3 = Color3.fromRGB(128, 0, 0)
executeBtn.BackgroundTransparency = 0.1
executeBtn.TextColor3 = Color3.new(1, 1, 1)
executeBtn.TextSize = 18
executeBtn.Font = Enum.Font.GothamBold
executeBtn.Parent = mainMenu

local uiCornerExecute = Instance.new("UICorner")
uiCornerExecute.CornerRadius = UDim.new(0, 8)
uiCornerExecute.Parent = executeBtn

local uiStrokeExecute = Instance.new("UIStroke")
uiStrokeExecute.Color = Color3.fromRGB(200, 0, 0)
uiStrokeExecute.Transparency = 0.5
uiStrokeExecute.Parent = executeBtn

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

local function getPlayerList()
    local playerList = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            table.insert(playerList, p.Name)
        end
    end
    return playerList
end

local function updateSuggestions(inputText)
    for _, child in pairs(suggestionsList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    if inputText == "" then
        suggestionsList.Visible = false
        return
    end

    local playerList = getPlayerList()
    local matches = {}
    inputText = string.lower(inputText)

    for _, playerName in pairs(playerList) do
        if string.find(string.lower(playerName), inputText, 1, true) == 1 then
            table.insert(matches, playerName)
        end
    end

    if #matches > 0 then
        suggestionsList.Visible = true
        suggestionsList.CanvasSize = UDim2.new(0, 0, 0, #matches * 32)

        for _, match in pairs(matches) do
            local suggestionBtn = Instance.new("TextButton")
            suggestionBtn.Size = UDim2.new(1, 0, 0, 28)
            suggestionBtn.Text = match
            suggestionBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            suggestionBtn.BackgroundTransparency = 0.2
            suggestionBtn.TextColor3 = Color3.new(1, 1, 1)
            suggestionBtn.TextSize = 14
            suggestionBtn.Font = Enum.Font.Gotham
            suggestionBtn.Parent = suggestionsList

            local uiCornerSug = Instance.new("UICorner")
            uiCornerSug.CornerRadius = UDim.new(0, 6)
            uiCornerSug.Parent = suggestionBtn

            suggestionBtn.MouseButton1Click:Connect(function()
                playerNameBox.Text = match
                suggestionsList.Visible = false
            end)
        end
    else
        suggestionsList.Visible = false
    end
end

local function killPlayerByName(targetName)
    local targetPlayer
    for _, p in pairs(Players:GetPlayers()) do
        if string.lower(p.Name) == string.lower(targetName) then
            targetPlayer = p
            break
        end
    end

    if not targetPlayer or targetPlayer == player or not targetPlayer.Character then
        return false
    end

    local targetHumanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not targetHumanoid or targetHumanoid.Health <= 0 then
        return false
    end

    local targetLeftArm = targetPlayer.Character:FindFirstChild("Left Arm")
    if not targetLeftArm then
        return false
    end

    local damageRemote = getDamageRemote()
    if not damageRemote then
        return false
    end

    local attacksSent = 0
    for i = 1, 40 do
        local success = pcall(function()
            damageRemote:FireServer(targetLeftArm)
            attacksSent = attacksSent + 1
        end)

        if not success then
            break
        end

        if i % 10 == 0 then
            task.wait(0.001)
        end
    end

    return attacksSent > 0
end

killNameBtn.MouseButton1Click:Connect(function()
    mainMenu.Visible = not mainMenu.Visible
    if mainMenu.Visible then
        playerNameBox.Text = lastPlayerName
        updateSuggestions(lastPlayerName)
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    lastPlayerName = playerNameBox.Text
    mainMenu.Visible = false
    suggestionsList.Visible = false
end)

playerNameBox:GetPropertyChangedSignal("Text"):Connect(function()
    lastPlayerName = playerNameBox.Text
    updateSuggestions(playerNameBox.Text)
end)

executeBtn.MouseButton1Click:Connect(function()
    local targetName = playerNameBox.Text
    if targetName ~= "" then
        lastPlayerName = targetName
        killPlayerByName(targetName)
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Escape and mainMenu.Visible then
        lastPlayerName = playerNameBox.Text
        mainMenu.Visible = false
        suggestionsList.Visible = false
    end
end)

playerNameBox.MouseButton1Click:Connect(function()
    playerNameBox:CaptureFocus()
end)

spawn(function()
    while true do
        task.wait(2)
        if mainMenu.Visible and playerNameBox.Text ~= "" then
            updateSuggestions(playerNameBox.Text)
        end
    end
end)