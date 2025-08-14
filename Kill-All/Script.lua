-- ⚡ AS-VAL INSTAKILL OTIMIZADO - CORRIGIDO
-- Bug do instakill que para após tempo corrigido

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local enabled = false
local fovEnabled = false
local fovSize = 200  -- Tamanho padrão do círculo (0-100 range)
local maxFOVSize = 500  -- Tamanho máximo do círculo

-- UI
local screenGui = Instance.new("ScreenGui")
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

-- Toggle Button
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

-- Função para atualizar tamanho do círculo
local function updateFOVCircle()
    local actualSize = (fovSize / 100) * maxFOVSize
    fovCircle.Size = UDim2.new(0, actualSize, 0, actualSize)
    fovCircle.Position = UDim2.new(0.5, -actualSize/2, 0.5, -actualSize/2)
end

-- Toggle principal
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

-- TÉCNICA PROFSSIONAL: Usar getnilinstances como no seu exemplo
local function getNilDamageRemote()
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
    local damageRemote = getNilDamageRemote()
    
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

spawn(function()
    while true do
        if enabled then
            instakillLoop()
        end
        task.wait(0.01)
    end
end)

-- Atualizar posição do círculo continuamente
spawn(function()
    while true do
        if fovEnabled then
            updateFOVCircle()
        end
        task.wait(0.05)  -- Aumentado para menos processamento
    end
end)

print("⚡ AS-VAL INSTAKILL OTIMIZADO - BUG CORRIGIDO")
print("🔧 Problemas identificados e resolvidos:")
print("   - Verificação clara de quando atacar")
print("   - Mensagens de debug para identificar problemas")
print("   - Tratamento de erros robusto")
print("   - Loop mais estável")
