--[[ 
    XENO GOD HUB | 99 NOCY W LESIE (ULTRA BYPASS)
    Zasilane przez: Rayfield Engine | Obejście FilteringEnabled
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Xeno | TOTAL DOMINATION",
   LoadingTitle = "Włamywanie do silnika gry...",
   LoadingSubtitle = "Omijanie zabezpieczeń serwera...",
   ConfigurationSaving = { Enabled = false }
})

local State = {
    Hitbox = false,
    Fly = false,
    FlySpeed = 200
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ==========================================
-- ZAKŁADKA 1: GOD MODE (SIEKIERA & TP)
-- ==========================================
local GodTab = Window:CreateTab("God Mode", 4483345998)

GodTab:CreateToggle({
   Name = "Siekiera Zabija Wszystko (Hitbox Aura)",
   CurrentValue = false,
   Callback = function(Value) 
       State.Hitbox = Value 
       if not Value then
           -- Reset hitboxów
           for _, v in pairs(workspace:GetDescendants()) do
               if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v ~= LocalPlayer.Character then
                   v.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                   v.HumanoidRootPart.Transparency = 1
               end
           end
       end
   end,
})

GodTab:CreateButton({
   Name = "TP do Ogniska (Nawet poza mapę)",
   Callback = function()
       local Root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
       if Root then
           local fireFound = false
           for _, v in pairs(workspace:GetDescendants()) do
               local name = string.lower(v.Name)
               -- Szuka czegokolwiek, co przypomina ogień/ognisko
               if name:match("fire") or name:match("ognisko") or name:match("camp") or v:IsA("Fire") then
                   local targetPart = v:IsA("BasePart") and v or v.Parent
                   if targetPart and targetPart:IsA("BasePart") then
                       -- Wymuszony CFrame teleport, ignoruje granice mapy
                       Root.CFrame = targetPart.CFrame * CFrame.new(0, 5, 0)
                       fireFound = true
                       Rayfield:Notify({Title = "Teleport", Content = "Wymuszono TP do Ogniska!", Duration = 2})
                       break
                   end
               end
           end
           if not fireFound then
               Rayfield:Notify({Title = "Błąd", Content = "Gra nie wygenerowała jeszcze ogniska.", Duration = 2})
           end
       end
   end,
})

GodTab:CreateButton({
   Name = "Wymuś Wszystkie Itemy (Brutal Magnet)",
   Callback = function()
       local Root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
       if Root then
           local count = 0
           -- Brutalne teleportowanie wszystkiego, co ma fizykę, pod Twoje nogi
           for _, v in pairs(workspace:GetDescendants()) do
               if v:IsA("BasePart") and not v.Anchored and v.Parent ~= LocalPlayer.Character then
                   if v.Name ~= "HumanoidRootPart" and v.Name ~= "Torso" and v.Name ~= "Head" then
                       v.CFrame = Root.CFrame
                       count = count + 1
                   end
               end
           end
           Rayfield:Notify({Title = "Magnet", Content = "Wyrwano " .. count .. " obiektów z silnika!", Duration = 3})
       end
   end,
})

-- ==========================================
-- ZAKŁADKA 2: ENGINE ABUSE (NISZCZYCIEL)
-- ==========================================
local AdminTab = Window:CreateTab("Engine Abuse", 4483362458)

AdminTab:CreateButton({
   Name = "ODPAL WSZYSTKO (Nuke Prompts)",
   Callback = function()
       local fired = 0
       -- Ignoruje czas trzymania E i odpala absolutnie każdą interakcję na mapie
       for _, prompt in pairs(workspace:GetDescendants()) do
           if prompt:IsA("ProximityPrompt") then
               prompt.HoldDuration = 0
               prompt.MaxActivationDistance = 99999
               if fireproximityprompt then
                   fireproximityprompt(prompt, 1)
                   fired = fired + 1
               end
           end
       end
       Rayfield:Notify({Title = "Admin Abuse", Content = "Odpalono " .. fired .. " skryptów serwera na raz!", Duration = 4})
   end,
})

AdminTab:CreateButton({
   Name = "Zlaguj Serwer (Spam RemoteEvents)",
   Callback = function()
       local remotes = 0
       -- Znajduje wszystkie niezabezpieczone pakiety danych i spamuje je do serwera
       for _, event in pairs(game:GetDescendants()) do
           if event:IsA("RemoteEvent") then
               pcall(function()
                   event:FireServer()
                   remotes = remotes + 1
               end)
           end
       end
       Rayfield:Notify({Title = "Crash Attempt", Content = "Wysłano " .. remotes .. " fałszywych pakietów do serwera.", Duration = 3})
   end,
})

-- ==========================================
-- ZAKŁADKA 3: MOVEMENT
-- ==========================================
local MoveTab = Window:CreateTab("Movement", 4483345998)

MoveTab:CreateToggle({
   Name = "GOD FLY (CFrame - Klawisz F)",
   CurrentValue = false,
   Callback = function(Value) 
       State.Fly = Value 
       if not Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
           LocalPlayer.Character.HumanoidRootPart.Anchored = false
       end
   end,
})

MoveTab:CreateSlider({
   Name = "Prędkość Fly",
   Min = 50, Max = 1000, CurrentValue = 200,
   Callback = function(Value) State.FlySpeed = Value end,
})

-- ==========================================
-- GŁÓWNA PĘTLA ENGINE HOOK
-- ==========================================
RunService.RenderStepped:Connect(function(deltaTime)
    local Char = LocalPlayer.Character
    if not Char then return end
    local Root = Char:FindFirstChild("HumanoidRootPart")
    if not Root then return end

    -- 1. HITBOX EXPANDER (Siekiera trafia z każdego miejsca)
    if State.Hitbox then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= Char then
                local eRoot = v:FindFirstChild("HumanoidRootPart")
                if eRoot then
                    -- Rozciąga przeciwnika do gigantycznych rozmiarów (widoczne tylko dla Ciebie)
                    eRoot.Size = Vector3.new(50, 50, 50)
                    eRoot.Transparency = 0.8 -- Lekko przezroczyste, żeby nie zasłaniać ekranu
                    eRoot.CanCollide = false
                end
            end
        end
    end

    -- 2. GOD FLY (Ignoruje logikę gry)
    if State.Fly then
        Root.Anchored = true
        local MoveDir = Vector3.new(0, 0, 0)
        local Look = Camera.CFrame.LookVector
        local Right = Camera.CFrame.RightVector
        
        if UIS:IsKeyDown(Enum.KeyCode.W) then MoveDir = MoveDir + Look end
        if UIS:IsKeyDown(Enum.KeyCode.S) then MoveDir = MoveDir - Look end
        if UIS:IsKeyDown(Enum.KeyCode.A) then MoveDir = MoveDir - Right end
        if UIS:IsKeyDown(Enum.KeyCode.D) then MoveDir = MoveDir + Right end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then MoveDir = MoveDir + Vector3.new(0, 1, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then MoveDir = MoveDir - Vector3.new(0, 1, 0) end
        
        if MoveDir.Magnitude > 0 then MoveDir = MoveDir.Unit end
        Root.CFrame = Root.CFrame + (MoveDir * (State.FlySpeed * deltaTime))
    end
end)

UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.F then
        State.Fly = not State.Fly
        if not State.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.Anchored = false
        end
        Rayfield:Notify({Title = "Fly Status", Content = State.Fly and "Włączone" or "Wyłączone", Duration = 1})
    end
end)
