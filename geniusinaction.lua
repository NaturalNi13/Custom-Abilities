-- Important variables
local player = game.Players.LocalPlayer
local iService = game:GetService("UserInputService")
local rService = game:GetService("RunService")
local rStorage = game:GetService("ReplicatedStorage")
local humanoid
local rootPart

-- Misc variables
local uChar

-- Get the user's selected character
local function getChar()
    local stats = rStorage:FindFirstChild("displayPlayers"):FindFirstChild(player.Name):FindFirstChild("stats")
    if stats then
        uChar = stats:WaitForChild("character").Value
    else
        warn("Player's stats folder is missing!")
    end
end

local function onCharAdded(char)
    humanoid = char:WaitForChild("Humanoid")
    rootPart = char:WaitForChild("HumanoidRootPart")
    
    levitating = false
    uChar = ""
    cooldown = 0
    
    while rootPart.Position.Y < 90 do
        wait(0.2)
    end
    getChar()
    if uChar == "eggman" then
        
        while rootPart.Position.Y > 90 and uChar == "eggman" do
            local turrets = workspace:WaitForChild("game"):WaitForChild("currentMap"):GetChildren()
            local closestTurret = nil
            local shortestDistance = math.huge
            
            for _, turret in ipairs(turrets) do
                local basePart = turret:FindFirstChild("base")
                if basePart and turret.Name == "turret" then
                    local distance = (rootPart.Position - basePart.Position).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestTurret = turret
                    end --if closer
                end -- if turret
            end -- for all turrets

            if closestTurret then
                local args = {
                    [1] = "repairTurret",
                    [2] = closestTurret
                }

                rStorage:WaitForChild("remotes"):WaitForChild("abilities"):FireServer(unpack(args))
            else
                warn("No turret found")
            end
            
            task.wait()
        end -- While above 90
    end -- If eggman
end

player.CharacterAdded:Connect(onCharAdded)
if player.Character then
    onCharAdded(player.Character)
end
