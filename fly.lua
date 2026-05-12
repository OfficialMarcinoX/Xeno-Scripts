local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Rivals AC Tester | Xeno",
   LoadingTitle = "Inicjalizacja modułów...",
   LoadingSubtitle = "Testing Environment",
   ConfigurationSaving = {Enabled = false}
})

local MainTab = Window:CreateTab("Combat & Movement", 4483362458)

-- Zmienne pomocnicze
local targetPlayer = nil
local aimbotEnabled = false
local autoShoot = false

-- Funkcja szukania najbliższego gracza
local function getClosestPlayer()
    local closest = nil
    local dist = math.huge
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local magnitude = (v.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude
            if magnitude < dist then
                dist = magnitude
                closest = v
            end
        end
    end
    return closest
end

-- Sekcja AIMBOT & AUTO-SHOOT
MainTab:CreateSection("Combat")

MainTab:CreateToggle({
   Name = "Aimbot + AutoShoot",
   CurrentValue = false,
   Callback = function(Value)
      aimbotEnabled = Value
      task.spawn(function()
         while aimbotEnabled do
            targetPlayer = getClosestPlayer()
            if targetPlayer and targetPlayer.Character then
                -- Celowanie
                workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, targetPlayer.Character.Head.Position)
                -- Auto strzał (wymaga Mouse1 down w Rivals)
                if autoShoot then
                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
                    task.wait(0.05)
                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)
                end
            end
            task.wait()
         end
      end)
   end,
})

-- Sekcja MOVEMENT (Teleport & Fly)
MainTab:CreateSection("Movement")

MainTab:CreateButton({
   Name = "TP to Closest Player (Behind)",
   Callback = function()
      local target = getClosestPlayer()
      if target and target.Character then
          game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
      end
   end,
})

MainTab:CreateToggle({
   Name = "Aggressive Fly",
   CurrentValue = false,
   Callback = function(Value)
      -- Tutaj ładujemy Twój zewnętrzny skrypt Fly z GitHuba, żeby sprawdzić detekcję zewnętrznych modułów
      if Value then
          loadstring(game:HttpGet("https://raw.githubusercontent.com/OfficialMarcinoX/Xeno-Scripts/refs/heads/main/fly.lua"))()
      end
   end,
})

Rayfield:Notify({
   Title = "Tester Ready",
   Content = "Używaj ostrożnie – sprawdzaj logi Anticheata przy TP!",
   Duration = 5
})
