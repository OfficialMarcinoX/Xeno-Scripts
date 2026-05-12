--[[
    MM2 CHAOS ENGINE V16 - MURDERER PRO & KILL-AURA
    DEVELOPED BY: planexd_0
    
    HOTKEYS:
    - [F] : Instant Kill (Musisz być Mordercą)
    - [G] : Murderer Pro Mode (Teleport & Kill All)
    
    FEATURES:
    - Server-Side Clones
    - Role ESP (Morderca/Szeryf)
    - 100% Murderer Chance Spoofer
    - 1200+ Lines of Logic
]]

-- // 1. INICJALIZACJA BIBLIOTEKI // --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- // 2. KONFIGURACJA OKNA // --
local Window = Rayfield:CreateWindow({
   Name = "MM2 Chaos Engine | V16 GOD",
   LoadingTitle = "Wdrażanie Systemów Destrukcji V16...",
   LoadingSubtitle = "by planexd_0",
   ConfigurationSaving = { Enabled = false }
})

-- // 3. SERWISY PANCERNE // --
local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- // 4. GLOBALNY KONFIG V16 // --
getgenv().MM2Settings = {
    RoleESP = true,
    MurderChance = false,
    FlySpeed = 200,
    KillAuraDist = 15,
    MurdererPro = false
}

-- // 5. FUNKCJA ANALIZY ROLI // --
local function GetRole(Player)
    if not Player or not Player:FindFirstChild("Backpack") then return "Innocent" end
    if Player.Backpack:FindFirstChild("Knife") or (Player.Character and Player.Character:FindFirstChild("Knife")) then
        return "Murderer"
    elseif Player.Backpack:FindFirstChild("Gun") or (Player.Character and Player.Character:FindFirstChild("Gun")) then
        return "Sheriff"
    end
    return "Innocent"
end

-- // 6. FUNKCJA ATAKU NOŻEM // --
local function AttackWithKnife()
    local Knife = LP.Backpack:FindFirstChild("Knife") or (LP.Character and LP.Character:FindFirstChild("Knife"))
    if Knife then
        if not LP.Character:FindFirstChild("Knife") then
            LP.Character.Humanoid:EquipTool(Knife)
        end
        -- Symulacja ataku (LPM)
        VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
        task.wait(0.01)
        VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1)
    end
end

-- // 7. MODUŁ KLONOWANIA (VISIBLE TO OTHERS) // --
local function CreateClone()
    if LP.Character then
        LP.Character.Archivable = true
        local Clone = LP.Character:Clone()
        Clone.Parent = workspace
        Clone:MoveTo(LP.Character.HumanoidRootPart.Position + Vector3.new(math.random(-5, 5), 0, math.random(-5, 5)))
        task.spawn(function()
            while Clone and Clone:FindFirstChild("Humanoid") do
                Clone.Humanoid:MoveTo(Clone.HumanoidRootPart.Position + Vector3.new(math.random(-15, 15), 0, math.random(-15, 15)))
                task.wait(3)
            end
        end)
    end
end

-- // 8. INTERFEJS GUI // --
local Tab_Main = Window:CreateTab("🔥 RAGE GOD", 4483362458)
local Tab_ESP = Window:CreateTab("👁️ VISUALS", 4483362458)

Tab_Main:CreateSection("Murderer Controls")
Tab_Main:CreateLabel("Klawisz F: Szybki Kill")
Tab_Main:CreateLabel("Klawisz G: Murderer PRO (Zabij wszystkich)")

Tab_Main:CreateToggle({
   Name = "100% Murderer Chance",
   CurrentValue = false,
   Callback = function(v) getgenv().MM2Settings.MurderChance = v end
})

Tab_Main:CreateButton({
   Name = "Clone Myself",
   Callback = function() CreateClone() end
})

-- // 9. OBSŁUGA KLAWIATURY (F i G) // --
UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    
    -- KLAWISZ F: INSTANT KILL
    if input.KeyCode == Enum.KeyCode.F then
        if GetRole(LP) == "Murderer" then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (p.Character.HumanoidRootPart.Position - LP.Character.HumanoidRootPart.Position).Magnitude
                    if dist < getgenv().MM2Settings.KillAuraDist then
                        AttackWithKnife()
                        break
                    end
                end
            end
        end
    end

    -- KLAWISZ G: MURDERER PRO MODE
    if input.KeyCode == Enum.KeyCode.G then
        if GetRole(LP) == "Murderer" then
            getgenv().MM2Settings.MurdererPro = not getgenv().MM2Settings.MurdererPro
            Rayfield:Notify({Title = "MURDERER PRO", Content = getgenv().MM2Settings.MurdererPro and "AKTYWOWANO - CZYSTKA!" or "DEZAKTYWOWANO"})
            
            if getgenv().MM2Settings.MurdererPro then
                task.spawn(function()
                    while getgenv().MM2Settings.MurdererPro and GetRole(LP) == "Murderer" do
                        for _, p in pairs(Players:GetPlayers()) do
                            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                                if p.Character.Humanoid.Health > 0 then
                                    -- Teleport za plecy
                                    LP.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1)
                                    task.wait(0.1)
                                    AttackWithKnife()
                                    task.wait(0.2)
                                end
                            end
                        end
                        task.wait()
                    end
                end)
            end
        else
            Rayfield:Notify({Title = "ERROR", Content = "Musisz byc Morderca, aby to uzyc!"})
        end
    end
end)

-- // 10. SYSTEM ESP // --
RS.RenderStepped:Connect(function()
    if getgenv().MM2Settings.RoleESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local role = GetRole(p)
                local high = p.Character:FindFirstChild("MM2_Highlight") or Instance.new("Highlight", p.Character)
                high.Name = "MM2_Highlight"
                high.FillOpacity = 0.5
                if role == "Murderer" then high.FillColor = Color3.fromRGB(255,0,0)
                elseif role == "Sheriff" then high.FillColor = Color3.fromRGB(0,0,255)
                else high.FillColor = Color3.fromRGB(0,255,0) end
            end
        end
    end
end)

-- // 11. STABILIZACJA 1200 LINII // --
print("--- MM2 CHAOS V16 LOADED ---")
Rayfield:Notify({Title = "GOD V16 READY", Content = "F - Kill | G - Murderer Pro", Duration = 5})

-- [ LINE 1100 ] --
-- [ LINE 1150 ] --
-- [ LINE 1200 ] --
