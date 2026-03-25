local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "planexd_0 SERVER BREAKER v4",
   LoadingTitle = "Wstrzykiwanie Destruktora...",
   LoadingSubtitle = "Serwer zaraz padnie.",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- ================= ZMIENNE FIZYKI (Dla Widoczności u Innych) =================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Ustawienie sieciowe (żeby inni widzieli Twoje przesunięcia obiektów)
settings().Physics.AllowSleep = false
sethiddenproperty(player, "SimulationRadius", 1000)
sethiddenproperty(player, "MaxSimulationRadius", 1000)

-- ================= ZAKŁADKA 🚌 VEHICLE KILL & MASS TROLL =================
local TabMass = Window:CreateTab("🚌 MASS KILL & TROLL", 4483362458)

TabMass:CreateSection("🚌 BUS KILL (WIDOCZNE DLA WSZYSTKICH)")

TabMass:CreateButton({
   Name = "🚌 ODPAL BUS KILL (Porywa auta i zabija)",
   Callback = function()
        Rayfield:Notify({Title = "ATTACK", Content = "Porywanie pojazdów do ataku...", Duration = 3})
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("VehicleSeat") or v:IsA("DriveSeat") then
                task.spawn(function()
                    while task.wait() do
                        -- Teleportujemy auto w graczy z ogromną prędkością
                        for _, p in pairs(Players:GetPlayers()) do
                            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                                v.Parent:SetPrimaryPartCFrame(p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2))
                                v.Parent.PrimaryPart.Velocity = Vector3.new(500, 500, 500)
                            end
                        end
                    end
                end)
            end
        end
   end
})

TabMass:CreateSection("⚡ SERWER EXPLOITS")

TabMass:CreateButton({
   Name = "🧨 LAGGER SERWERA (SPAM REMOTES)",
   Callback = function()
        Rayfield:Notify({Title = "CRASH", Content = "Spamowanie serwera danymi...", Duration = 5})
        while task.wait(0.01) do
            for _, v in pairs(game:GetDescendants()) do
                if v:IsA("RemoteEvent") then
                    v:FireServer("planexd_0_LAG_POWER", math.huge, string.rep("CRASH", 1000))
                end
            end
        end
   end
})

TabMass:CreateButton({
   Name = "💀 KILL ALL (Jeśli gra ma dziury)",
   Callback = function()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("Humanoid") then
                pcall(function()
                    -- Próba ataku przez luki w eventach bojowych
                    game:GetService("ReplicatedStorage").RemoteEvents.Damage:FireServer(p.Character.Humanoid, 100)
                end)
            end
        end
   end
})

-- ================= ZAKŁADKA 🛠️ MAP DESTRUCTOR =================
local TabMap = Window:CreateTab("🛠️ MAP DESTROY", 4483362458)

TabMap:CreateButton({
   Name = "💥 WYŁĄCZ KOTWICE (MAPA SPADA - FE)",
   Callback = function()
        -- Aby to było widoczne u innych, musisz dotknąć obiektów (Network Ownership)
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and part.Anchored == true then
                pcall(function()
                    player.Character.HumanoidRootPart.CFrame = part.CFrame
                    part.Anchored = false
                    part.CanCollide = true
                    part.Velocity = Vector3.new(0, -500, 0)
                end)
            end
        end
   end
})

TabMap:CreateButton({
   Name = "❌ USUŃ WSZYSTKIE SKRYPTY (LOCAL)",
   Callback = function()
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("LocalScript") or v:IsA("ModuleScript") then
                v:Destroy()
            end
        end
        Rayfield:Notify({Title = "DESTROJER", Content = "Skrypty lokalne usunięte. Gra powinna przestać działać."})
   end
})

-- ================= PĘTLE BOJOWE =================
RunService.Stepped:Connect(function()
    -- Niezmodyfikowany Noclip dla planexd_0
    if _G.Noclip then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- Auto-Simulation Radius (Klucz do widoczności Twoich cheatów u innych)
task.spawn(function()
    while task.wait() do
        player.MaximumSimulationRadius = math.huge
        player.SimulationRadius = math.huge
    end
end)

Rayfield:Notify({Title = "PLANEXD_0 EXPLOIT", Content = "Zabezpieczenia serwera złamane. Baw się dobrze!", Duration = 5})
