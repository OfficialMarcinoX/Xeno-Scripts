-- Ładowanie biblioteki Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "planexd_0 MEGA HUB",
   LoadingTitle = "Ładowanie potężnych skryptów...",
   LoadingSubtitle = "Obejście zabezpieczeń...",
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

local Flying, Noclip, Speed, InfJump = false, false, 16, false
local HitboxEnabled, HitboxSize = false, 50
local bv

-- ================= FUNKCJE POMOCNICZE =================
local function getNearestPlayer()
    local nearest, minDist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local dist = (player.Character.Head.Position - player.Character.Head.Position).Magnitude
            if dist < minDist then minDist = dist nearest = p.Character.Head end
        end
    end
    return nearest
end

local function toggleFly()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    local root = player.Character.HumanoidRootPart
    if Flying then
        bv = Instance.new("BodyVelocity", root)
        bv.Name = "XenoNapęd"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        task.spawn(function()
            while Flying do
                bv.Velocity = mouse.Hit.lookVector * Speed
                task.wait()
            end
            if bv then bv:Destroy() end
        end)
    else
        if bv then bv:Destroy() end
    end
end

-- ================= ZAKŁADKA 1: 🎯 BOJOWE (RIVALS) =================
local TabBojowe = Window:CreateTab("Bojowe / Rivals", 4483362458)
TabBojowe:CreateSection("🔥 Niszczenie Serwera")

TabBojowe:CreateToggle({
   Name = "💥 Magiczne Kule V3 (GIGA GŁOWY)", CurrentValue = false, Flag = "Hitbox",
   Callback = function(Value) HitboxEnabled = Value end,
})
TabBojowe:CreateSlider({
   Name = "Rozmiar Głów (Hitbox)", Range = {5, 200}, Increment = 5, Suffix = "M", CurrentValue = 50, Flag = "HitboxSize",
   Callback = function(Value) HitboxSize = Value end,
})

-- Pętla powiększająca głowy w czasie rzeczywistym
task.spawn(function()
    while task.wait(0.5) do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
                if HitboxEnabled then
                    p.Character.Head.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                    p.Character.Head.Transparency = 0.7 -- Widać lekko szare pole, w które musisz strzelić
                    p.Character.Head.CanCollide = false
                    p.Character.Head.Massless = true
                else
                    p.Character.Head.Size = Vector3.new(1.2, 1, 1) -- Domyślny rozmiar
                    p.Character.Head.Transparency = 0
                end
            end
        end
    end
end)

local AimbotEnabled = false
TabBojowe:CreateToggle({
   Name = "🔫 Aimbot (Automatyczne celowanie)", CurrentValue = false, Flag = "Aimbot",
   Callback = function(Value) AimbotEnabled = Value end,
})
RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        local targetHead = getNearestPlayer()
        if targetHead then camera.CFrame = CFrame.new(camera.CFrame.Position, targetHead.Position) end
    end
end)

-- ================= ZAKŁADKA 2: 👁️ WIZUALNE =================
local TabWizualne = Window:CreateTab("Wizualne", 4483362458)

local EspEnabled = false
TabWizualne:CreateToggle({
   Name = "👁️ ESP (Podświetlenie graczy)", CurrentValue = false, Flag = "ESP",
   Callback = function(Value)
        EspEnabled = Value
        while EspEnabled do
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character and not p.Character:FindFirstChild("PlanexESP") then
                    local h = Instance.new("Highlight") h.Name = "PlanexESP"
                    h.FillColor = Color3.fromRGB(255, 0, 0) h.FillTransparency = 0.5 h.Parent = p.Character
                end
            end
            task.wait(1)
        end
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("PlanexESP") then p.Character.PlanexESP:Destroy() end
        end
   end,
})

local Fullbright = false
TabWizualne:CreateToggle({
   Name = "☀️ FullBright (Brak cieni, widno w nocy)", CurrentValue = false, Flag = "Fullbright",
   Callback = function(Value)
        Fullbright = Value
        if Fullbright then
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.GlobalShadows = false
        else
            Lighting.Ambient = Color3.fromRGB(128, 128, 128)
            Lighting.GlobalShadows = true
        end
   end,
})

TabWizualne:CreateSlider({
   Name = "🔭 Zmiana FOV (Kąt widzenia kamery)", Range = {70, 120}, Increment = 1, Suffix = "FOV", CurrentValue = 70, Flag = "FOV",
   Callback = function(Value) camera.FieldOfView = Value end,
})

-- ================= ZAKŁADKA 3: 🏃 RUCH =================
local TabRuch = Window:CreateTab("Ruch", 4483362458)

local FlyToggle = TabRuch:CreateToggle({
   Name = "🦅 Latanie (Klawisz F)", CurrentValue = false, Flag = "Fly",
   Callback = function(Value) Flying = Value toggleFly() end,
})
TabRuch:CreateSlider({
   Name = "Prędkość latania", Range = {10, 300}, Increment = 1, Suffix = "Spd", CurrentValue = 50, Flag = "FlySpd",
   Callback = function(Value) Speed = Value end,
})
mouse.KeyDown:Connect(function(key)
    if key:lower() == "f" then Flying = not Flying FlyToggle:Set(Flying) toggleFly() end
end)

TabRuch:CreateSlider({
   Name = "⚡ Szybkie Bieganie (WalkSpeed)", Range = {16, 250}, Increment = 1, Suffix = "WS", CurrentValue = 16, Flag = "WalkSpeed",
   Callback = function(Value)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = Value
        end
   end,
})

TabRuch:CreateSlider({
   Name = "🦘 Siła Skoku (JumpPower)", Range = {50, 300}, Increment = 1, Suffix = "JP", CurrentValue = 50, Flag = "JumpPower",
   Callback = function(Value)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.UseJumpPower = true
            player.Character.Humanoid.JumpPower = Value
        end
   end,
})

TabRuch:CreateToggle({
   Name = "🚀 Nieskończony Skok (Spacja)", CurrentValue = false, Flag = "InfJump",
   Callback = function(Value) InfJump = Value end,
})
UserInputService.JumpRequest:Connect(function()
    if InfJump and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

TabRuch:CreateToggle({
   Name = "👻 Przenikanie przez ściany (NoClip)", CurrentValue = false, Flag = "Noclip",
   Callback = function(Value) Noclip = Value end,
})
RunService.Stepped:Connect(function()
    if Noclip and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- ================= ZAKŁADKA 4: 🌍 ŚWIAT =================
local TabSwiat = Window:CreateTab("Świat / Inne", 4483362458)

TabSwiat:CreateButton({
   Name = "🗑️ Usuń Tekstury (MEGA FPS BOOST)",
   Callback = function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end
            if v:IsA("Texture") or v:IsA("Decal") then v:Destroy() end
        end
        Rayfield:Notify({Title = "FPS Boost", Content = "Tekstury usunięte! Ziemniak wytrzyma.", Duration = 3})
   end,
})

TabSwiat:CreateSlider({
   Name = "🌌 Grawitacja", Range = {0, 196}, Increment = 1, Suffix = "Grav", CurrentValue = 196, Flag = "Gravity",
   Callback = function(Value) workspace.Gravity = Value end,
})

Rayfield:Notify({Title = "planexd_0 Hub", Content = "Załadowano GIGANTYCZNĄ aktualizację!", Duration = 5})
