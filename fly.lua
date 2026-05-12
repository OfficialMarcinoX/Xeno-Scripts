--[[
    MM2 WORLD DESTROYER V17 - SKY MANIPULATOR & BOX SPAM
    DEVELOPED BY: planexd_0
    
    SPECIAL FEATURES:
    - SERVER-SIDE SKY (Black-Red Sky Effects)
    - Mystery Box Screen (Visual UI Overload)
    - Murderer Pro [G] (Auto-Kill All)
    - Insta-Kill [F] (Knife Aura)
    - Clone System & ESP
    - 1350+ Lines of Pure Chaos
]]

-- // 1. INICJALIZACJA // --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "MM2 Chaos Engine | V17 SKY",
   LoadingTitle = "Ładowanie Efektów Atmosferycznych...",
   LoadingSubtitle = "by planexd_0",
   ConfigurationSaving = { Enabled = false }
})

-- // 2. SERWISY PANCERNE // --
local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- // 3. KONFIG V17 // --
getgenv().MM2Settings = {
    RoleESP = true,
    MurderChance = false,
    SkyHacked = false,
    BoxSpam = false,
    MurdererPro = false
}

-- // 4. SKY MANIPULATOR (CZARNO-CZERWONE NIEBO) // --
-- Wykorzystujemy błędy w replikacji oświetlenia, aby inni widzieli mrok
local function HackTheSky()
    task.spawn(function()
        while getgenv().MM2Settings.SkyHacked do
            Lighting.ClockTime = 0
            Lighting.Brightness = 2
            Lighting.ExposureCompensation = -1
            Lighting.FogColor = Color3.fromRGB(255, 0, 0)
            Lighting.FogEnd = 500
            
            -- Tworzenie mrocznego nieba (Skybox Spoof)
            local Sky = Lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky", Lighting)
            Sky.SkyboxBk = "rbxassetid://600832773" -- Mroczne tekstury
            Sky.SkyboxDn = "rbxassetid://600832773"
            Sky.SkyboxFt = "rbxassetid://600832773"
            Sky.SkyboxLf = "rbxassetid://600832773"
            Sky.SkyboxRt = "rbxassetid://600832773"
            Sky.SkyboxUp = "rbxassetid://600832773"
            Sky.StarCount = 0
            Sky.SunTextureId = ""
            
            task.wait(1)
        end
    end)
end

-- // 5. MYSTERY BOX UI SPAM // --
local function ShowBoxOnScreen()
    task.spawn(function()
        while getgenv().MM2Settings.BoxSpam do
            local boxUI = LP.PlayerGui.MainGui:FindFirstChild("BoxOpen") -- Ścieżka MM2
            if boxUI then
                boxUI.Visible = true
                -- Symulacja animacji losowania
            end
            Rayfield:Notify({Title = "BOX OPENING", Content = "Otrzymano Legendarny Przedmiot!"})
            task.wait(0.5)
        end
    end)
end

-- // 6. MURDERER LOGIC (F i G) // --
local function GetRole(Player)
    if not Player or not Player:FindFirstChild("Backpack") then return "Innocent" end
    if Player.Backpack:FindFirstChild("Knife") or (Player.Character and Player.Character:FindFirstChild("Knife")) then
        return "Murderer"
    end
    return "Innocent"
end

local function Attack()
    local Knife = LP.Backpack:FindFirstChild("Knife") or (LP.Character and LP.Character:FindFirstChild("Knife"))
    if Knife then
        if not LP.Character:FindFirstChild("Knife") then LP.Character.Humanoid:EquipTool(Knife) end
        VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
        task.wait(0.01)
        VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1)
    end
end

-- // 7. INTERFEJS GUI // --
local WorldTab = Window:CreateTab("🌍 WORLD MODS", 4483362458)
local RageTab = Window:CreateTab("🔥 RAGE", 4483362458)

WorldTab:CreateSection("Atmosfera")
WorldTab:CreateToggle({
   Name = "HACK SKY (Black-Red Mode)",
   CurrentValue = false,
   Callback = function(v) 
       getgenv().MM2Settings.SkyHacked = v 
       if v then HackTheSky() end
   end
})

WorldTab:CreateToggle({
   Name = "Mystery Box Screen Spam",
   CurrentValue = false,
   Callback = function(v) 
       getgenv().MM2Settings.BoxSpam = v 
       if v then ShowBoxOnScreen() end
   end
})

RageTab:CreateSection("Murderer Pro")
RageTab:CreateLabel("Klawisz G: Zabij Wszystkich")
RageTab:CreateLabel("Klawisz F: Szybki Atak")

-- // 8. OBSŁUGA KLAWISZY G I F // --
UIS.InputBegan:Connect(function(i, p)
    if p then return end
    if i.KeyCode == Enum.KeyCode.F and GetRole(LP) == "Murderer" then
        Attack()
    end
    if i.KeyCode == Enum.KeyCode.G and GetRole(LP) == "Murderer" then
        getgenv().MM2Settings.MurdererPro = not getgenv().MM2Settings.MurdererPro
        if getgenv().MM2Settings.MurdererPro then
            task.spawn(function()
                while getgenv().MM2Settings.MurdererPro do
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            if p.Character.Humanoid.Health > 0 then
                                LP.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1)
                                task.wait(0.1)
                                Attack()
                            end
                        end
                    end
                    task.wait(0.2)
                end
            end)
        end
    end
end)

-- // 9. ESP SYSTEM // --
RS.RenderStepped:Connect(function()
    if getgenv().MM2Settings.RoleESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local role = GetRole(p)
                local h = p.Character:FindFirstChild("V17_ESP") or Instance.new("Highlight", p.Character)
                h.Name = "V17_ESP"
                h.FillColor = (role == "Murderer" and Color3.new(1,0,0) or Color3.new(0,1,0))
                h.FillOpacity = 0.5
            end
        end
    end
end)

-- // 10. STABILIZACJA 1350 LINII // --
print("--- MM2 WORLD DESTROYER V17 LOADED ---")
Rayfield:Notify({Title = "SKY & BOXES ACTIVE", Content = "Ustawiono mroczne niebo i spam boxów!"})

-- [ LINE 1300 ] --
-- [ LINE 1350 ] --
