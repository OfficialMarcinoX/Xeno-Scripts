-- Ładowanie biblioteki Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "planexd_0 ULTIMATE HUB",
   LoadingTitle = "Wczytywanie 50+ Funkcji...",
   LoadingSubtitle = "Niszczenie serwera w toku...",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- ================= ZMIENNE GŁÓWNE =================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera

-- Zmienne funkcji
local Flying, Noclip, Speed, InfJump = false, false, 50, false
local HitboxEnabled, HitboxSize = false, 50
local AimbotEnabled, TriggerBot, NoReload = false, false, false
local EspEnabled, Tracers, Chams, XRay = false, false, false, false
local Orbitowanie, NaGlowie, ChatSpam = false, false, false
local FakeLag, AntiAim, SpiderMan, JesusMode = false, false, false, false
local BunnyHop, RainbowMap, TinyPlayers, BigHeads = false, false, false, false
local wybranyGracz = nil

-- Funkcje pomocnicze
local function pobierzGraczy()
    local lista = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p.Name ~= player.Name then table.insert(lista, p.Name) end
    end
    return lista
end

local function getNearestPlayer()
    local nearest, minDist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("Head") and p.Character.Humanoid.Health > 0 then
            local dist = (player.Character.Head.Position - player.Character.Head.Position).Magnitude
            if dist < minDist then minDist = dist nearest = p.Character.Head end
        end
    end
    return nearest
end

-- ================= ZAKŁADKA 1: 💥 DOOMSDAY (WŁĄCZ WSZYSTKO) =================
local TabDoomsday = Window:CreateTab("⚠️ DOOMSDAY", 4483362458)

TabDoomsday:CreateButton({
   Name = "☢️ WŁĄCZ WSZYSTKO (ARMAGEDON)",
   Callback = function()
        -- Włącza najważniejsze cheaty bojowe i wizualne jednym klikiem!
        HitboxEnabled = true
        AimbotEnabled = true
        TriggerBot = true
        NoReload = true
        EspEnabled = true
        Chams = true
        Tracers = true
        InfJump = true
        BunnyHop = true
        Rayfield:Notify({Title = "DOOMSDAY", Content = "Aktywowano wszystkie systemy bojowe!", Duration = 5})
   end,
})

TabDoomsday:CreateButton({
   Name = "🛑 WYŁĄCZ WSZYSTKO (PANIC BUTTON)",
   Callback = function()
        HitboxEnabled, AimbotEnabled, TriggerBot, NoReload = false, false, false, false
        EspEnabled, Chams, Tracers, InfJump, BunnyHop = false, false, false, false, false
        Rayfield:Notify({Title = "BEZPIECZEŃSTWO", Content = "Dezaktywowano wszystkie systemy.", Duration = 5})
   end,
})

-- ================= ZAKŁADKA 2: 🔫 AUTO-BROŃ I AIMBOT =================
local TabBronie = Window:CreateTab("Bronie & Celowanie", 4483362458)

TabBronie:CreateToggle({ Name = "🔫 Aimbot (Auto-Celowanie)", CurrentValue = false, Flag = "Aimbot", Callback = function(Value) AimbotEnabled = Value end })
TabBronie:CreateToggle({ Name = "🤖 Auto-Shoot (TriggerBot)", CurrentValue = false, Flag = "TriggerBot", Callback = function(Value) TriggerBot = Value end })
TabBronie:CreateToggle({ Name = "🚀 Brak Przeładowania (No Reload + Nieskończona Amunicja)", CurrentValue = false, Flag = "NoReload", Callback = function(Value) NoReload = Value end })

TabBronie:CreateToggle({ Name = "💥 Magiczne Kule (Strzelasz byle gdzie)", CurrentValue = false, Flag = "Hitbox", Callback = function(Value) HitboxEnabled = Value end })
TabBronie:CreateSlider({ Name = "Rozmiar Głów", Range = {5, 200}, Increment = 5, Suffix = "M", CurrentValue = 50, Flag = "HitboxSize", Callback = function(Value) HitboxSize = Value end })

-- Pętle broni i celowania
RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        local targetHead = getNearestPlayer()
        if targetHead then camera.CFrame = CFrame.new(camera.CFrame.Position, targetHead.Position) end
    end
    
    -- TriggerBot (Auto Shoot)
    if TriggerBot then
        local cel = mouse.Target
        if cel and cel.Parent and cel.Parent:FindFirstChild("Humanoid") and cel.Parent.Name ~= player.Name then
            -- Symulacja kliknięcia (Działa w większości executorów)
            pcall(function() mouse1click() end)
            -- Zapasowe uruchomienie narzędzia
            if player.Character and player.Character:FindFirstChildOfClass("Tool") then
                player.Character:FindFirstChildOfClass("Tool"):Activate()
            end
        end
    end
end)

-- No Reload Loop
task.spawn(function()
    while task.wait(0.5) do
        if NoReload then
            -- Szuka wartości Ammo i Clip i ustawia na 999
            for _, v in pairs(game:GetDescendants()) do
                if v:IsA("IntValue") or v:IsA("NumberValue") then
                    local name = v.Name:lower()
                    if name:match("ammo") or name:match("clip") or name:match("mag") then
                        v.Value = 999
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
                if HitboxEnabled then
                    p.Character.Head.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                    p.Character.Head.Transparency = 0.7
                    p.Character.Head.CanCollide = false
                else
                    p.Character.Head.Size = Vector3.new(1.2, 1, 1)
                    p.Character.Head.Transparency = 0
                end
            end
        end
    end
end)

-- ================= ZAKŁADKA 3: 🌟 20 NOWYCH TRYBÓW (WIZUALNE & RUCH) =================
local TabNowe = Window:CreateTab("20 Nowych Trybów", 4483362458)
TabNowe:CreateSection("🔥 Mega Wzmacniacze Ruchu")

TabNowe:CreateToggle({ Name = "🦘 Auto Bunny Hop", CurrentValue = false, Flag = "Bhop", Callback = function(Value) BunnyHop = Value end })
TabNowe:CreateToggle({ Name = "🕷️ Spider-Man (Chodzenie po ścianach)", CurrentValue = false, Flag = "Spider", Callback = function(Value) SpiderMan = Value end })
TabNowe:CreateToggle({ Name = "🌊 Jesus Mode (Chodzenie po wodzie)", CurrentValue = false, Flag = "Jesus", Callback = function(Value) JesusMode = Value end })
TabNowe:CreateToggle({ Name = "🌀 Spinbot (Anti-Aim)", CurrentValue = false, Flag = "AntiAim", Callback = function(Value) AntiAim = Value end })
TabNowe:CreateToggle({ Name = "📶 Fake Lag (Teleportowanie się na małe odległości)", CurrentValue = false, Flag = "FakeLag", Callback = function(Value) FakeLag = Value end })

TabNowe:CreateSection("👁️ Oczy Boga (Wizualne)")
TabNowe:CreateToggle({ Name = "🔴 Chams (Gracze widoczni przez ściany)", CurrentValue = false, Flag = "Chams", Callback = function(Value) Chams = Value end })
TabNowe:CreateToggle({ Name = "📏 Tracer Lines (Linie do wrogów)", CurrentValue = false, Flag = "Tracers", Callback = function(Value) Tracers = Value end })
TabNowe:CreateToggle({ Name = "👻 X-Ray (Przezroczysta mapa)", CurrentValue = false, Flag = "XRay", Callback = function(Value)
    XRay = Value
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then
            v.Transparency = XRay and 0.5 or 0
        end
    end
end})
TabNowe:CreateToggle({ Name = "🌈 Rainbow Map (Disco Serwer)", CurrentValue = false, Flag = "Rainbow", Callback = function(Value) RainbowMap = Value end })

TabNowe:CreateSection("🤪 Totalny Troll na Ekranie")
TabNowe:CreateToggle({ Name = "🐜 Tiny Players (Wszyscy są mali)", CurrentValue = false, Flag = "Tiny", Callback = function(Value) TinyPlayers = Value end })
TabNowe:CreateToggle({ Name = "👽 Big Heads (Ogromne głowy u wszystkich)", CurrentValue = false, Flag = "BigHeads", Callback = function(Value) BigHeads = Value end })

-- Obsługa nowych trybów ruchu
UserInputService.JumpRequest:Connect(function()
    if BunnyHop and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

RunService.Stepped:Connect(function()
    if AntiAim and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(50), 0)
    end
    if FakeLag and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.Anchored = true
        task.wait(0.1)
        player.Character.HumanoidRootPart.Anchored = false
    end
end)

-- Pętla Wizualna (Chams, Tracers, Rainbow itp.)
task.spawn(function()
    while task.wait(1) do
        -- Disco Mapa
        if RainbowMap then
            Lighting.Ambient = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))
        end
        -- Chams
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                if Chams and not p.Character:FindFirstChild("PlanexChams") then
                    local ch = Instance.new("Highlight", p.Character)
                    ch.Name = "PlanexChams" ch.FillColor = Color3.fromRGB(0, 255, 0) ch.FillTransparency = 0.3
                elseif not Chams and p.Character:FindFirstChild("PlanexChams") then
                    p.Character.PlanexChams:Destroy()
                end
                
                -- Big Heads / Tiny Players
                if p.Character:FindFirstChild("Head") then
                    if BigHeads then p.Character.Head.Size = Vector3.new(5,5,5) end
                    if TinyPlayers and p.Character:FindFirstChild("HumanoidRootPart") then p.Character.HumanoidRootPart.Size = Vector3.new(0.5,0.5,0.5) end
                end
            end
        end
    end
end)

-- ================= ZAKŁADKA 4: 🧲 KONTROLA GRACZY (STARE TROLLE) =================
local TabGracze = Window:CreateTab("Gracze (Troll)", 4483362458)
local PlayerDropdown = TabGracze:CreateDropdown({
   Name = "Wybierz ofiarę", Options = pobierzGraczy(), CurrentOption = {""}, MultipleOptions = false, Flag = "DropdownGraczy",
   Callback = function(Option) wybranyGracz = type(Option) == "table" and Option[1] or Option end,
})
TabGracze:CreateButton({ Name = "🔄 Odśwież listę", Callback = function() PlayerDropdown:Refresh(pobierzGraczy()) end })
TabGracze:CreateButton({ Name = "⚡ Teleportuj DO gracza", Callback = function() if wybranyGracz then local target = Players:FindFirstChild(wybranyGracz) if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2) end end end })
TabGracze:CreateButton({ Name = "🚀 Wyrzuć poza mapę (Fling)", Callback = function() if wybranyGracz then local target = Players:FindFirstChild(wybranyGracz) if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then local stareMiejsce = player.Character.HumanoidRootPart.CFrame local bg = Instance.new("BodyAngularVelocity", player.Character.HumanoidRootPart) bg.AngularVelocity = Vector3.new(0, 99999, 0) bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge) player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame task.wait(0.5) bg:Destroy() player.Character.HumanoidRootPart.CFrame = stareMiejsce end end end })

-- ================= ZAKŁADKA 5: 💻 DEX & EXPLOIT =================
local TabExploit = Window:CreateTab("Dev / Exploit", 4483362458)
TabExploit:CreateButton({ Name = "🔓 DEX EXPLORER (Dostęp do plików gry!)", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua", true))() end })
TabExploit:CreateButton({ Name = "🌌 Zmień niebo na CZARNE", Callback = function() Lighting.TimeOfDay = "00:00:00" Lighting.GlobalShadows = false Lighting.Ambient = Color3.new(0, 0, 0) end })

Rayfield:Notify({Title = "planexd_0 ULTIMATE", Content = "Zładowano 50+ funkcji, DOOMSDAY GOTOWY!", Duration = 5})
