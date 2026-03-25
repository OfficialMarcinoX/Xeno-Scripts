local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "planexd_0 GOD-MOD & TROLL HUB",
   LoadingTitle = "Ładowanie Systemów Zagłady...",
   LoadingSubtitle = "Rivals & Brookhaven zostaną zniszczone.",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- ================= ZMIENNE =================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

local Flying, Noclip, Speed = false, false, 50
local GodMode, HitboxEnabled, HitboxSize = false, false, 50
local AimbotEnabled, EspEnabled = false, false
local wywalonyNick = ""

-- ================= FUNKCJE POMOCNICZE =================
local function getPlr(name)
    name = string.lower(name)
    for _, p in pairs(Players:GetPlayers()) do
        if string.sub(string.lower(p.Name), 1, #name) == name then return p end
    end
    return nil
end

local function getNearest()
    local nearest, dist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
            local d = (player.Character.Head.Position - p.Character.Head.Position).Magnitude
            if d < dist then dist = d nearest = p.Character.Head end
        end
    end
    return nearest
end

-- ================= ZAKŁADKA 🎯 RIVALS (TOTALNA ROZWAŁKA) =================
local TabRivals = Window:CreateTab("🎯 RIVALS ARMAGEDON", 4483362458)

TabRivals:CreateSection("🔥 GŁÓWNE CHEATY")

TabRivals:CreateToggle({
   Name = "🛡️ GOD MODE (8537498537458934 HP)",
   CurrentValue = false,
   Callback = function(V) 
        GodMode = V 
        if V then player.Character.Humanoid.MaxHealth = 8537498537458934 player.Character.Humanoid.Health = 8537498537458934 end
   end 
})

TabRivals:CreateToggle({
   Name = "🔫 AIMBOT (Zawsze Headshot)",
   CurrentValue = false,
   Callback = function(V) AimbotEnabled = V end
})

TabRivals:CreateToggle({
   Name = "👻 NOCLIP (Chodzenie przez ściany)",
   CurrentValue = false,
   Callback = function(V) Noclip = V end
})

TabRivals:CreateToggle({
   Name = "🔴 ESP (Widzenie przez ściany)",
   CurrentValue = false,
   Callback = function(V) EspEnabled = V end
})

TabRivals:CreateSection("🤡 MEGA TROLLE (WYWALANIE I TP)")

TabRivals:CreateInput({
   Name = "NICK OFIARY", PlaceholderText = "Wpisz nick...",
   Callback = function(T) wywalonyNick = T end,
})

TabRivals:CreateButton({
   Name = "🚀 WYWAL W KOSMOS (FIXED FLING)",
   Callback = function()
        local cel = getPlr(wywalonyNick)
        if cel and cel.Character and cel.Character:FindFirstChild("HumanoidRootPart") then
            local root = player.Character.HumanoidRootPart
            local targetRoot = cel.Character.HumanoidRootPart
            local oldCFrame = root.CFrame
            
            -- Potężny Fling (Velo-Crash)
            local bam = Instance.new("BodyAngularVelocity", root)
            bam.AngularVelocity = Vector3.new(0, 999999, 0)
            bam.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bam.Name = "FlingVelo"
            
            for i = 1, 50 do
                root.CFrame = targetRoot.CFrame * CFrame.new(math.random(-1,1), 0, math.random(-1,1))
                root.Velocity = Vector3.new(999, 999, 999)
                task.wait(0.02)
            end
            
            bam:Destroy()
            root.CFrame = oldCFrame
            Rayfield:Notify({Title="SUKCES", Content="Gracz wyleciał za mapę!"})
        end
   end
})

TabRivals:CreateButton({
   Name = "📍 TELEPORT DO GRACZA",
   Callback = function()
        local cel = getPlr(wywalonyNick)
        if cel and cel.Character then player.Character.HumanoidRootPart.CFrame = cel.Character.HumanoidRootPart.CFrame end
   end
})

TabRivals:CreateToggle({
   Name = "💀 KILL AURA (Bije przez ściany)",
   CurrentValue = false,
   Callback = function(V)
        _G.KillAura = V
        while _G.KillAura do
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("Humanoid") then
                    if (player.Character.Head.Position - p.Character.Head.Position).Magnitude < 50 then
                        pcall(function() p.Character.Humanoid.Health = 0 end) -- Zabija przez ściany w zasięgu 50m
                    end
                end
            end
            task.wait(0.1)
        end
   end
})

-- ================= ZAKŁADKA 🏡 BROOKHAVEN (CHAOS) =================
local TabBrook = Window:CreateTab("🏡 BROOKHAVEN TROLL", 4483362458)

TabBrook:CreateButton({ Name = "🔓 OTWÓRZ WSZYSTKIE AUTA", Callback = function() for _, v in pairs(workspace.Vehicles:GetChildren()) do pcall(function() v.UnLocked.Value = true end) end end })
TabBrook:CreateButton({ Name = "🔥 SPAL WSZYSTKIE AUTA", Callback = function() for _, v in pairs(workspace.Vehicles:GetChildren()) do pcall(function() v.Fire:FireServer(true) end) end end })
TabBrook:CreateButton({ Name = "💰 TP DO SEJFU", Callback = function() -- Prosty TP do najbliższego sejfu
    for _, v in pairs(workspace:GetDescendants()) do if v.Name == "Safe" then player.Character.HumanoidRootPart.CFrame = v.CFrame break end end
end })

-- ================= SYSTEMY RENDERA (PĘTLE) =================
RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        local t = getNearest()
        if t then camera.CFrame = CFrame.new(camera.CFrame.Position, t.Position) end
    end
    
    if Noclip and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
    
    if GodMode and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.Health = 8537498537458934
    end
end)

-- ESP System
task.spawn(function()
    while task.wait(1) do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                if EspEnabled and not p.Character:FindFirstChild("EspBox") then
                    local h = Instance.new("Highlight", p.Character) h.Name = "EspBox" h.FillColor = Color3.fromRGB(255,0,0)
                elseif not EspEnabled and p.Character:FindFirstChild("EspBox") then
                    p.Character.EspBox:Destroy()
                end
            end
        end
    end
end)

Rayfield:Notify({Title = "planexd_0 HUB", Content = "Poprawiono 800000 błędów. Jesteś Bogiem!", Duration = 5})
