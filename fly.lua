--[[ 
    MARCINOX CUSTOM GUI - XENO EDITION
    Reverse-Engineered Style UI
]]

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local FlyBtn = Instance.new("TextButton")
local AimBtn = Instance.new("TextButton")
local SpeedSlider = Instance.new("TextBox")
local Status = Instance.new("TextLabel")

-- Konfiguracja GUI (Przesuwne i Widoczne)
ScreenGui.Name = "MarcinoX_Hub"
ScreenGui.Parent = game:GetService("CoreGui") -- Ukryte przed skanowaniem gry
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 250)
MainFrame.Active = true
MainFrame.Draggable = true -- Można przesuwać!

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "XENO - MARCINOX"
Title.TextColor3 = Color3.fromRGB(0, 255, 0)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

-- Funkcje Logiczne
local Flying = false
local Aimbot = false
local Speed = 250

-- Przycisk FLY (Klawisz F też działa)
FlyBtn.Parent = MainFrame
FlyBtn.Position = UDim2.new(0.1, 0, 0.2, 0)
FlyBtn.Size = UDim2.new(0.8, 0, 0, 40)
FlyBtn.Text = "FLY (F): OFF"
FlyBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)

-- Funkcja Mega Fly
local function ToggleFly()
    Flying = not Flying
    FlyBtn.Text = Flying and "FLY: ON" or "FLY: OFF"
    FlyBtn.BackgroundColor3 = Flying and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(60, 0, 0)
    
    local Character = game.Players.LocalPlayer.Character
    if Flying and Character then
        local Root = Character:FindFirstChild("HumanoidRootPart")
        local BV = Instance.new("BodyVelocity", Root)
        BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        
        task.spawn(function()
            while Flying do
                local Dir = workspace.CurrentCamera.CFrame.LookVector
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                    BV.Velocity = Dir * Speed
                else
                    BV.Velocity = Vector3.new(0, 0, 0)
                end
                task.wait()
            end
            BV:Destroy()
        end)
    end
end

FlyBtn.MouseButton1Click:Connect(ToggleFly)

-- Obsługa klawisza F (Globalna)
game:GetService("UserInputService").InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.F then ToggleFly() end
end)

-- Przycisk AIMBOT
AimBtn.Parent = MainFrame
AimBtn.Position = UDim2.new(0.1, 0, 0.45, 0)
AimBtn.Size = UDim2.new(0.8, 0, 0, 40)
AimBtn.Text = "AIMBOT: OFF"

AimBtn.MouseButton1Click:Connect(function()
    Aimbot = not Aimbot
    AimBtn.Text = Aimbot and "AIMBOT: ON" or "AIMBOT: OFF"
end)

-- Pętla Aimbota (Rivals)
game:GetService("RunService").RenderStepped:Connect(function()
    if Aimbot then
        local target = nil
        local dist = 1000
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local d = (p.Character.Head.Position - game.Players.LocalPlayer.Character.Head.Position).Magnitude
                if d < dist then
                    dist = d
                    target = p
                end
            end
        end
        if target then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Character.Head.Position)
        end
    end
end)

-- Status
Status.Parent = MainFrame
Status.Position = UDim2.new(0, 0, 0.9, 0)
Status.Size = UDim2.new(1, 0, 0, 20)
Status.Text = "Zasilane przez Reverse System"
Status.TextColor3 = Color3.fromRGB(150, 150, 150)
Status.BackgroundTransparency = 1
