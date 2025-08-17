-- // Variables principales
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Coordenadas de la rampa (gracias a tu captura)
local rampCoords = Vector3.new(-2.788259744644165, 42.37252426147461, -252.9100799560547)

-- Flags
getgenv().AutoHammer = false
getgenv().ExpandHitbox = false

-- // Safe Teleport
local function safeTeleport(pos)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char:MoveTo(pos)
    end
end

-- // AutoHammer Loop
local function autoHammer()
    while getgenv().AutoHammer do
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        -- Chequeo de muerte
        if not hum or hum.Health <= 0 then
            repeat task.wait() 
                char = LocalPlayer.Character
                hum = char and char:FindFirstChildOfClass("Humanoid")
            until hum and hum.Health > 0
            safeTeleport(rampCoords)
            task.wait(2) -- esperar en la rampa
        end

        -- Atacar a jugadores
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local targetHRP = player.Character.HumanoidRootPart
                safeTeleport(targetHRP.Position + Vector3.new(0, 3, 0)) -- caer encima
                task.wait(0.25)

                -- Golpe
                local tool = char and char:FindFirstChildOfClass("Tool")
                if tool and tool:FindFirstChild("RemoteEvent") then
                    tool.RemoteEvent:FireServer()
                end

                task.wait(0.4)
            end
        end

        task.wait(0.2)
    end
end

-- // Expand Hitbox
RunService.Heartbeat:Connect(function()
    if getgenv().ExpandHitbox then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = player.Character.HumanoidRootPart
                hrp.Size = Vector3.new(10,10,10)
                hrp.Transparency = 0.7
                hrp.BrickColor = BrickColor.new("Really red")
                hrp.Material = Enum.Material.Neon
                hrp.CanCollide = false
            end
        end
    end
end)

-- // UI Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Hammer Battles - Infinix Cheat Menu",
   LoadingTitle = "Hammer Battles",
   LoadingSubtitle = "by Breinrotggr",
   ConfigurationSaving = {
      Enabled = false
   }
})

-- Tab principal
local MainTab = Window:CreateTab("Main", 4483362458)

-- Toggle AutoHammer
MainTab:CreateToggle({
    Name = "Auto Hammer (TP + Hit)",
    CurrentValue = false,
    Flag = "AutoHammer",
    Callback = function(Value)
        getgenv().AutoHammer = Value
        if Value then
            task.spawn(autoHammer)
        end
    end,
})

-- Toggle Expand Hitbox
MainTab:CreateToggle({
    Name = "Expand Hitbox",
    CurrentValue = false,
    Flag = "ExpandHitbox",
    Callback = function(Value)
        getgenv().ExpandHitbox = Value
    end,
})

-- Créditos
MainTab:CreateParagraph({Title = "Hammer Battles", Content = "Script con AutoHammer + Fix de muerte y ExpandHitbox."})
