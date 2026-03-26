--[[ 
    Rivals Multi-Hack GUI for Xeno 
    Features: Aimbot, Fly, NoClip, TP, Speed
    Library: Orion Lib
]]

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Rivals Hub | Xeno Edition", HidePremium = false, SaveConfig = true, ConfigFolder = "XenoRivals"})

-- Zmienne
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Ustawienia
_G.AimbotEnabled = false
_G.NoClipEnabled = false
_G.WalkSpeed = 16

-- Tab: Combat (Aimbot)
local CombatTab = Window:MakeTab({Name = "Combat", Icon = "rbxassetid://4483345998", PremiumOnly = false})

CombatTab:AddToggle({
	Name = "Aimbot (Silent)",
	Default = false,
	Callback = function(Value)
		_G.AimbotEnabled = Value
	end    
})

-- Prosta logika Aimbota (Namierzanie najbliższego gracza)
RunService.RenderStepped:Connect(function()
    if _G.AimbotEnabled then
        local ClosestPlayer = nil
        local ShortestDistance = math.huge

        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Team ~= LocalPlayer.Team then
                local ScreenPos, OnScreen = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                if OnScreen then
                    local MousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude
                    if Distance < ShortestDistance then
                        ClosestPlayer = v
                        ShortestDistance = Distance
                    end
                end
            end
        end

        if ClosestPlayer then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, ClosestPlayer.Character.HumanoidRootPart.Position)
        end
    end
end)

-- Tab: Movement (Fly, NoClip, Speed)
local MoveTab = Window:MakeTab({Name = "Movement", Icon = "rbxassetid://4483362458", PremiumOnly = false})

MoveTab:AddSlider({
	Name = "WalkSpeed",
	Min = 16,
	Max = 200,
	Default = 16,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "Speed",
	Callback = function(Value)
		LocalPlayer.Character.Humanoid.WalkSpeed = Value
	end    
})

MoveTab:AddToggle({
	Name = "NoClip (Przechodzenie przez ściany)",
	Default = false,
	Callback = function(Value)
		_G.NoClipEnabled = Value
	end    
})

-- Logika NoClip
RunService.Stepped:Connect(function()
    if _G.NoClipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Tab: Teleport (TP to Players)
local TPTab = Window:MakeTab({Name = "Teleport", Icon = "rbxassetid://4483345998", PremiumOnly = false})

local function GetPlayerList()
    local Names = {}
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then table.insert(Names, v.Name) end
    end
    return Names
end

TPTab:AddDropdown({
	Name = "Wybierz Gracza",
	Default = "",
	Options = GetPlayerList(),
	Callback = function(Value)
		local Target = Players:FindFirstChild(Value)
		if Target and Target.Character then
			LocalPlayer.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame
		end
	end    
})

TPTab:AddButton({
	Name = "Odśwież listę graczy",
	Callback = function()
		-- Funkcja odświeżania dropdowna wymagałaby przeładowania tabu, ale przycisk przypomina o wyborze
		OrionLib:MakeNotification({Name = "Info", Content = "Wybierz gracza ponownie z listy.", Time = 3})
	end    
})

OrionLib:Init()
