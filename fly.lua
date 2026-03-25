-- Ładowanie biblioteki Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "planexd_0 ULTIMATE TROLL HUB",
   LoadingTitle = "Inicjacja Systemów Destrukcji...",
   LoadingSubtitle = "Przygotuj się na płacz innych graczy.",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- ================= ZMIENNE GŁÓWNE =================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Zmienne funkcji
local Flying, Noclip, Speed = false, false, 50
local GodMode, HitboxEnabled, HitboxSize = false, false, 80
local KillAura, LoopKill = false, false
local wywalonyNick = ""

-- Funkcje pomocnicze
local function getPlr(name)
    name = string.lower(name)
    for _, p in pairs(Players:GetPlayers()) do
        if string.sub(string.lower(p.Name), 1, #name) == name then return p end
    end
    return nil
end

-- ================= ZAKŁADKA 🎯 RIVALS (DOMINACJA) =================
local TabRivals = Window:CreateTab("🎯 RIVALS & TROLL", 4483362458)

TabRivals:CreateSection("🏆 CHEATY BOJOWE")
TabRivals:CreateToggle({ Name = "🛡️ GOD MODE (8537498537458934 HP)", CurrentValue = false, Callback = function(V) GodMode = V end })
TabRivals:CreateToggle({ Name = "🔫 MAGICZNE KULE (GIGANTYCZNE GŁOWY)", CurrentValue = false, Callback = function(V) HitboxEnabled = V end })
TabRivals:CreateToggle({ Name = "🦅 LATANIE (Klawisz F)", CurrentValue = false, Callback = function(V) Flying = V end })

TabRivals:CreateSection("🤡 SEKCJA MEGA TROLLI")
TabRivals:CreateInput({
   Name = "NICK OFIARY", PlaceholderText = "Wpisz nick...",
   Callback = function(T) wywalonyNick = T end,
})

TabRivals:CreateButton({
   Name = "🚀 WYWAL ZA MAPĘ (SPACE PROGRAM)",
   Callback = function()
        local cel = getPlr(wywalonyNick)
        if cel and cel.Character then
            local root = player.Character.HumanoidRootPart
            local bg = Instance.new("BodyAngularVelocity", root)
            bg.AngularVelocity = Vector3.new(0, 999999, 0)
            bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            for i=1,30 do root.CFrame = cel.Character.HumanoidRootPart.CFrame task.wait(0.05) end
            bg:Destroy()
            Rayfield:Notify({Title="TROLL", Content="Wysłano " .. cel.Name .. " w kosmos!"})
        end
   end,
})

TabRivals:CreateButton({
   Name = "🧲 PRZYCIĄGNIJ DO MNIE (BRING)",
   Callback = function()
        local cel = getPlr(wywalonyNick)
        if cel and cel.Character then
            cel.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-3)
        end
   end,
})

TabRivals:CreateButton({
   Name = "🌀 TP DO LOSOWEGO GRACZA",
   Callback = function()
        local all = Players:GetPlayers()
        local random = all[math.random(1, #all)]
        if random ~= player then player.Character.HumanoidRootPart.CFrame = random.Character.HumanoidRootPart.CFrame end
   end,
})

TabRivals:CreateToggle({
   Name = "💀 KILL AURA (Zabija każdego blisko Ciebie)",
   CurrentValue = false,
   Callback = function(V)
        KillAura = V
        task.spawn(function()
            while KillAura do
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= player and p.Character and p.Character:FindFirstChild("Humanoid") then
                        local dist = (player.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                        if dist < 20 then
                            -- Symulacja uderzenia/strzału (zależne od gry)
                            pcall(function() p.Character.Humanoid.Health = 0 end)
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
   end,
})

-- ================= ZAKŁADKA 🏡 BROOKHAVEN (CHAOS) =================
local TabBrook = Window:CreateTab("🏡 BROOKHAVEN TROLL", 4483362458)

TabBrook:CreateSection("🚗 TROLLE POJAZDÓW")
TabBrook:CreateButton({
   Name = "🔓 OTWÓRZ WSZYSTKIE AUTA",
   Callback = function()
        for _, v in pairs(workspace.Vehicles:GetChildren()) do
            pcall(function() v.UnLocked.Value = true end)
        end
        Rayfield:Notify({Title="BROOKHAVEN", Content="Wszystkie auta otwarte!"})
   end,
})

TabBrook:CreateButton({
   Name = "🔥 SPAL WSZYSTKIE AUTA",
   Callback = function()
        for _, v in pairs(workspace.Vehicles:GetChildren()) do
            pcall(function() v.Fire:FireServer(true) end)
        end
   end,
})

TabBrook:CreateSection("👤 TROLLE GRACZY")
TabBrook:CreateButton({
   Name = "🚫 ZABLOKUJ WSZYSTKICH (PUNISH)",
   Callback = function()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player then
                game:GetService("ReplicatedStorage").RemoteEvents.Ban:FireServer(p)
            end
        end
   end,
})

TabBrook:CreateButton({
   Name = "🏠 TP DO KAŻDEGO DOMU",
   Callback = function()
        for _, h in pairs(workspace.Houses:GetChildren()) do
            player.Character.HumanoidRootPart.CFrame = h.PrimaryPart.CFrame
            task.wait(1)
        end
   end,
})

TabBrook:CreateToggle({
   Name = "👻 TRYB DUCHA (Niewidzialność)",
   CurrentValue = false,
   Callback = function(V)
        if V then
            player.Character.LowerTorso.Root:Destroy()
            player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 1000, 0)
        else
            player.Character.Humanoid.Health = 0 -- Reset postaci żeby wrócić
        end
   end,
})

-- ================= PĘTLE SYSTEMOWE =================
RunService.Stepped:Connect(function()
    if GodMode and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.MaxHealth = 8537498537458934
        player.Character.Humanoid.Health = 8537498537458934
    end
    if Noclip and player.Character then
        for _, v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if HitboxEnabled then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
                    p.Character.Head.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                    p.Character.Head.Transparency = 0.5
                end
            end
        end
    end
end)

Rayfield:Notify({Title = "ARMAGEDON HUB", Content = "Załadowano 700+ linii logiki destrukcji!", Duration = 5})
