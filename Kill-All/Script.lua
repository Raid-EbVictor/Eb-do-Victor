-- ⚡ AS-VAL INSTAKILL OTIMIZADO COM KILL NAME - MENU INTEGRADO
-- Bug do instakill corrigido, menu com transparência e autocomplete
-- Todas as funções preservadas e funcionando perfeitamente

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")

local enabled = false
local fovEnabled = false
local fovSize = 200  -- Tamanho padrão do círculo (0-100 range)
local maxFOVSize = 500  -- Tamanho máximo do círculo

-- Variável para armazenar o texto do último jogador
local lastPlayerName = ""

-- UI Principal (única ScreenGui para todos os elementos)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ASVALGUI"
screenGui.Parent = player:FindFirstChildOfClass("PlayerGui") or game:GetService("CoreGui")

-- Círculo FOV
local fovCircle = Instance.new("Frame")
fovCircle.Size = UDim2.new(0, fovSize, 0, fovSize)
fovCircle.Position = UDim2.new(0.5, -fovSize/2, 0.5, -fovSize/2)
fovCircle.BackgroundColor3 = Color3.new(1, 0, 0)
fovCircle.BackgroundTransparency = 0.5
fovCircle.BorderSizePixel = 2
fovCircle.Visible = false

-- Criar UICorner para fazer o círculo
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0.5, 0)
uiCorner.Parent = fovCircle

fovCircle.Parent = screenGui

-- Toggle Button (Instakill)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 120, 0, 40)
toggleBtn.Position = UDim2.new(1, -140, 0.4, -20)
toggleBtn.Text = "INSTAKILL OFF"
toggleBtn.BackgroundColor3 = Color3.new(1, 0, 0)
toggleBtn.Parent = screenGui

-- FOV Toggle Button
local fovToggleBtn = Instance.new("TextButton")
fovToggleBtn.Size = UDim2.new(0, 120, 0, 40)
fovToggleBtn.Position = UDim2.new(1, -140, 0.5, -20)
fovToggleBtn.Text = "FOV OFF"
fovToggleBtn.BackgroundColor3 = Color3.new(0.5, 0, 0)
fovToggleBtn.Parent = screenGui

-- FOV Size Input (TextBox)
local fovSizeInput = Instance.new("TextBox")
fovSizeInput.Size = UDim2.new(0, 120, 0, 30)
fovSizeInput.Position = UDim2.new(1, -140, 0.6, -20)
fovSizeInput.Text = tostring(fovSize)
fovSizeInput.PlaceholderText = "FOV Size (0-100)"
fovSizeInput.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
fovSizeInput.TextColor3 = Color3.new(1, 1, 1)
fovSizeInput.Parent = screenGui

-- Botão Kill Name (canto direito superior)
local killNameBtn = Instance.new("TextButton")
killNameBtn.Size = UDim2.new(0, 120, 0, 40)
killNameBtn.Position = UDim2.new(1, -140, 0.1, -20)
killNameBtn.Text = "KILL NAME"
killNameBtn.BackgroundColor3 = Color3.new(0.8, 0, 0.8)  -- Roxo
killNameBtn.TextColor3 = Color3.new(1, 1, 1)
killNameBtn.AutoButtonColor = true
killNameBtn.Parent = screenGui

-- Menu Principal (inicialmente invisível) - COM TRANSPARÊNCIA
local mainMenu = Instance.new("Frame")
mainMenu.Size = UDim2.new(0, 400, 0, 250)
mainMenu.Position = UDim2.new(0.5, -200, 0.5, -125)  -- Centralizado
mainMenu.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
mainMenu.BackgroundTransparency = 0.4  -- Transparência adicionada (60% visível)
mainMenu.BorderSizePixel = 2
mainMenu.BorderColor3 = Color3.new(0.8, 0, 0.8)
mainMenu.Visible = false
mainMenu.ZIndex = 100
mainMenu.Parent = screenGui

-- UICorner para arredondar o menu
local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 10)
menuCorner.Parent = mainMenu

-- Título do Menu
local menuTitle = Instance.new("TextLabel")
menuTitle.Size = UDim2.new(1, 0, 0, 40)
menuTitle.Position = UDim2.new(0, 0, 0, 0)
menuTitle.Text = "🎯 KILL BY NAME"
menuTitle.TextColor3 = Color3.new(1, 1, 1)
menuTitle.BackgroundTransparency = 1
menuTitle.TextSize = 20
menuTitle.Font = Enum.Font.GothamBold
menuTitle.ZIndex = 101
menuTitle.Parent = mainMenu

-- Botão Fechar (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "✕"
closeBtn.TextSize = 20
closeBtn.BackgroundColor3 = Color3.new(0.8, 0, 0)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.AutoButtonColor = true
closeBtn.ZIndex = 102
closeBtn.Parent = mainMenu

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0.5, 0)
closeCorner.Parent = closeBtn

-- Label de instrução
local instructionLabel = Instance.new("TextLabel")
instructionLabel.Size = UDim2.new(1, -20, 0, 20)
instructionLabel.Position = UDim2.new(0, 10, 0, 50)
instructionLabel.Text = "Digite o nome do jogador:"
instructionLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
instructionLabel.BackgroundTransparency = 1
instructionLabel.TextSize = 14
instructionLabel.Font = Enum.Font.Gotham
instructionLabel.TextXAlignment = Enum.TextXAlignment.Left
instructionLabel.ZIndex = 101
instructionLabel.Parent = mainMenu

-- TextBox para nome do jogador (com autocomplete) - SEM ABRIR TECLADO AUTOMÁTICO
local playerNameBox = Instance.new("TextBox")
playerNameBox.Size = UDim2.new(1, -40, 0, 35)
playerNameBox.Position = UDim2.new(0, 20, 0, 80)
playerNameBox.PlaceholderText = "Digite o nome do jogador..."
playerNameBox.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
playerNameBox.BackgroundTransparency = 0.2  -- Pequena transparência
playerNameBox.TextColor3 = Color3.new(1, 1, 1)
playerNameBox.TextSize = 16
playerNameBox.Font = Enum.Font.Gotham
playerNameBox.ClearTextOnFocus = false
playerNameBox.ZIndex = 101
playerNameBox.Parent = mainMenu

local textBoxCorner = Instance.new("UICorner")
textBoxCorner.CornerRadius = UDim.new(0, 5)
textBoxCorner.Parent = playerNameBox

-- Lista de sugestões (autocomplete)
local suggestionsList = Instance.new("ScrollingFrame")
suggestionsList.Size = UDim2.new(1, -40, 0, 100)
suggestionsList.Position = UDim2.new(0, 20, 0, 125)
suggestionsList.BackgroundTransparency = 0.1  -- Levemente transparente
suggestionsList.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
suggestionsList.ScrollBarThickness = 6
suggestionsList.ScrollBarImageColor3 = Color3.new(0.5, 0, 0.5)
suggestionsList.Visible = false
suggestionsList.ZIndex = 101
suggestionsList.Parent = mainMenu

local suggestionsLayout = Instance.new("UIListLayout")
suggestionsLayout.Padding = UDim.new(0, 2)
suggestionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
suggestionsLayout.Parent = suggestionsList

-- Botão Executar Kill
local executeBtn = Instance.new("TextButton")
executeBtn.Size = UDim2.new(0, 150, 0, 40)
executeBtn.Position = UDim2.new(0.5, -75, 1, -50)
executeBtn.Text = "💀 EXECUTAR KILL"
executeBtn.BackgroundColor3 = Color3.new(0.8, 0, 0)
executeBtn.BackgroundTransparency = 0.1  -- Pequena transparência
executeBtn.TextColor3 = Color3.new(1, 1, 1)
executeBtn.TextSize = 16
executeBtn.Font = Enum.Font.GothamBold
executeBtn.AutoButtonColor = true
executeBtn.ZIndex = 101
executeBtn.Parent = mainMenu

local executeCorner = Instance.new("UICorner")
executeCorner.CornerRadius = UDim.new(0, 5)
executeCorner.Parent = executeBtn

-- Função para atualizar tamanho do círculo
local function updateFOVCircle()
    local actualSize = (fovSize / 100) * maxFOVSize
    fovCircle.Size = UDim2.new(0, actualSize, 0, actualSize)
    fovCircle.Position = UDim2.new(0.5, -actualSize/2, 0.5, -actualSize/2)
end

-- Toggle principal (Instakill)
toggleBtn.MouseButton1Click:Connect(function()
    enabled = not enabled
    toggleBtn.Text = enabled and "INSTAKILL ON" or "INSTAKILL OFF"
    toggleBtn.BackgroundColor3 = enabled and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
    print("Instakill:", enabled and "ATIVADO" or "DESATIVADO")
end)

-- Toggle FOV
fovToggleBtn.MouseButton1Click:Connect(function()
    fovEnabled = not fovEnabled
    fovToggleBtn.Text = fovEnabled and "FOV ON" or "FOV OFF"
    fovToggleBtn.BackgroundColor3 = fovEnabled and Color3.new(0, 1, 0) or Color3.new(0.5, 0, 0)
    fovCircle.Visible = fovEnabled
    print("FOV:", fovEnabled and "ATIVADO" or "DESATIVADO")
end)

-- Input de tamanho FOV
fovSizeInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local value = tonumber(fovSizeInput.Text)
        if value then
            fovSize = math.clamp(value, 0, 100)
            fovSizeInput.Text = tostring(fovSize)
            updateFOVCircle()
            print("FOV Size:", fovSize)
        else
            fovSizeInput.Text = tostring(fovSize)
        end
    end
end)

-- Função CORRIGIDA para verificar se jogador deve ser atacado
local function shouldAttackPlayer(targetPlayer)
    -- Se FOV está desativado, atacar todos
    if not fovEnabled then
        return true
    end
    
    -- Se FOV está ativado, verificar se está dentro do círculo
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
    
    local circleCenter = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
    local targetPosition = Vector2.new(screenPoint.X, screenPoint.Y)
    local distance = (targetPosition - circleCenter).magnitude
    
    local actualFOVSize = (fovSize / 100) * maxFOVSize / 2
    local isInFOV = distance <= actualFOVSize
    
    return isInFOV
end

-- Função unificada para encontrar RemoteEvent do dano
local function getDamageRemote()
    for _, v in next, getnilinstances() do
        if v.Name == "Damage" and v:IsA("RemoteEvent") then
            local parent = v.Parent
            if parent and parent.Name == "Gun_Local" then
                return v
            end
        end
    end
    return nil
end

-- INSTAKILL OTIMIZADO - Com verificação corrigida
local function asvalInstakillOptimized()
    local damageRemote = getDamageRemote()
    
    -- Fallback para método original se getnilinstances falhar
    if not damageRemote then
        local character = player.Character
        if character then
            local gun = character:FindFirstChild("AS-VAL")
            if gun and gun:FindFirstChild("Gun_Local") then
                damageRemote = gun.Gun_Local:FindFirstChild("Damage")
            end
        end
    end
    
    if not damageRemote then 
        print("❌ RemoteEvent não encontrado")
        return false 
    end
    
    local totalAttacks = 0
    local playersChecked = 0
    
    for _, targetPlayer in pairs(Players:GetPlayers()) do
        if not enabled then break end
        
        playersChecked = playersChecked + 1
        
        if targetPlayer ~= player and targetPlayer.Character then
            -- VERIFICAÇÃO CORRIGIDA: Usar função clara de decisão
            if shouldAttackPlayer(targetPlayer) then
                local targetLeftArm = targetPlayer.Character:FindFirstChild("Left Arm")
                local targetHumanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
                
                if targetLeftArm and targetHumanoid and targetHumanoid.Health > 0 then
                    -- 30 ATAQUES RÁPIDOS (reduzido para estabilidade)
                    for i = 1, 30 do
                        if not enabled then break end
                        
                        local success, err = pcall(function()
                            damageRemote:FireServer(targetLeftArm)
                            totalAttacks = totalAttacks + 1
                        end)
                        
                        if not success then
                            print("❌ Erro no ataque:", err)
                        end
                        
                        -- Pequeno delay a cada 10 ataques para estabilidade
                        if i % 10 == 0 then
                            task.wait(0.001)
                        end
                    end
                else
                    if not targetLeftArm then
                        print("⚠️  Target sem Left Arm:", targetPlayer.Name)
                    elseif not targetHumanoid then
                        print("⚠️  Target sem Humanoid:", targetPlayer.Name)
                    elseif targetHumanoid and targetHumanoid.Health <= 0 then
                        print("⚠️  Target morto:", targetPlayer.Name)
                    end
                end
            else
                -- FOV ativado e jogador fora do círculo
                -- print("ℹ️  Jogador fora do FOV:", targetPlayer.Name) -- Comentado para menos spam
            end
        else
            if targetPlayer == player then
                -- print("ℹ️  Ignorando self") -- Comentado para menos spam
            else
                print("⚠️  Target sem Character:", targetPlayer.Name)
            end
        end
    end
    
    if totalAttacks > 0 then
        print("✅", totalAttacks, "ataques enviados para", playersChecked, "jogadores verificados")
    end
    
    return totalAttacks > 0
end

-- Loop principal otimizado COM TRATAMENTO DE ERROS
local function instakillLoop()
    if not enabled then return end
    
    local success, err = pcall(function()
        asvalInstakillOptimized()
    end)
    
    if not success then
        print("❌ Erro no loop principal:", err)
    end
    
    task.wait(0.05)  -- Aumentado para estabilidade
end

-- Função para obter lista de jogadores (para autocomplete)
local function getPlayerList()
    local playerList = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then  -- Excluir a si mesmo
            table.insert(playerList, p.Name)
        end
    end
    return playerList
end

-- Função de autocomplete
local function autoComplete(inputText)
    if inputText == "" then
        suggestionsList.Visible = false
        return {}
    end
    
    local playerList = getPlayerList()
    local matches = {}
    
    inputText = string.lower(inputText)
    
    for _, playerName in pairs(playerList) do
        if string.find(string.lower(playerName), inputText, 1, true) == 1 then
            table.insert(matches, playerName)
        end
    end
    
    return matches
end

-- Função para atualizar lista de sugestões
local function updateSuggestions(inputText)
    -- Limpar sugestões anteriores
    for _, child in pairs(suggestionsList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    local matches = autoComplete(inputText)
    
    if #matches > 0 then
        suggestionsList.Visible = true
        suggestionsList.CanvasSize = UDim2.new(0, 0, 0, (#matches * 25) + 10)
        
        for i, match in pairs(matches) do
            local suggestionBtn = Instance.new("TextButton")
            suggestionBtn.Size = UDim2.new(1, -10, 0, 25)
            suggestionBtn.Position = UDim2.new(0, 0, 0, (i-1) * 27)
            suggestionBtn.Text = match
            suggestionBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
            suggestionBtn.BackgroundTransparency = 0.2
            suggestionBtn.TextColor3 = Color3.new(1, 1, 1)
            suggestionBtn.TextSize = 14
            suggestionBtn.Font = Enum.Font.Gotham
            suggestionBtn.AutoButtonColor = true
            suggestionBtn.ZIndex = 102
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 3)
            btnCorner.Parent = suggestionBtn
            
            suggestionBtn.MouseButton1Click:Connect(function()
                playerNameBox.Text = match
                suggestionsList.Visible = false
            end)
            
            suggestionBtn.Parent = suggestionsList
        end
    else
        suggestionsList.Visible = false
        suggestionsList.CanvasSize = UDim2.new(0, 0, 0, 0)
    end
end

-- Função para matar jogador por nome
local function killPlayerByName(targetName)
    local targetPlayer = nil
    
    -- Encontrar jogador pelo nome exato
    for _, p in pairs(Players:GetPlayers()) do
        if string.lower(p.Name) == string.lower(targetName) then
            targetPlayer = p
            break
        end
    end
    
    if not targetPlayer then
        print("❌ Jogador '" .. targetName .. "' não encontrado")
        return false
    end
    
    if targetPlayer == player then
        print("❌ Não é possível se matar")
        return false
    end
    
    if not targetPlayer.Character then
        print("❌ Jogador '" .. targetName .. "' não tem personagem")
        return false
    end
    
    local targetHumanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not targetHumanoid or targetHumanoid.Health <= 0 then
        print("❌ Jogador '" .. targetName .. "' está morto")
        return false
    end
    
    local targetLeftArm = targetPlayer.Character:FindFirstChild("Left Arm")
    if not targetLeftArm then
        print("❌ Jogador '" .. targetName .. "' não tem braço esquerdo")
        return false
    end
    
    -- Encontrar RemoteEvent
    local damageRemote = getDamageRemote()
    if not damageRemote then
        local character = player.Character
        if character then
            local gun = character:FindFirstChild("AS-VAL")
            if gun and gun:FindFirstChild("Gun_Local") then
                damageRemote = gun.Gun_Local:FindFirstChild("Damage")
            end
        end
    end
    
    if not damageRemote then
        print("❌ RemoteEvent de dano não encontrado")
        return false
    end
    
    -- Executar ataques
    local attacksSent = 0
    for i = 1, 40 do  -- 40 ataques rápidos
        local success, err = pcall(function()
            damageRemote:FireServer(targetLeftArm)
            attacksSent = attacksSent + 1
        end)
        
        if not success then
            print("❌ Erro no ataque " .. i .. ": " .. tostring(err))
            break
        end
        
        if i % 10 == 0 then
            task.wait(0.001)
        end
    end
    
    if attacksSent > 0 then
        print("✅ " .. attacksSent .. " ataques enviados para '" .. targetName .. "'")
        return true
    else
        print("❌ Nenhum ataque foi enviado para '" .. targetName .. "'")
        return false
    end
end

-- Eventos da UI para Kill Name

-- Abrir/fechar menu principal - SEM ABRIR TECLADO AUTOMÁTICO
killNameBtn.MouseButton1Click:Connect(function()
    mainMenu.Visible = not mainMenu.Visible
    if mainMenu.Visible then
        -- Restaurar o último nome digitado
        playerNameBox.Text = lastPlayerName
        -- NÃO chamar CaptureFocus para evitar abrir o teclado
        if lastPlayerName ~= "" then
            updateSuggestions(lastPlayerName)  -- Atualizar sugestões se houver texto
        else
            suggestionsList.Visible = false
        end
    end
end)

-- Fechar menu E salvar o texto atual
closeBtn.MouseButton1Click:Connect(function()
    -- Salvar o texto atual antes de fechar
    lastPlayerName = playerNameBox.Text
    mainMenu.Visible = false
    suggestionsList.Visible = false
end)

-- Autocomplete enquanto digita
playerNameBox:GetPropertyChangedSignal("Text"):Connect(function()
    local currentText = playerNameBox.Text
    -- Atualizar a variável de último nome enquanto digita
    lastPlayerName = currentText
    updateSuggestions(currentText)
end)

-- Executar kill
executeBtn.MouseButton1Click:Connect(function()
    local targetName = playerNameBox.Text
    if targetName == "" then
        print("❌ Digite o nome de um jogador")
        return
    end
    
    -- Salvar o nome antes de executar
    lastPlayerName = targetName
    print("🎯 Tentando matar: " .. targetName)
    killPlayerByName(targetName)
end)

-- Fechar com ESC e salvar o texto
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Escape and mainMenu.Visible then
        lastPlayerName = playerNameBox.Text  -- Salvar texto antes de fechar
        mainMenu