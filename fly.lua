local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Anticheat Tester | Fly",
   LoadingTitle = "Xeno Executor",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = {
      Enabled = false
   }
})

local MainTab = Window:CreateTab("Movement", 4483362458) -- Ikona

local flying = false
local speed = 50
local cur_ws = game.Players.LocalPlayer.Character.Humanoid.WalkSpeed

MainTab:CreateToggle({
   Name = "Enable Fly",
   CurrentValue = false,
   Flag = "FlyToggle",
   Callback = function(Value)
      flying = Value
      local player = game.Players.LocalPlayer
      local character = player.Character or player.CharacterAdded:Wait()
      local hrp = character:WaitForChild("HumanoidRootPart")
      
      if flying then
         local bv = Instance.new("BodyVelocity")
         bv.Name = "XenoFly"
         bv.Velocity = Vector3.new(0,0,0)
         bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
         bv.Parent = hrp
         
         task.spawn(function()
            while flying do
               local cam = workspace.CurrentCamera
               local moveDir = Vector3.new(0,0,0)
               
               if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                  moveDir = moveDir + cam.CFrame.LookVector
               end
               if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                  moveDir = moveDir - cam.CFrame.LookVector
               end
               if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                  moveDir = moveDir - cam.CFrame.RightVector
               end
               if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                  moveDir = moveDir + cam.CFrame.RightVector
               end
               if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                  moveDir = moveDir + Vector3.new(0,1,0)
               end
               if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
                  moveDir = moveDir - Vector3.new(0,1,0)
               end
               
               bv.Velocity = moveDir * speed
               task.wait()
            end
            bv:Destroy()
         end)
      end
   end,
})

MainTab:CreateSlider({
   Name = "Fly Speed",
   Range = {16, 300},
   Increment = 1,
   Suffix = " studs/s",
   CurrentValue = 50,
   Flag = "FlySpeed",
   Callback = function(Value)
      speed = Value
   end,
})

Rayfield:Notify({
   Title = "Gotowe!",
   Content = "Skrypt do testów załadowany pomyślnie.",
   Duration = 5,
   Image = 4483362458,
})
