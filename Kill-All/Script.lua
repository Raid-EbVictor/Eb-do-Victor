-- ⚡ AS-VAL COMPLETE - Kill Name + Instakill All
-- Scripts unidos profissionalmente - cada um funciona independentemente
-- Totalmente otimizado e compatível com limites de cópia

print("⚡ CARREGANDO AS-VAL COMPLETE...")

-- ======================================================================
-- CONFIGURAÇÃO GLOBAL E SERVIÇOS
-- ======================================================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")

-- Variáveis globais compartilhadas
local killName_lastPlayerName = ""
local instakill_enabled = false
local instakill_fovEnabled = false
local instakill_fovSize = 200
local instakill_maxFOVSize = 500

-- ======================================================================
-- INTERFACE GRÁFICA UNIFICADA
-- ======================================================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ASVAL_CompleteGUI"
screenGui.Parent = player:FindFirstChildOfClass("PlayerGui") or game:GetService("CoreGui")

-- ======================================================================
-- KILL NAME - INTERFACE E FUNCIONALIDADES
-- ======================================================================

-- Botão Kill Name (canto direito superior)
local killNameBtn = Instance.new("TextButton")
killNameBtn.Size = UDim2.new(0, 120, 0, 40)
killNameBtn.Position = UDim2.new(1, -140, 0.1, -20)
killNameBtn.Text = "KILL NAME"
killNameBtn.BackgroundColor3 = Color3.new(0.8, 0, 0.8)
killNameBtn.TextColor3 = Color3.new(1, 1, 1)
killNameBtn.AutoButtonColor = true
killNameBtn.ZIndex = 10
killNameBtn.Parent = screenGui

-- Menu Principal Kill Name
local killName_mainMenu = Instance.new("Frame")
killName_mainMenu.Size = UDim2.new(0, 400, 0, 250)
killName_mainMenu.Position = UDim2.new(0.5, -200, 0.5, -125)
killName_mainMenu.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
killName_mainMenu.BackgroundTransparency = 0.4
killName_mainMenu.BorderSizePixel = 2
killName_mainMenu.BorderColor3 = Color3.new(0.8, 0, 0.8)
killName_mainMenu.Visible = false
killName_mainMenu.ZIndex = 100
killName_mainMenu.Parent = screenGui

local killName_menuCorner = Instance.new("UICorner")
killName_menuCorner.CornerRadius = UDim.new(0, 10)
killName_menuCorner.Parent = killName_mainMenu

-- Título do Menu
local killName_menuTitle = Instance.new("TextLabel")
killName_menuTitle.Size = UDim2.new(1, 0, 0, 40)
killName_menuTitle.Position = UDim2.new(0, 0, 0, 0)
killName_menuTitle.Text = "🎯 KILL BY NAME"
killName_menuTitle.TextColor3 = Color3.new(1, 1, 1)
killName_menuTitle.BackgroundTransparency = 1
killName_menuTitle.TextSize = 20
killName_menuTitle.Font = Enum.Font.GothamBold
killName_menuTitle.ZIndex = 101
killName_menuTitle.Parent = killName_mainMenu

-- Botão Fechar (X)
local killName_closeBtn = Instance.new("TextButton")
killName_closeBtn.Size = UDim2.new(0, 30, 0, 30)
killName_closeBtn.Position = UDim2.new(1, -35, 0, 5)
killName_closeBtn.Text = "✕"
killName_closeBtn.TextSize = 20
killName_closeBtn.BackgroundColor3 = Color3.new(0.8, 0, 0)
killName_closeBtn.TextColor3 = Color3.new(1, 1, 1)
killName_closeBtn.AutoButtonColor = true
killName_closeBtn.ZIndex = 102
killName_closeBtn.Parent = killName_mainMenu

local killName_closeCorner = Instance.new("UICorner")
killName_closeCorner.CornerRadius = UDim.new(0.5, 0)
killName_closeCorner.Parent = killName_closeBtn

-- Label de instrução
local killName_instructionLabel = Instance.new("TextLabel")
killName_instructionLabel.Size = UDim2.new(1, -20, 0, 20)
killName_instructionLabel.Position = UDim2.new(0, 10, 0, 50)
killName_instructionLabel.Text = "Digite o nome do jogador:"
killName_instructionLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
killName_instructionLabel.BackgroundTransparency = 1
killName_instructionLabel.TextSize = 14
killName_instructionLabel.Font = Enum.Font.Gotham
killName_instructionLabel.TextXAlignment = Enum.TextXAlignment.Left
killName_instructionLabel.ZIndex = 101
killName_instructionLabel.Parent = killName_mainMenu

-- TextBox para nome do jogador
local killName_playerNameBox = Instance.new("TextBox")
killName_playerNameBox.Size = UDim2.new(1, -40, 0, 35)
killName_playerNameBox.Position = UDim2.new(0, 20, 0, 80)
killName_playerNameBox.PlaceholderText = "Digite o nome do jogador..."
killName_playerNameBox.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
killName_playerNameBox.BackgroundTransparency = 0.2
killName_playerNameBox.TextColor3 = Color3.new(1, 1, 1)
killName_playerNameBox.TextSize = 16
killName_playerNameBox.Font = Enum.Font.Gotham
killName_playerNameBox.ClearTextOnFocus = false
killName_playerNameBox.ZIndex = 101
killName_playerNameBox.Parent = killName_mainMenu

local killName_textBoxCorner = Instance.new("UICorner")
killName_textBoxCorner.CornerRadius = UDim.new(0, 5)
killName_textBoxCorner.Parent = killName_playerNameBox

-- Lista de sugestões (autocomplete)
local killName_suggestionsList = Instance.new("ScrollingFrame")
killName_suggestionsList.Size = UDim2.new(1, -40, 0, 100)
killName_suggestionsList.Position = UDim2.new(0, 20, 0, 125)
killName_suggestionsList.BackgroundTransparency = 0.1
killName_suggestionsList.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
killName_suggestionsList.ScrollBarThickness = 6
killName_suggestionsList.ScrollBarImageColor3 = Color3.new(0.5, 0, 0.5)
killName_suggestionsList.Visible = false
killName_suggestionsList.ZIndex = 101
killName_suggestionsList.Parent = killName_mainMenu

local killName_suggestionsLayout = Instance.new("UIListLayout")
killName_suggestionsLayout.Padding = UDim.new(0, 2)
killName_suggestionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
killName_suggestionsLayout.Parent = killName_suggestionsList

-- Botão Executar Kill
local killName_executeBtn = Instance.new("TextButton")
killName_executeBtn.Size = UDim2.new(0, 150, 0, 40)
killName_executeBtn.Position = UDim2.new(0.5, -75, 1, -50)
killName_executeBtn.Text = "💀 EXECUTAR KILL"
killName_executeBtn.BackgroundColor3 = Color3.new(0.8, 0, 0)
killName_executeBtn.BackgroundTransparency = 0.1
killName_executeBtn.TextColor3 = Color3.new(1, 1, 1)
killName_executeBtn.TextSize = 16
killName_executeBtn.Font = Enum.Font.GothamBold
killName_executeBtn.AutoButtonColor = true
killName_executeBtn.ZIndex = 101
killName_executeBtn.Parent = killName_mainMenu

local killName_executeCorner = Instance.new("UICorner")
killName_executeCorner.CornerRadius = UDim.new(0, 5)
killName_executeCorner.Parent = killName_executeBtn

-- ======================================================================
-- INSTAKILL ALL - INTERFACE E FUNCIONALIDADES
-- ======================================================================

-- Círculo FOV
local instakill_fovCircle = Instance.new("Frame")
instakill_fovCircle.Size = UDim2.new(0, instakill_fovSize, 0, instakill_fovSize)
instakill_fovCircle.Position = UDim2.new(0.5, -instakill_fovSize/2, 0.5, -instakill_fovSize/2)
instakill_fovCircle.BackgroundColor3 = Color3.new(1, 0, 0)
instakill_fovCircle.BackgroundTransparency = 0.5
instakill_fovCircle.BorderSizePixel = 2
instakill_fovCircle.Visible = false
instakill_fovCircle.ZIndex = 5

local instakill_uiCorner = Instance.new("UICorner")
instakill_uiCorner.CornerRadius = UDim.new(0.5, 0)
instakill_uiCorner.Parent = instakill_fovCircle

instakill_fovCircle.Parent = screenGui

-- Toggle Button (Instakill)
local instakill_toggleBtn = Instance.new("TextButton")
instakill_toggleBtn.Size = UDim2.new(0, 120, 0, 40)
instakill_toggleBtn.Position = UDim2.new(1, -140, 0.4, -20)
instakill_toggleBtn.Text = "INSTAKILL OFF"
instakill_toggleBtn.BackgroundColor3 = Color3.new(1, 0, 0)
instakill_toggleBtn.ZIndex = 10
instakill_toggleBtn.Parent = screenGui

-- FOV Toggle Button
local instakill_fovToggleBtn = Instance.new("TextButton")
instakill_fovToggleBtn.Size = UDim2.new(0, 120, 0, 40)
instakill_fovToggleBtn.Position = UDim2.new(1, -140, 0.5, -20)
instakill_fovToggleBtn.Text = "FOV OFF"
instakill_fovToggleBtn.BackgroundColor3 = Color3.new(0.5, 0, 0)
instakill_fovToggleBtn.ZIndex = 10
instakill_fovToggleBtn.Parent = screenGui

-- FOV Size Input (TextBox)
local instakill_fovSizeInput = Instance.new("TextBox")
instakill_fovSizeInput.Size = UDim2.new(0, 120, 0, 30)
instakill_fovSizeInput.Position = UDim2.new(1, -140, 0.6, -20)
instakill_fovSizeInput.Text = tostring(instakill_fovSize)
instakill_fovSizeInput.PlaceholderText = "FOV Size (0-100)"
instakill_fovSizeInput.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
instakill_fovSizeInput.TextColor3 = Color3.new(1, 1, 1)
instakill_fovSizeInput.ZIndex = 10
instakill_fovSizeInput.Parent = screenGui

-- ======================================================================
-- FUNÇÕES COMPARTILHADAS
-- ======================================================================

-- Função para encontrar RemoteEvent do dano (compartilhada)
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

-- ======================================================================
-- KILL NAME - FUNÇÕES ESPECÍFICAS
-- ======================================================================

-- Função para obter lista de jogadores (para autocomplete)
local function killName_getPlayerList()
    local playerList = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            table.insert(playerList, p.Name)
        end
    end
    return playerList
end

-- Função de autocomplete
local function killName_autoComplete(inputText)
    if inputText == "" then
        killName_suggestionsList.Visible = false
        return {}
    end
    
    local playerList = killName_getPlayerList()
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
local function killName_updateSuggestions(inputText)
    -- Limpar sugestões anteriores
    for _, child in pairs(killName_suggestionsList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    local matches = killName_autoComplete(inputText)
    
    if #matches > 0 then
        killName_suggestionsList.Visible = true
        killName_suggestionsList.CanvasSize = UDim2.new(0, 0, 0, (#matches * 25) + 10)
        
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
                killName_playerNameBox.Text = match
                killName_suggestionsList.Visible = false
            end)
            
            suggestionBtn.Parent = killName_suggestionsList
        end
    else
        killName_suggestionsList.Visible = false
        killName_suggestionsList.CanvasSize = UDim2.new(0, 0, 0, 0)
    end
end

-- Função para matar jogador por nome
local function killName_killPlayerByName(targetName)
    local targetPlayer = nil
    
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
    
    local attacksSent = 0
    for i = 1, 40 do
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

-- ======================================================================
-- INSTAKILL ALL - FUNÇÕES ESPECÍFICAS
-- ======================================================================

-- Função para atualizar tamanho do círculo
local function instakill_updateFOVCircle()
    local actualSize = (instakill_fovSize / 100) * instakill_maxFOVSize
    instakill_fovCircle.Size = UDim2.new(0, actualSize, 0, actualSize)
    instakill_fovCircle.Position = UDim2.new(0.5, -actualSize/2, 0.5, -actualSize/2)
end

-- Função CORRIGIDA para verificar se jogador deve ser atacado
local function instakill_shouldAttackPlayer(targetPlayer)
    if not instakill_fovEnabled then
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
    
    local circleCenter = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
    local targetPosition = Vector2.new(screenPoint.X, screenPoint.Y)
    local distance = (targetPosition - circleCenter).magnitude
    
    local actualFOVSize = (instakill_fovSize / 100) * instakill_maxFOVSize / 2
    local isInFOV = distance <= actualFOVSize
    
    return isInFOV
end

-- INSTAKILL OTIMIZADO
local function instakill_asvalInstakillOptimized()
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
        print("❌ RemoteEvent não encontrado")
        return false 
    end
    
    local totalAttacks = 0
    local playersChecked = 0
    
    for _, targetPlayer in pairs(Players:GetPlayers()) do
        if not instakill_enabled then break end
        
        playersChecked = playersChecked + 1
        
        if targetPlayer ~= player and targetPlayer.Character then
            if instakill_shouldAttackPlayer(targetPlayer) then
                local targetLeftArm = targetPlayer.Character:FindFirstChild("Left Arm")
                local targetHumanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
                
                if targetLeftArm and targetHumanoid and targetHumanoid.Health > 0 then
                    for i = 1, 30 do
                        if not instakill_enabled then break end
                        
                        local success, err = pcall(function()
                            damageRemote:FireServer(targetLeftArm)
                            totalAttacks = totalAttacks + 1
                        end)
                        
                        if not success then
                            print("❌ Erro no ataque:", err)
                        end
                        
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
            end
        else
            if targetPlayer == player then
                -- Ignorando self
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

-- Loop principal otimizado
local function instakill_instakillLoop()
    if not instakill_enabled then return end
    
    local success, err = pcall(function()
        instakill_asvalInstakillOptimized()
    end)
    
    if not success then
        print("❌ Erro no loop principal:", err)
    end
    
    task.wait(0.05)
end

-- ======================================================================
-- EVENTOS DA INTERFACE - KILL NAME
-- ======================================================================

-- Abrir/fechar menu principal - SEM ABRIR TECLADO AUTOMÁTICO
killNameBtn.MouseButton1Click:Connect(function()
    killName_mainMenu.Visible = not killName_mainMenu.Visible
    if killName_mainMenu.Visible then
        killName_playerNameBox.Text = killName_lastPlayerName
        if killName_lastPlayerName ~= "" then
            killName_updateSuggestions(killName_lastPlayerName)
        else
            killName_suggestionsList.Visible = false
        end
    end
end)

-- Fechar menu E salvar o texto atual
killName_closeBtn.MouseButton1Click:Connect(function()
    killName_lastPlayerName = killName_playerNameBox.Text
    killName_mainMenu.Visible = false
    killName_suggestionsList.Visible = false
end)

-- Autocomplete enquanto digita
kil