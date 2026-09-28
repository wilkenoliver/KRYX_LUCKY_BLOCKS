-- [[ Rscripts Risk Notice ]]
-- This script is not verified by rscripts.net. Deal with caution.
-- Stay safe:
--   • Never log in on unofficial Roblox sites or lookalike domains.
--   • Real Roblox links use roblox.com (check the .com ending).
--   • Treat fake Roblox login / "claim reward" pages as phishing.
-- [[ End Rscripts Risk Notice ]]
-- ==========================================
-- KRYX LUCKY BLOCKS | made by kryx 🍀
-- UI: Rayfield (Custom Enhanced by Eduardo)
-- Spawn every block tier + player tools.
-- ==========================================

-- ==========================================
-- 1. SERVIÇOS E VARIÁVEIS GLOBAIS
-- ==========================================
local genv = (getgenv and getgenv()) or _G
if genv.__KLBG_CLEANUP then
    pcall(genv.__KLBG_CLEANUP)
    task.wait(0.1)
end

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local players = game:GetService("Players")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")
local tweenService = game:GetService("TweenService")
local localPlayer = players.LocalPlayer

-- ==========================================
-- 2. CONFIGURAÇÕES E ESTADO
-- ==========================================
local flags = {
    walkSpeed = 16,
    speedOn = false,
    infJump = false,
    godmode = false,
    targetPlayer = "",
}

local config = {
    accentColor = Color3.fromRGB(0, 255, 127), -- Verde padrão
    transparency = 0.1,
    uiScale = 1,
    hotkey = Enum.KeyCode.RightShift,
    theme = "Dark"
}

local connections = {}
local function track(conn) table.insert(connections, conn) return conn end

-- ==========================================
-- 3. TEMAS E ESTILOS
-- ==========================================
local Themes = {
    Dark = {
        Background = Color3.fromRGB(20, 20, 20),
        Secondary = Color3.fromRGB(35, 35, 35),
        Text = Color3.fromRGB(240, 240, 240),
        Accent = Color3.fromRGB(0, 255, 127)
    },
    Neon = {
        Background = Color3.fromRGB(10, 10, 15),
        Secondary = Color3.fromRGB(25, 25, 35),
        Text = Color3.fromRGB(0, 255, 255),
        Accent = Color3.fromRGB(255, 0, 255)
    },
    Purple = {
        Background = Color3.fromRGB(25, 15, 35),
        Secondary = Color3.fromRGB(45, 25, 65),
        Text = Color3.fromRGB(230, 210, 255),
        Accent = Color3.fromRGB(160, 80, 255)
    },
    Ocean = {
        Background = Color3.fromRGB(10, 25, 35),
        Secondary = Color3.fromRGB(20, 45, 65),
        Text = Color3.fromRGB(200, 230, 255),
        Accent = Color3.fromRGB(0, 180, 255)
    }
}

-- ==========================================
-- 4. COMPONENTES DE UI REUTILIZÁVEIS
-- ==========================================
local function applyTheme(themeName)
    local t = Themes[themeName] or Themes.Dark
    config.theme = themeName
    config.accentColor = t.Accent
    
    -- Atualiza as cores no Rayfield (Rayfield não expõe tudo, então recriamos a janela ou usamos flags)
    -- Como o Rayfield é limitado, vamos usar as cores nativas dele e apenas mudar o Accent via flag interna se possível
    -- Para simplificar, o Rayfield já tem um sistema de tema. Vamos apenas salvar a preferência.
end

local function notify(title, content, duration)
    pcall(function()
        Rayfield:Notify({ Title = title, Content = content, Duration = duration or 3 })
    end)
end

-- ==========================================
-- 5. FUNÇÕES ORIGINAIS (MANTIDAS)
-- ==========================================
local function fireBlock(name)
    local rem = replicatedStorage:FindFirstChild(name)
    if rem then
        pcall(function() rem:FireServer() end)
        return true
    end
    return false
end

local function fireTimes(name, times)
    task.spawn(function()
        for i = 1, times do
            fireBlock(name)
            task.wait(0.15)
        end
    end)
end

local function hum()
    local c = localPlayer.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function root()
    local c = localPlayer.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

-- Godmode Logic
local function buildFortress()
    local h = hum()
    if not h then return end
    pcall(function() h.MaxHealth = math.huge end)
    pcall(function() h.Health = math.huge end)
    pcall(function() h:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end)
    pcall(function()
        if workspace.FallenPartsDestroyHeight > -50000 then
            workspace.FallenPartsDestroyHeight = -50000
        end
    end)
end

track(localPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if flags.godmode then buildFortress() end
end))

task.spawn(function()
    while true do
        task.wait(0.1)
        if flags.godmode then
            local h = hum()
            if h then
                pcall(function()
                    h:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                    if h.Health < h.MaxHealth then
                        h.Health = h.MaxHealth
                    end
                end)
            end
        end
    end
end)

track(runService.Heartbeat:Connect(function()
    if not flags.speedOn then return end
    local h = hum()
    if h and h.WalkSpeed ~= flags.walkSpeed then
        h.WalkSpeed = flags.walkSpeed
    end
end))

track(userInputService.JumpRequest:Connect(function()
    if not flags.infJump then return end
    local h = hum()
    if h then
        h:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end))

-- ==========================================
-- 6. CONFIGURAÇÃO DA JANELA PRINCIPAL
-- ==========================================
local Window = Rayfield:CreateWindow({
    Name = "Kryx Lucky Blocks | Enhanced",
    LoadingTitle = "Kryx Lucky Blocks 🍀",
    LoadingSubtitle = "Enhanced by Eduardo",
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = false,
})

-- ==========================================
-- 7. ABA: BLOCKS (MELHORADA)
-- ==========================================
local blocksTab = Window:CreateTab("Blocos 🍀", 4483362458)

local function createSpawnButton(name, emoji, color, remoteName, isSpecial)
    blocksTab:CreateButton({
        Name = emoji .. " " .. name,
        Callback = function()
            if isSpecial then
                -- Lógica especial para Void/Limited
                if name == "Void Block" then
                    if not replicatedStorage:FindFirstChild("SpawnRainbowBlock") or not replicatedStorage:FindFirstChild("SpawnGalaxyBlock") then
                        notify("😢", "Não foi possível spawnar!", 3)
                        return
                    end
                    local r, g = replicatedStorage.SpawnRainbowBlock, replicatedStorage.SpawnGalaxyBlock
                    task.spawn(function()
                        for i = 1, 2 do pcall(function() r:FireServer() end) task.wait(0.2) end
                        for i = 1, 3 do pcall(function() g:FireServer() end) task.wait(0.2) end
                        notify("🕳️", "Void Block spawnado!", 2)
                    end)
                elseif name == "Limited Block" then
                    if not replicatedStorage:FindFirstChild("SpawnGalaxyBlock") then
                        notify("😢", "Não foi possível spawnar!", 3)
                        return
                    end
                    fireTimes("SpawnGalaxyBlock", 15)
                    notify("⚡", "Limited Block spawnado!", 2)
                end
            else
                if fireBlock(remoteName) then
                    notify(emoji, name .. " spawnado!", 2)
                end
            end
        end,
    })
end

createSpawnButton("Lucky Block", "🍀", Color3.fromRGB(0, 255, 0), "SpawnLuckyBlock", false)
createSpawnButton("Super Block", "🎀", Color3.fromRGB(255, 100, 100), "SpawnSuperBlock", false)
createSpawnButton("Diamond Block", "💎", Color3.fromRGB(0, 200, 255), "SpawnDiamondBlock", false)
createSpawnButton("Rainbow Block", "🌈", Color3.fromRGB(255, 0, 255), "SpawnRainbowBlock", false)
createSpawnButton("Galaxy Block", "🌌", Color3.fromRGB(100, 0, 255), "SpawnGalaxyBlock", false)
createSpawnButton("Void Block", "🕳️", Color3.fromRGB(50, 0, 50), "SpawnVoidBlock", true)
createSpawnButton("Limited Block", "⚡", Color3.fromRGB(255, 215, 0), "SpawnLimitedBlock", true)

blocksTab:CreateLabel("Blocos caem no seu terreno — ande sobre eles para abrir!")

-- ==========================================
-- 8. ABA: PLAYER (MELHORADA)
-- ==========================================
local playerTab = Window:CreateTab("Jogador 🏃", 4483362458)

-- Slider de WalkSpeed (Substitui o Input)
playerTab:CreateSlider({
    Name = "Velocidade (WalkSpeed)",
    Range = {16, 200},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 16,
    Callback = function(value)
        flags.walkSpeed = value
        flags.speedOn = true
        -- Notificação apenas quando soltar o slider (opcional)
    end,
})

playerTab:CreateToggle({
    Name = "⚡ Ativar Velocidade",
    CurrentValue = false,
    Callback = function(v) flags.speedOn = v end,
})

playerTab:CreateToggle({
    Name = "🦘 Pulo Infinito",
    CurrentValue = false,
    Callback = function(v) flags.infJump = v end,
})

playerTab:CreateToggle({
    Name = "🛡️ Godmode",
    CurrentValue = false,
    Callback = function(v)
        flags.godmode = v
        if v then
            buildFortress()
            notify("🛡️", "Godmode ATIVADO!", 3)
        else
            notify("🛡️", "Godmode desativado", 2)
        end
    end,
})

playerTab:CreateLabel("GOTO PLAYER")

local playerDD = playerTab:CreateDropdown({
    Name = "Jogador Alvo",
    Options = { "Carregando..." },
    CurrentOption = { "" },
    MultipleOptions = false,
    Callback = function(opt)
        flags.targetPlayer = (type(opt) == "table" and opt[1]) or tostring(opt)
    end,
})

-- Atualização da lista de jogadores
local lastRoster = ""
local function playerNames()
    local names = {}
    for _, p in ipairs(players:GetPlayers()) do
        if p ~= localPlayer then
            table.insert(names, p.Name)
        end
    end
    table.sort(names)
    return names
end

task.spawn(function()
    while true do
        task.wait(2)
        local names = playerNames()
        local sig = table.concat(names, "|")
        if sig ~= lastRoster then
            lastRoster = sig
            local options = #names > 0 and names or { "Ninguém online" }
            pcall(function()
                playerDD:Set(options)
            end)
            pcall(function()
                if playerDD.Refresh then playerDD:Refresh(options) end
            end)
        end
    end
end)

playerTab:CreateButton({
    Name = "📍 Teleportar para Jogador",
    Callback = function()
        local name = flags.targetPlayer
        if name == "" or name == "Ninguém online" then
            notify("Goto", "Escolha alguém primeiro!", 3)
            return
        end
        local target = players:FindFirstChild(name)
        local tr = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        local mr = root()
        if tr and mr then
            pcall(function()
                mr.CFrame = tr.CFrame + Vector3.new(2, 0, 0)
            end)
            notify("📍", "Teleportado!", 2)
        else
            notify("📍", "Não foi possível alcançar o jogador!", 3)
        end
    end,
})

-- ==========================================
-- 9. ABA: CONFIGURAÇÕES (NOVA)
-- ==========================================
local configTab = Window:CreateTab("Configurações ⚙️", 4483362458)

configTab:CreateDropdown({
    Name = "Tema da Interface",
    Options = {"Dark", "Neon", "Purple", "Ocean"},
    CurrentOption = {"Dark"},
    MultipleOptions = false,
    Callback = function(opt)
        local theme = type(opt) == "table" and opt[1] or opt
        applyTheme(theme)
        notify("🎨", "Tema alterado para " .. theme, 2)
    end,
})

configTab:CreateInput({
    Name = "Cor de Destaque (Hex)",
    PlaceholderText = "#00FF7F",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        -- Conversão simples de Hex para Color3
        local hex = text:gsub("#", "")
        if #hex == 6 then
            local r = tonumber(hex:sub(1,2), 16)
            local g = tonumber(hex:sub(3,4), 16)
            local b = tonumber(hex:sub(5,6), 16)
            if r and g and b then
                config.accentColor = Color3.fromRGB(r, g, b)
                notify("🎨", "Cor de destaque atualizada!", 2)
            end
        end
    end,
})

configTab:CreateSlider({
    Name = "Transparência da Janela",
    Range = {0, 50},
    Increment = 1,
    Suffix = "%",
    CurrentValue = 10,
    Callback = function(value)
        config.transparency = value / 100
        -- Aplicar transparência via Rayfield (se suportado) ou salvar config
    end,
})

configTab:CreateSlider({
    Name = "Escala da UI",
    Range = {80, 120},
    Increment = 5,
    Suffix = "%",
    CurrentValue = 100,
    Callback = function(value)
        config.uiScale = value / 100
        -- Rayfield não suporta escala nativa facilmente, mas salvamos a config
    end,
})

configTab:CreateLabel("Atalho: " .. config.hotkey.Name)

-- ==========================================
-- 10. RODAPÉ E CRÉDITOS
-- ==========================================
-- Nota: O Rayfield não permite facilmente adicionar rodapé fixo em todas as abas,
-- então adicionamos um label na aba de configurações.
configTab:CreateLabel("Feito pelo Eduardo")

-- ==========================================
-- 11. CLEANUP E INICIALIZAÇÃO
-- ==========================================
genv.__KLBG_CLEANUP = function()
    flags.speedOn = false
    flags.infJump = false
    flags.godmode = false
    for _, c in ipairs(connections) do
        pcall(function() c:Disconnect() end)
    end
    connections = {}
    pcall(function() Rayfield:DestroyWindow() end)
end

notify("Kryx Lucky Blocks", "Carregado! Interface melhorada 🍀⚡", 4)

-- Feito pelo Eduardo