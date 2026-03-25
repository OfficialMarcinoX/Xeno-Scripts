-- Ładowanie nowoczesnej biblioteki Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Główne okno Twojego Huba
local Window = Rayfield:CreateWindow({
   Name = "planexd_0 Script Hub",
   LoadingTitle = "Ładowanie skryptów...",
   LoadingSubtitle = "by planexd_0",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "MojeSkrypty",
      FileName = "HubConfig"
   },
   Discord = {
      Enabled = false,
      Invite = "brak",
      RememberJoins = true
   },
   KeySystem = false -- Na razie bez hasła
})

-- Zmienne do latania
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local Flying = false
local Speed = 50
local bv

-- Funkcja latania
local function toggleFly()
    local character = player.Character
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    if Flying then
        bv = Instance.new("BodyVelocity")
        bv.Name = "XenoNapęd"
        bv.Parent = root
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

-- Tworzenie zakładki
local TabUniversal = Window:CreateTab("Universal", 4483362458) -- 4483362458 to ID ikonki globu

-- Dodanie sekcji w zakładce
local Section = TabUniversal:CreateSection("Opcje Poruszania Się")

-- Przycisk (Toggle) włączający latanie
local FlyToggle = TabUniversal:CreateToggle({
   Name = "Latanie (Zastępuje też klawisz F)",
   CurrentValue = false,
   Flag = "FlyToggle",
   Callback = function(Value)
        Flying = Value
        toggleFly()
   end,
})

-- Suwak (Slider) do prędkości
local FlySlider = TabUniversal:CreateSlider({
   Name = "Prędkość latania",
   Range = {10, 300},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 50,
   Flag = "FlySpeed",
   Callback = function(Value)
        Speed = Value
   end,
})

-- Obsługa klawisza F z aktualizacją przycisku w menu
mouse.KeyDown:Connect(function(key)
    if key:lower() == "f" then
        Flying = not Flying
        FlyToggle:Set(Flying) -- To automatycznie przesuwa przycisk w menu!
        toggleFly()
    end
end)

-- Komunikat na start
Rayfield:Notify({
   Title = "Gotowe!",
   Content = "Witaj w planexd_0 Script Hub. Miłej zabawy!",
   Duration = 5,
   Image = 4483362458,
})
