-- Pobranie biblioteki GUI (Tego Ci brakowało!)
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Xeno Fly Menu", HidePremium = false, SaveConfig = true, ConfigFolder = "XenoConfig"})

-- Główne zmienne (Tego też brakowało!)
local Flying = false
local Speed = 50
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local bv

-- Funkcja latania
local function toggleFly()
    local character = player.Character
    local root = character:FindFirstChild("HumanoidRootPart")
    
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

-- Zakładka w Menu
local Tab = Window:MakeTab({
	Name = "Główne",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Tab:AddToggle({
	Name = "Latanie (Klawisz F)",
	Default = false,
	Callback = function(Value)
		Flying = Value
		toggleFly()
	end    
})

Tab:AddSlider({
	Name = "Prędkość",
	Min = 10,
	Max = 300,
	Default = 50,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "Szybkość",
	Callback = function(Value)
		Speed = Value
	end    
})

-- Obsługa klawisza F
mouse.KeyDown:Connect(function(key)
    if key:lower() == "f" then
        Flying = not Flying
        OrionLib:MakeNotification({Name = "Xeno Fly", Content = "Latanie: " .. (Flying and "WŁĄCZONE" or "WYŁĄCZONE"), Time = 2})
        toggleFly()
    end
end)

-- Odpalenie GUI na ekranie
OrionLib:Init()
