--[[
    Xeno Fly Script - Wersja Polska
    Instrukcja: Naciśnij "F", aby latać.
]]

local gracz = game.Players.LocalPlayer
local mysz = gracz:GetMouse()
local postac = gracz.Character or gracz.CharacterAdded:Wait()
local root = postac:WaitForChild("HumanoidRootPart")

local czyLata = false
local predkosc = 70 -- Tutaj możesz zmienić szybkość latania

-- Funkcja powiadomienia (GUI)
local function powiadomienie(tytul, tekst)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = tytul;
        Text = tekst;
        Duration = 5;
    })
end

powiadomienie("Xeno Fly", "Skrypt załadowany! Naciśnij 'F' aby zacząć.")

-- Główna funkcja latania
function przelaczLatanie()
    czyLata = not czyLata
    
    if czyLata then
        -- Tworzymy siłę, która utrzymuje nas w powietrzu
        local bv = Instance.new("BodyVelocity")
        bv.Name = "XenoNapęd"
        bv.Parent = root
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 0, 0)
        
        -- Pętla ruchu
        task.spawn(function()
            while czyLata do
                -- Lata tam, gdzie patrzy Twoja myszka
                bv.Velocity = mysz.Hit.lookVector * predkosc
                task.wait()
            end
            bv:Destroy()
        end)
        print("Latanie: WŁĄCZONE")
    else
        print("Latanie: WYŁĄCZONE")
    end
end

-- Obsługa klawisza F
mysz.KeyDown:Connect(function(klawisz)
    if klawisz:lower() == "f" then
        przelaczLatanie()
    end
end)
