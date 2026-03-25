local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "planexd_0 SERWER DESTROYER",
   LoadingTitle = "Inicjowanie wirusa mapy...",
   LoadingSubtitle = "Koniec zabawy dla innych.",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- ================= ZMIENNE =================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local workspace = game:GetService("Workspace")

-- ================= ZAKŁADKA ☢️ SERWER CRASH & DESTROY =================
local TabDestruction = Window:CreateTab("☢️ SERWER DESTROY", 4483362458)

TabDestruction:CreateSection("🔨 DESTRUKCJA MAPY")

TabDestruction:CreateButton({
   Name = "🔥 USUŃ KOTWICE (MAPA SPADA)",
   Callback = function()
        Rayfield:Notify({Title = "ATAK", Content = "Rozpoczynam zwalanie mapy...", Duration = 3})
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and not obj:IsDescendantOf(player.Character) then
                -- Próba wymuszenia fizyki na obiektach mapy
                pcall(function()
                    obj.Anchored = false
                    obj.CanCollide = true
                    obj.Velocity = Vector3.new(0, -100, 0)
                end)
            end
        end
        Rayfield:Notify({Title = "SUKCES", Content = "Mapa powinna teraz spadać u wszystkich!", Duration = 5})
   end
})

TabDestruction:CreateButton({
   Name = "🏠 MASS TP (WSZYSCY DO DOMU)",
   Callback = function()
        -- Szukamy pierwszego lepszego domu w Brookhaven lub punktu w Rivals
        local targetPos = Vector3.new(0, 50, 0) 
        if workspace:FindFirstChild("Houses") then
            targetPos = workspace.Houses:GetChildren()[1].PrimaryPart.Position
        end

        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                pcall(function()
                    -- Próba porwania gracza (wymaga luki w fizyce lub RemoteEventu)
                    p.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos)
                end)
            end
        end
        Rayfield:Notify({Title = "TROLL", Content = "Próba teleportacji wszystkich graczy!", Duration = 3})
   end
})

TabDestruction:CreateSection("🤡 TROLLE WIZUALNE")

TabDestruction:CreateButton({
   Name = "🌌 TRYB NOCY DLA WSZYSTKICH",
   Callback = function()
        pcall(function()
            game:GetService("Lighting").TimeOfDay = "00:00:00"
            game:GetService("Lighting").Brightness = 0
            game:GetService("Lighting").FogEnd = 0
        end)
   end
})

-- ================= ZAKŁADKA 🎯 RIVALS FIXED =================
local TabRivals = Window:CreateTab("🎯 RIVALS & ESP", 4483362458)

TabRivals:CreateToggle({
   Name = "🔫 AUTO-HEADSHOT (AIMBOT)",
   CurrentValue = false,
   Callback = function(V) _G.Aimbot = V end
})

TabRivals:CreateToggle({
   Name = "🧱 NOCLIP (ŚCIANY)",
   CurrentValue = false,
   Callback = function(V) _G.Noclip = V end
})

TabRivals:CreateToggle({
   Name = "🔴 ESP (WIDZENIE PRZEZ ŚCIANY)",
   CurrentValue = false,
   Callback = function(V) _G.ESP = V end
})

-- ================= PĘTLE (LOGIKA) =================
RunService.Stepped:Connect(function()
    if _G.Noclip and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- Pętla Aimbota i ESP
task.spawn(function()
    while task.wait() do
        if _G.Aimbot then
            -- Prosta logika celowania w najbliższego
            local target = nil
            local dist = math.huge
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
                    local d = (player.Character.Head.Position - p.Character.Head.Position).Magnitude
                    if d < dist then dist = d target = p.Character.Head end
                end
            end
            if target then workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Position) end
        end
        
        if _G.ESP then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character and not p.Character:FindFirstChild("Highlight") then
                    Instance.new("Highlight", p.Character)
                end
            end
        end
    end
end)

Rayfield:Notify({Title = "POZIOM BOGA", Content = "Skrypt gotowy do niszczenia serwera!", Duration = 5})
