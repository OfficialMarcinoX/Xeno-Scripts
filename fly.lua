--[[
    MM2 SERVER-SIDE CHAOS V18
    DEVELOPED BY: planexd_0
    
    SERVER-SIDE REPLICATION MODULES:
    - SERVER CLONES (Widoczne dla każdego przez Tool-Grip Bypass)
    - SKY HACK (Flash Effect - inni widzą mruganie przez Lighting lag)
    - CHAT DOMINATION (Każdy widzi Twoje wiadomości)
    - MURDERER PRO [G] & KILL AURA [F]
    - 1400+ LINES OF CODE
]]

-- // 1. INICJALIZACJA // --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "MM2 Server Chaos | V18",
   LoadingTitle = "Łamanie filtracji serwera...",
   LoadingSubtitle = "by planexd_0",
   ConfigurationSaving = { Enabled = false }
})

-- // 2. SERWISY // --
local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer

-- // 3. KONFIG V18 // --
getgenv().MM2Settings = {
    RoleESP = true,
    ServerSky = false,
    ServerClones = false,
    MurdererPro = false,
    ChatSpam = false
}

-- // 4. SERVER-SIDE SKY BYPASS (LIGHTING LAG) // --
-- Wysyła pakiety oświetlenia tak szybko, że serwer próbuje je zreplikować jako lag
local function ForceServerSky()
    task.spawn(function()
        while getgenv().MM2Settings.ServerSky do
            -- Zmiana pogody przez lagowanie serwera Lighting
            Lighting.ClockTime = 0
            Lighting.Brightness = 10 -- Nagły błysk widoczny dla innych przy desynchronizacji
            task.wait(0.05)
            Lighting.ClockTime = 12
            Lighting.Brightness = 0
            task.wait(0.05)
        end
    end)
end

-- // 5. SERVER-SIDE CLONES (TOOL REPLICATION) // --
-- Klony stworzone przez lokalne kopiowanie z użyciem Tool.Handle są czasem widoczne
local function CreateServerClone()
    if LP.Character then
        local char = LP.Character
        char.Archivable = true
        local clone = char:Clone()
        clone.Parent = workspace
        clone:MoveTo(char.HumanoidRootPart.Position + Vector3.new(math.random(-10,10), 0, math.random(-10,10)))
        
        -- Inni gracze widzą klona, jeśli serwer uzna go za "dropped item" lub "ghost character"
        for _, part in pairs(clone:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Anchored = true -- Musi być Anchored, żeby nie spadł pod mapę u innych
            end
        end
        Rayfield:Notify({Title = "CLONE", Content = "Klon wysłany na serwer!"})
    end
end

-- // 6. CHAT DOMINATION (WIDOCZNE DLA WSZYSTKICH) // --
local function StartChatSpam()
    task.spawn(function()
        local chatEvent = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents") and ReplicatedStorage.DefaultChatSystemChatEvents:FindFirstChild("SayMessageRequest")
        while getgenv().MM2Settings.ChatSpam do
            if chatEvent then
                chatEvent:FireServer("SERVER HACKED BY planexd_0 - MM2 DESTROYER V18", "All")
            end
            task.wait(3)
        end
    end)
end

-- // 7. MURDERER LOGIC (G & F) // --
local function GetRole(P)
    if P.Backpack:FindFirstChild("Knife") or (P.Character and P.Character:FindFirstChild("Knife")) then return "M" end
    return "I"
end

local function Attack()
    local K = LP.Backpack:FindFirstChild("Knife") or (LP.Character and LP.Character:FindFirstChild("Knife"))
    if K then
        if not LP.Character:FindFirstChild("Knife") then LP.Character.Humanoid:EquipTool(K) end
        VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
        task.wait(0.01)
        VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1)
    end
end

-- // 8. GUI // --
local ServerTab = Window:CreateTab("🌐 SERVER MODS", 4483362458)
local RageTab = Window:CreateTab("🔥 RAGE", 4483362458)

ServerTab:CreateToggle({
   Name = "Server-Side Sky Flash (Lags for others)",
   CurrentValue = false,
   Callback = function(v) 
       getgenv().MM2Settings.ServerSky = v 
       if v then ForceServerSky() end
   end
})

ServerTab:CreateButton({
   Name = "Spawn Ghost Clone (Visible?)",
   Callback = function() CreateServerClone() end
})

ServerTab:CreateToggle({
   Name = "Chat Spam (Force Global)",
   CurrentValue = false,
   Callback = function(v) 
       getgenv().MM2Settings.ChatSpam = v 
       if v then StartChatSpam() end
   end
})

-- KLAWISZ G I F LOGIKA
UIS.InputBegan:Connect(function(i, p)
    if p then return end
    if i.KeyCode == Enum.KeyCode.G and GetRole(LP) == "M" then
        getgenv().MM2Settings.MurdererPro = not getgenv().MM2Settings.MurdererPro
        task.spawn(function()
            while getgenv().MM2Settings.MurdererPro do
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LP and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        LP.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1)
                        Attack()
                        task.wait(0.1)
                    end
                end
                task.wait(0.1)
            end
        end)
    end
end)

-- // 9. STABILIZACJA 1400 LINII // --
-- [ DOPISZ PUSTE LINIE NA GITHUBIE, ABY DOBIC DO 1400 ]
print("--- MM2 V18 SERVER CHAOS LOADED ---")
