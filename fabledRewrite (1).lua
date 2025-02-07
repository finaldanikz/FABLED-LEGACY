if not game:IsLoaded() then
    game.Loaded:Wait() -- Waits until the game is fully loaded
end

if workspace:FindFirstChild("Lobby Map") then
    wait(6) -- Only wait if in lobby
end

local UILib = loadstring(game:HttpGet('https://raw.githubusercontent.com/StepBroFurious/Script/main/HydraHubUi.lua'))()

local Window = UILib.new("thunderOC", game.Players.LocalPlayer.Name, "thunderOC")


-- Tab's
local AutofarmTab = Window:Category("Autofarm", "http://www.roblox.com/asset/?id=8395747586")

-- Autofarm Buttons
local AutofarmButton = AutofarmTab:Button("Farming", "http://www.roblox.com/asset/?id=8395747586")

-- Autofarm Sections
local AutofarmSection = AutofarmButton:Section("Farming", "Left")
local AutoJoinSection = AutofarmButton:Section("Auto Join", "Right")
local AutoSellSection = AutofarmButton:Section("Auto Sell", "Right")
local AutoInvestSection = AutofarmButton:Section("Auto Invest", "Right")

-- Webhook Tab
local WebhookTab = Window:Category("Webhooks", "http://www.roblox.com/asset/?id=8395747586")
-- Webhook Buttons
local WebhookButton = WebhookTab:Button("Webhook", "http://www.roblox.com/asset/?id=8395747586")
-- Webhook Sections
local WebhookSection = WebhookButton:Section("Webhook", "Left")
local PingRaritiesSection = WebhookButton:Section("Ping Rarities", "Right")

local player = game.Players.LocalPlayer
local HOVER_HEIGHT = 0  -- Initial value
local targetHoverHeight = HOVER_HEIGHT
local HOVER_ADJUSTMENT = 50  -- Default adjustment value for hover height

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local playerName = Players.LocalPlayer.Name
local folderPath = "thunderOC/fabled"
local filePath = folderPath .. "/" .. playerName .. ".json"

-- Add this function to handle saving settings
local function saveSettings(settings)
    if not isfolder(folderPath) then
        makefolder(folderPath)
    end
    
    writefile(filePath, HttpService:JSONEncode(settings))
end

-- Add this function to load settings
local function loadSettings()
    if isfile(filePath) then
        return HttpService:JSONDecode(readfile(filePath))
    end
    
    -- Default values if no save file exists
    return {
        pingCommon = false,
        pingUncommon = false,
        pingRare = false,
        pingEpic = false,
        pingLegendary = false,
        pingHeirloom = false,
        
        webhookUrl = "",
        enableWebhook = false,
        pingUser = false,
        userid = "",
        
        autoFarm = false,
        autoAttack = false,
        autoDodge = false,
        autoSell = false,
        autoInvest = false,
        autoJoin = false,
        
        sellCommon = false,
        sellUncommon = false,
        sellRare = false,
        sellEpic = false,
        sellLegendary = false,
        sellHeirloom = false,
        
        selectDungeon = "Raided Village",
        selectDifficulty = "Normal",
        joinHardest = false,
        autoAdapt = false,
        autoJoinDungeon = false,
        autoStartDungeon = false,
        investmentType = "spell",
        autoInvest = false,
        autoEquip = false,
        autoDodge = false,
        autoSpell = false,
        autoRetry = false,
        autoLeave = false,
        flySpeed = 200,
        autoDodgeHeight = 50,
        defaultHeight = 50,
        autoElementalRaid = false,
        selectedElementalTier = 35,
        autoClaimPlaytime = false,
        selectedDifficulty = "Tempest",
        autoJoinInfiniteTower = false,
        autoJoinGlobalBoss = false,
    }
end


-- Load settings when script starts
local settings = loadSettings()

local dungeonLevels = {
    ["Raided Village"] = {
        ["Normal"] = 1,
        ["Expert"] = 5,
        ["Chaos"] = 10
    },
    ["Sunken Fortress"] = {
        ["Normal"] = 20,
        ["Expert"] = 25,
        ["Chaos"] = 30
    },
    ["Cursed Marshes"] = {
        ["Normal"] = 40,
        ["Expert"] = 45,
        ["Chaos"] = 50
    },
    ["Ragnarök's Descent"] = {
        ["Normal"] = 60,
        ["Expert"] = 65,
        ["Chaos"] = 70
    },
    ["Thundering Peaks"] = {
        ["Normal"] = 80,
        ["Expert"] = 85,
        ["Chaos"] = 90
    },
    ["Fallen Paradise"] = {
        ["Normal"] = 100,
        ["Expert"] = 105,
        ["Chaos"] = 110
    },
    ["Eternal Domain"] = {
        ["Normal"] = 120,
        ["Expert"] = 125,
        ["Chaos"] = 130
    },
    ["Stardust Citadel"] = {
        ["Normal"] = 140,
        ["Expert"] = 145,
        ["Chaos"] = 150
    },
    ["Ethereal Farlands"] = {
        ["Normal"] = 160,
        ["Expert"] = 165,
        ["Chaos"] = 170
    },
    ["Hellbound Sanctum"] = {
        ["Normal"] = 180,
        ["Expert"] = 185,
        ["Chaos"] = 190
    }
}

-- Define the inventory path
local inventoryPath = game:GetService("Players").LocalPlayer.PlayerGui
    :WaitForChild("Inventory")
    :WaitForChild("Inventory")
    :WaitForChild("RightSide")
    :WaitForChild("ScrollingFrame")

PingRaritiesSection:Checkbox({
    Title = "Common",
    Description = "Notify for Common items",
    Default = settings.pingCommon,
}, function(value)
    settings.pingCommon = value
    saveSettings(settings)
end)

PingRaritiesSection:Checkbox({
    Title = "Uncommon",
    Description = "Notify for Uncommon items",
    Default = settings.pingUncommon,
}, function(value)
    settings.pingUncommon = value
    saveSettings(settings)
end)

PingRaritiesSection:Checkbox({
    Title = "Rare",
    Description = "Notify for Rare items",
    Default = settings.pingRare,
}, function(value)
    settings.pingRare = value
    saveSettings(settings)
end)

PingRaritiesSection:Checkbox({
    Title = "Epic",
    Description = "Notify for Epic items",
    Default = settings.pingEpic,
}, function(value)
    settings.pingEpic = value
    saveSettings(settings)
end)

PingRaritiesSection:Checkbox({
    Title = "Legendary",
    Description = "Notify for Legendary items",
    Default = settings.pingLegendary,
}, function(value)
    settings.pingLegendary = value
    saveSettings(settings)
end)

PingRaritiesSection:Checkbox({
    Title = "Heirloom",
    Description = "Notify for Heirloom items",
    Default = settings.pingHeirloom,
}, function(value)
    settings.pingHeirloom = value
    saveSettings(settings)
end)

local webhookHolder = "";

WebhookSection:Textbox({
    Title = "Webhook URL",
    Description = "Enter Webhook",
    Default = settings.webhookUrl,
}, function(value)
    settings.webhookUrl = value
    saveSettings(settings)
    webhookHolder = value
end)

-- Adding a button to test the webhook
WebhookSection:Button({
    Title = "Test Webhook",
    Description = "Test the Webhook",
    ButtonName = "Test"
}, function()
    print("Testing webhook...")
    if settings.webhookUrl and settings.webhookUrl ~= "" then
        local data = {
            content = "This is a test message from the webhook test button.",
            embeds = {{
                title = "Webhook Test",
                description = "This is a test message to verify the webhook functionality.",
                color = 5814783,  -- Blue color
                footer = {
                    text = "Player: " .. player.Name
                },
                timestamp = DateTime.now():ToIsoDate()
            }}
        }
        
        local success, response = pcall(function()
            return http_request({
                Url = settings.webhookUrl,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = game:GetService("HttpService"):JSONEncode(data)
            })
        end)
        
        if not success then
            print("Failed to send test webhook:", response)
        else
            print("Test webhook sent successfully.")
        end
    else
        print("Webhook URL is not set.")
    end
end)

-- Adding a checkbox to enable/disable webhook
WebhookSection:Checkbox({
    Title = "Enable Webhook",
    Description = "Toggle to enable or disable webhook",
    Default = settings.enableWebhook,
}, function(value)
    settings.enableWebhook = value
    saveSettings(settings)
    
    if value then
        local seenItems = {}  -- Table to track seen items
        
        task.spawn(function()
            while settings.enableWebhook do
                -- Get all dropped items from PlayerGui
                local player = game:GetService("Players").LocalPlayer
                local playerGui = player.PlayerGui
                local droppedItems = {}
                
                for _, item in pairs(playerGui:GetChildren()) do
                    -- Check if item name matches UUID format and hasn't been seen before
                    if #item.Name == 36 and item.Name:match("^%x+-%x+-%x+-%x+-%x+$") and not seenItems[item.Name] then
                        local itemRarity = item:FindFirstChild("itemRarity")
                        if itemRarity then
                            local rarityValue = string.lower(itemRarity.Value)
                            local itemName = item:FindFirstChild("itemName")
                            local itemType = item:FindFirstChild("itemType")
                            
                            -- Store item details
                            table.insert(droppedItems, {
                                id = item.Name,  -- Store the UUID for tracking
                                rarity = itemRarity.Value,
                                name = itemName and itemName.Value or "Unknown Item",
                                type = itemType and itemType.Value or "Unknown Type"
                            })
                            
                            -- Mark this item as seen
                            seenItems[item.Name] = true
                            
                            -- Send to webhook if URL exists
                            if settings.webhookUrl and settings.webhookUrl ~= "" then
                                -- Check if we should ping for this rarity
                                local shouldPing = (rarityValue == "common" and settings.pingCommon) or
                                                 (rarityValue == "uncommon" and settings.pingUncommon) or
                                                 (rarityValue == "rare" and settings.pingRare) or
                                                 (rarityValue == "epic" and settings.pingEpic) or
                                                 (rarityValue == "legendary" and settings.pingLegendary) or
                                                 (rarityValue == "heirloom" and settings.pingHeirloom)
                                
                                local pingText = ""
                                if shouldPing and settings.userid and settings.userid ~= "" then
                                    print (settings.userid)
                                    pingText = "<@" .. settings.userid .. ">"
                                end
                                
                                -- Create webhook data
                                local data = {
                                    content = pingText,
                                    embeds = {{
                                        title = "New Item Found!",
                                        description = string.format("**Name:** %s\n**Type:** %s\n**Rarity:** %s", 
                                            itemName and itemName.Value or "Unknown Item",
                                            itemType and itemType.Value or "Unknown Type",
                                            itemRarity.Value),
                                        color = 5814783,  -- Blue color
                                        footer = {
                                            text = "Player: " .. player.Name
                                        },
                                        timestamp = DateTime.now():ToIsoDate()
                                    }}
                                }
                                
                                -- Send to webhook
                                local success, response = pcall(function()
                                    return http_request({
                                        Url = settings.webhookUrl,
                                        Method = "POST",
                                        Headers = {
                                            ["Content-Type"] = "application/json"
                                        },
                                        Body = game:GetService("HttpService"):JSONEncode(data)
                                    })
                                end)
                                
                                if not success then
                                    print("Failed to send webhook:", response)
                                end
                            end
                        end
                    end
                end
                
                -- Print only new dropped item details to console
                for _, item in ipairs(droppedItems) do
                    print("New Item Found:")
                    print("Name: " .. item.name)
                    print("Type: " .. item.type)
                    print("Rarity: " .. item.rarity)
                    print("ID: " .. item.id)
                    print("----------")
                end
                
                task.wait(5) -- Wait 5 seconds before next check
            end
        end)
    end
end)


WebhookSection:Textbox({
    Title = "Discord UserID",
    Description = "Enter your Discord UserID",
    Default = settings.userid,
}, function(value)
    settings.userid = value
    saveSettings(settings)
    print("Discord UserID set to:", value)
    -- Additional code to handle Discord UserID can be added here
end)

-- Target finding functionality
local CURRENT_TARGET = nil

-- Add these constants at the top of your file with other variables

local SPEED = 50
local DEADZONE = 3
local VERTICAL_DEADZONE = 0  -- Adjust this value to change the size of the vertical deadzone

-- Add these variables near the top with other variables
local isAutoFarming = false
local RunService = game:GetService("RunService")
local Noclipping
local Clip = true
local isAutoAttacking = false  -- Add this at the top with other variables

-- Add this variable at the top with other variables
local isAutoSpellEnabled = false

-- Add this variable at the top with other variables
local hasAutoEquipped = false  -- Track if Auto Equip has been run

-- Add these functions before the AutofarmSection checkbox
local function startNoclip()
    Clip = false
    Noclipping = RunService.Stepped:Connect(function()
        if Clip == false and player.Character then
            for _, child in ipairs(player.Character:GetDescendants()) do
                if child:IsA("BasePart") and child.CanCollide == true then
                    child.CanCollide = false
                end
            end
        end
    end)
end

local function stopNoclip()
    if Noclipping then
        Noclipping:Disconnect()
    end
    Clip = true
end

local SAFE_SPOTS = {}

-- Check if DungeonSettings and SessionName exist
if workspace:FindFirstChild("DungeonSettings") and workspace.DungeonSettings:FindFirstChild("SessionName") then
    if workspace.DungeonSettings.SessionName.Value == "Cursed Domain" then
        SAFE_SPOTS = {
            Vector3.new(-269, 37, -1444),  -- Example position 1
            Vector3.new(-2492, 150, -2635) -- Example position 2
        }
    elseif workspace.DungeonSettings.SessionName.Value == "Eternal Domain" then
        SAFE_SPOTS = {
            Vector3.new(-823, 211, 218),  -- Safe spot for Eternal Domain
            Vector3.new(-2389, 239, -263)
        }
    elseif workspace.DungeonSettings.SessionName.Value == "Stardust Citadel" then
        SAFE_SPOTS = {
            Vector3.new(21, 88, -713),
            Vector3.new(1304, 134, -1498)  -- Safe spot for Stardust Citadel
        }
    elseif workspace.DungeonSettings.SessionName.Value == "Ethereal Farlands" then
        SAFE_SPOTS = {
            Vector3.new(371, 175, 576),
            Vector3.new(-76, -58, -391),   -- First safe spot for Ethereal Farlands
            Vector3.new(-436, -424, -2237), -- Second safe spot for Ethereal Farlands
            Vector3.new(-605, -230, -3838)  -- Third safe spot for Ethereal Farlands
        }
    elseif workspace.DungeonSettings.SessionName.Value == "Infinite Tower" then
        SAFE_SPOTS = {
            Vector3.new(-373, 157, 15)  -- Safe spot for Infinite Tower
        }
    end
else
    print("DungeonSettings or SessionName not found in workspace.")
    -- Handle the case where DungeonSettings or SessionName is missing
    SAFE_SPOTS = {}  -- Default to an empty table or handle as needed
end

-- Add a task to print safe spots every second
task.spawn(function()
    while true do
        print("Current Safe Spots:")
        for _, spot in ipairs(SAFE_SPOTS) do
            print(spot)
        end
        task.wait(1)  -- Wait for 1 second before printing again
    end
end)

local currentSafeSpotIndex = 1

local function findTargetEnemy()
    if not isAutoFarming then
        -- Clean up only when auto farming is disabled
        local playerRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if playerRoot then
            if playerRoot:FindFirstChild("BodyVelocity") then
                playerRoot.BodyVelocity:Destroy()
            end
            if playerRoot:FindFirstChild("BodyGyro") then
                playerRoot.BodyGyro:Destroy()
            end
        end
        CURRENT_TARGET = nil
        return nil
    end

    local enemiesFolder = workspace:FindFirstChild("Enemies")
    if not enemiesFolder then return nil end

    local playerRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not playerRoot then return nil end

    -- Create or get BodyVelocity and BodyGyro regardless of target
    local BV = playerRoot:FindFirstChild("BodyVelocity") or Instance.new("BodyVelocity")
    BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    BV.P = 9000
    BV.Parent = playerRoot

    local BG = playerRoot:FindFirstChild("BodyGyro") or Instance.new("BodyGyro")
    BG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    BG.P = 100000
    BG.Parent = playerRoot

    local targetPart = nil

    -- First priority: Check for Powered Statue of Bravery
    local poweredStatueBravery = enemiesFolder:FindFirstChild("Powered Statue of Bravery")
    if poweredStatueBravery then
        targetPart = poweredStatueBravery:FindFirstChild("HumanoidRootPart1") or 
                     poweredStatueBravery:FindFirstChild("HumanoidRootPart0") or 
                     poweredStatueBravery:FindFirstChild("HumanoidRootPart") or
                     poweredStatueBravery:FindFirstChild("HRP") or
                     poweredStatueBravery.PrimaryPart
    end

    -- Second priority: Check for Powered Statue of Fidelity
    if not targetPart then
        local poweredStatueFidelity = enemiesFolder:FindFirstChild("Powered Statue of Fidelity")
        if poweredStatueFidelity then
            targetPart = poweredStatueFidelity:FindFirstChild("HumanoidRootPart1") or 
                         poweredStatueFidelity:FindFirstChild("HumanoidRootPart0") or 
                         poweredStatueFidelity:FindFirstChild("HumanoidRootPart") or
                         poweredStatueFidelity:FindFirstChild("HRP") or
                         poweredStatueFidelity.PrimaryPart
        end
    end

    -- Third priority: Check for Root enemy
    if not targetPart then
        local rootEnemy = enemiesFolder:FindFirstChild("Root")
        if rootEnemy then
            targetPart = rootEnemy:FindFirstChild("HumanoidRootPart1") or 
                         rootEnemy:FindFirstChild("HumanoidRootPart0") or 
                         rootEnemy:FindFirstChild("HumanoidRootPart") or
                         rootEnemy:FindFirstChild("HRP") or
                         rootEnemy.PrimaryPart
        end
    end

    -- Fourth priority: Find closest enemy if no Powered Statues or Root enemy found
    if not targetPart then
        local closestDistance = math.huge
        local bestTarget = nil

        for _, enemy in ipairs(enemiesFolder:GetChildren()) do
            if enemy:IsA("Model") and enemy.Name ~= "Root" and enemy.Name ~= "Powered Statue of Bravery" and enemy.Name ~= "Powered Statue of Fidelity" then
                local enemyRoot = enemy:FindFirstChild("HumanoidRootPart1") or 
                                  enemy:FindFirstChild("HumanoidRootPart0") or 
                                  enemy:FindFirstChild("HumanoidRootPart") or
                                  enemy:FindFirstChild("HRP") or
                                  enemy.PrimaryPart

                if enemyRoot then
                    local distance = (enemyRoot.Position - playerRoot.Position).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        bestTarget = enemyRoot
                    end
                end
            end
        end

        if bestTarget then
            targetLocked = true
            targetPart = bestTarget
        end
    end

    -- Handle hovering logic if target is found
    if targetPart then
        CURRENT_TARGET = targetPart
        
        -- Adjust hover height based on auto-dodge and cooldowns
        if isAutoDodgeEnabled then
            local cooldownE = player:FindFirstChild("cooldownE")
            local cooldownQ = player:FindFirstChild("cooldownQ")
            local cooldownEValue = cooldownE and tonumber(cooldownE.Value) or 0
            local cooldownQValue = cooldownQ and tonumber(cooldownQ.Value) or 0

            -- If either cooldown is active, set target hover height above normal
            if cooldownEValue > .1 and cooldownQValue > .1 then
                targetHoverHeight = HOVER_HEIGHT + AutoDodgeSliderValue
            else
                targetHoverHeight = HOVER_HEIGHT  -- Use the slider-controlled height
            end
        else
            targetHoverHeight = HOVER_HEIGHT  -- Use the slider-controlled height
        end

        -- Calculate hover position using targetHoverHeight
        local hoverPosition = targetPart.Position + Vector3.new(0, targetHoverHeight, 0)
        local distanceToHover = (playerRoot.Position - hoverPosition).Magnitude
        local verticalDistance = math.abs(playerRoot.Position.Y - hoverPosition.Y)

        -- Updated hover logic with damping
        if distanceToHover > DEADZONE then
            local moveVector = (hoverPosition - playerRoot.Position).Unit
            local proximityFactor = math.clamp(distanceToHover / 50, 0.1, 1) -- Scale velocity by proximity
            local smoothedVelocity = moveVector * SPEED * proximityFactor
            
            if verticalDistance <= VERTICAL_DEADZONE then
                smoothedVelocity = Vector3.new(smoothedVelocity.X, 0, smoothedVelocity.Z)
            end
            
            BV.Velocity = smoothedVelocity
        else
            BV.Velocity = Vector3.new(0, 0, 0)
        end

        -- Ensure stable orientation
        BG.CFrame = CFrame.new(playerRoot.Position, playerRoot.Position + Vector3.new(0, -1, 0))
        
        -- If target is no longer valid, release the lock
        if targetPart and (not targetPart.Parent or targetPart.Parent:FindFirstChild("Humanoid") and targetPart.Parent.Humanoid.Health <= 0) then
            targetLocked = false
            targetPart = nil
        end

        return targetPart
    else
        -- Move to the closest safe spot if no target is found
        local closestSafeSpot = nil
        local closestDistance = math.huge

        for _, safeSpot in ipairs(SAFE_SPOTS) do
            local distance = (playerRoot.Position - safeSpot).Magnitude
            if distance < closestDistance then
                closestDistance = distance
                closestSafeSpot = safeSpot
            end
        end

        if closestSafeSpot then
            local hoverPosition = closestSafeSpot
            local distanceToHover = (playerRoot.Position - hoverPosition).Magnitude

            if distanceToHover > DEADZONE then
                local moveVector = (hoverPosition - playerRoot.Position).Unit
                BV.Velocity = moveVector * SPEED
            else
                BV.Velocity = Vector3.new(0, 0, 0)
            end

            BG.CFrame = CFrame.new(playerRoot.Position, playerRoot.Position + Vector3.new(0, -1, 0))
            CURRENT_TARGET = nil
        end

        return nil
    end
end



-- Update the AutofarmSection checkbox
AutofarmSection:Checkbox({
    Title = "Auto Farm",
    Description = "Auto Farm",
    Default = settings.autoFarm,
}, function(value)

    -- Add this near the top with other variables
local portalPriorities = {
    "Portal of Dominion",
    "Portal of Quickfire",
    "Portal of Colossus",
    "Portal of Overkill",
    "Portal of Combination",
    "Portal of Duplication"
}

-- Spawn the portal checker task
task.spawn(function()
        while true do
            -- Wait for Map and ArenaExit to exist
            if not workspace:FindFirstChild("Map") or not workspace.Map:FindFirstChild("ArenaExit") then
                task.wait(1)
                continue
            end

            -- Get all portal planes
            local portalPlanes = {
                workspace.Map.ArenaExit.Plane,
                workspace.Map.ArenaExit["Plane.003"],
                workspace.Map.ArenaExit["Plane.004"]
            }

            -- Check if any priority portal is available
            local targetPortal = nil
            for _, priorityName in ipairs(portalPriorities) do
                for _, plane in ipairs(portalPlanes) do
                    if plane:FindFirstChild("SurfaceGui") and 
                    plane.SurfaceGui:FindFirstChild("Frame") and 
                    plane.SurfaceGui.Frame:FindFirstChild("MainName") and
                    plane.SurfaceGui.Frame.MainName.Text == priorityName then
                        targetPortal = plane
                        break
                    end
                end
                if targetPortal then
                    break
                end
            end

            -- If no priority portal found, use any available portal
            if not targetPortal then
                for _, plane in ipairs(portalPlanes) do
                    if plane:FindFirstChild("TouchInterest") then
                        targetPortal = plane
                        break
                    end
                end
            end

            -- Fire TouchInterest if portal found
            if targetPortal and targetPortal:FindFirstChild("TouchInterest") then
                local portalName = targetPortal.SurfaceGui and 
                                targetPortal.SurfaceGui.Frame and 
                                targetPortal.SurfaceGui.Frame.MainName and
                                targetPortal.SurfaceGui.Frame.MainName.Text or "Unknown Portal"
                
                print("Found portal:", portalName)
                firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, targetPortal, 0)
                task.wait(0.1)
                firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, targetPortal, 1)
            end

            task.wait(0.5) -- Check every half second
        end
    end)

    -- Spawn the portal checker task

    print("Auto Farm toggled:", value)
    isAutoFarming = value
    settings.autoFarm = value
    saveSettings(settings)
    
    if value then
        startNoclip()  -- Start noclip when autofarm is enabled
        spawn(function()
            while isAutoFarming do
                -- Simpler check - only run if not in lobby
                if not workspace:FindFirstChild("Lobby Map") then
                    local target = findTargetEnemy()
                    if target then
                        print("Found target:", target:GetFullName())
                    end
                end
                task.wait(0.1)
            end
            
            -- Clean up when auto farm is disabled
            local playerRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if playerRoot then
                if playerRoot:FindFirstChild("BodyVelocity") then
                    playerRoot.BodyVelocity:Destroy()
                end
                if playerRoot:FindFirstChild("BodyGyro") then
                    playerRoot.BodyGyro:Destroy()
                end
            end
            CURRENT_TARGET = nil
        end)
    else
        stopNoclip()  -- Stop noclip when autofarm is disabled
    end
    task.spawn(function()
        while true do
            -- Simulate holding E key down
            game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
            task.wait(3) -- Hold for 3 seconds
            
            -- Release E key
            game:GetService("VirtualInputManager"):SendKeyEvent(false, "E", false, game)
            task.wait(0.1) -- Small delay before next cycle
        end
    end)
end)

-- Move the Auto Attack checkbox under the Auto Farm section
AutofarmSection:Checkbox({
    Title = "Auto Attack",
    Description = "Automatic attacking of enemies",
    Default = settings.autoAttack,
}, function(value)
    print("Auto Attack toggled:", value)
    isAutoAttacking = value  -- Update our tracking variable
    settings.autoAttack = value  -- Update settings table
    saveSettings(settings)  -- Save to file
    
    if value then
        task.spawn(function()
            while isAutoAttacking do
                game:GetService("ReplicatedStorage"):WaitForChild("Bolt"):FireServer()
                task.wait(0.2)
            end
        end)
    end
end)

AutoSellSection:Checkbox({
    Title = "Common",
    Description = "Automatic selling of Common items",
    Default = settings.sellCommon,
}, function(value)
    settings.sellCommon = value
    saveSettings(settings)
end)

local AutoSellUncommonCheckbox
AutoSellSection:Checkbox({
    Title = "Uncommon",
    Description = "Automatic selling of Uncommon items",
    Default = settings.sellUncommon,
}, function(value)
    settings.sellUncommon = value
    saveSettings(settings)
end)

local AutoSellRareCheckbox
AutoSellSection:Checkbox({
    Title = "Rare",
    Description = "Automatic selling of Rare items",
    Default = settings.sellRare,
}, function(value)
    settings.sellRare = value
    saveSettings(settings)
end)

local AutoSellEpicCheckbox
AutoSellSection:Checkbox({
    Title = "Epic",
    Description = "Automatic selling of Epic items",
    Default = settings.sellEpic,
}, function(value)
    settings.sellEpic = value
    saveSettings(settings)
end)

local AutoSellLegendaryCheckbox
AutoSellSection:Checkbox({
    Title = "Legendary",
    Description = "Automatic selling of Legendary items",
    Default = settings.sellLegendary,
}, function(value)
    settings.sellLegendary = value
end)

local AutoSellHeirloomCheckbox
AutoSellSection:Checkbox({
    Title = "Heirloom",
    Description = "Automatic selling of Heirloom items",
    Default = settings.sellHeirloom,
}, function(value)
    settings.sellHeirloom = value
    saveSettings(settings)
end)

local selectedDungeon = "placeholder"
local selectedDifficulty = "placeholder"

AutoJoinSection:Dropdown({
    Title = "Select Dungeon",
    Description = "Auto Join Dungeon",
    Multi = false,
    Options = {
        ["Raided Village"] = false,
        ["Sunken Fortress"] = false,
        ["Cursed Marshes"] = false,
        ["Ragnarök's Descent"] = false,
        ["Thundering Peaks"] = false,
        ["Fallen Paradise"] = false,
        ["Eternal Domain"] = false,
        ["Stardust Citadel"] = false,
        ["Ethereal Farlands"] = false,
        ["Hellbound Sanctum"] = false
    },
    Default = settings.selectDungeon
}, function(options)
    for dungeon, isSelected in pairs(options) do
        if isSelected then
            selectedDungeon = dungeon
            settings.selectDungeon = dungeon
            saveSettings(settings)
            break
        end
    end
end)

AutoJoinSection:Dropdown({
    Title = "Select Difficulty",
    Description = "Auto Join Difficulty",
    Multi = false,
    Options = {
        ["Normal"] = false,
        ["Expert"] = false,
        ["Chaos"] = false
    },
    Default = settings.selectDifficulty
}, function(options)
    for difficulty, isSelected in pairs(options) do
        if isSelected then
            selectedDifficulty = difficulty
            settings.selectDifficulty = difficulty
            saveSettings(settings)
            break
        end
    end
end)





AutoJoinSection:Checkbox({
    Title = "Join Highest Dungeon",
    Description = "Join Hardest Dungeon",
    Default = settings.joinHardest,
}, function(value)
    settings.joinHardest = value
    saveSettings(settings)
    if value then
        task.spawn(function()
            local player = game:GetService("Players").LocalPlayer
            local playerLevel = player.data.level.Value -- Assume 'level' is an IntValue
            local highestDungeon = nil
            local highestDifficulty = nil
            local requiredLevel = 0

            -- Iterate through the dungeons
            for dungeon, difficulties in pairs(dungeonLevels) do
                for difficulty, requiredLevelForDifficulty in pairs(difficulties) do
                    if playerLevel >= requiredLevelForDifficulty then
                        -- Update if this dungeon/difficulty is the hardest achievable
                        if not highestDungeon or dungeonLevels[highestDungeon][highestDifficulty] < requiredLevelForDifficulty then
                            highestDungeon = dungeon
                            highestDifficulty = difficulty
                            requiredLevel = requiredLevelForDifficulty
                        end
                    end
                end
            end

            -- Print results for debugging
            if highestDungeon and highestDifficulty then
                print("Highest Dungeon:", highestDungeon)
                print("Highest Difficulty:", highestDifficulty)
                print("Required Level:", requiredLevel)
                
                -- Prepare arguments for the remote
                local args = {
                    [1] = {
                        ["Map"] = highestDungeon,
                        ["Easter"] = false,
                        ["LevelRequirement"] = requiredLevel,
                        ["Difficulty"] = highestDifficulty,
                        ["Hardcore"] = false,
                        ["NoHit"] = false,
                        ["Private"] = false,
                        ["Calamity"] = false
                    }
                }

                -- Fire the remote to join the selected dungeon
                game:GetService("ReplicatedStorage"):WaitForChild("CreateParty"):InvokeServer(unpack(args))

                -- Delay 2 seconds before starting the dungeon
                wait(5)
                game:GetService("ReplicatedStorage"):WaitForChild("StartDungeon"):FireServer(args)
            else
                print("No dungeons available for your level.")
            end
        end)
    end
end)

local function timeStringToSeconds(timeString)
    local minutes, seconds, fractions = string.match(timeString, "(%d+):(%d+)%.(%d+)")
    if not minutes or not seconds or not fractions then
        error("Invalid time format: " .. tostring(timeString))
    end
    return tonumber(minutes) * 60 + tonumber(seconds) + tonumber(fractions) / 100
end


AutoJoinSection:Checkbox({
    Title = "Auto Adapt Post-Completion",
    Description = "In Beta",
    Default = settings.autoAdapt,
}, function(value)
    settings.autoAdapt = value
    saveSettings(settings)
    local function findPreviousDungeon()
        local player = game:GetService("Players").LocalPlayer
        
        -- Get current dungeon and difficulty from UI
        local currentDungeon = workspace.DungeonSettings.SessionName.Value
        local currentDifficulty = workspace.DungeonSettings.Difficulty.Value
    
        -- Validate inputs
        if not currentDungeon or not currentDifficulty or not dungeonLevels[currentDungeon] then
            print("Invalid dungeon or difficulty")
            return nil
        end
    
        -- Create ordered lists for both dungeons and difficulties
        local orderedDungeons = {
            "Raided Village",
            "Sunken Fortress",
            "Cursed Marshes",
            "Ragnarök's Descent",
            "Thundering Peaks",
            "Fallen Paradise",
            "Eternal Domain",
            "Stardust Citadel",
            "Ethereal Farlands",
            "Hellbound Sanctum"
        }
    
        local orderedDifficulties = {"Normal", "Expert", "Chaos"}
    
        -- Find current indices
        local currentDungeonIndex = 0
        local currentDifficultyIndex = 0
    
        for i, dungeonName in ipairs(orderedDungeons) do
            if dungeonName == currentDungeon then
                currentDungeonIndex = i
                break
            end
        end
    
        for i, difficulty in ipairs(orderedDifficulties) do
            if difficulty == currentDifficulty then
                currentDifficultyIndex = i
                break
            end
        end
    
        -- Only return nil if we're at Raided Village Normal
        if currentDungeon == "Raided Village" and currentDifficulty == "Normal" then
            print("Already at the first dungeon and difficulty")
            return nil
        end
    
        local previousDungeon, previousDifficulty
    
        -- If at Normal difficulty of any dungeon except first
        if currentDifficultyIndex == 1 then
            previousDungeon = orderedDungeons[currentDungeonIndex - 1]
            previousDifficulty = "Chaos"  -- Go to previous dungeon's Chaos
        -- If at Expert or Chaos difficulty
        else
            previousDungeon = currentDungeon
            previousDifficulty = orderedDifficulties[currentDifficultyIndex - 1]
        end
    
        local previousLevel = dungeonLevels[previousDungeon][previousDifficulty]
        
        print(string.format("Previous dungeon: %s (%s) - Level %d", 
            previousDungeon, previousDifficulty, previousLevel))
        
        return previousDungeon, previousDifficulty, previousLevel
    end
    
    local function switchToPreviousDungeon()
        -- Get previous dungeon info
        local previousDungeon, previousDifficulty, previousLevel = findPreviousDungeon()
        
        -- If no previous dungeon found, exit
        if not previousDungeon then
            return
        end
        
        -- Construct arguments with previous dungeon info
        local args = {
            [1] = {
                ["Map"] = previousDungeon,
                ["Halloween"] = false,
                ["LevelRequirement"] = previousLevel,
                ["Difficulty"] = previousDifficulty,
                ["Hardcore"] = false,
                ["NoHit"] = false,
                ["Private"] = false,
                ["Calamity"] = false
            }
        }
        
        -- Fire the remote
        game:GetService("ReplicatedStorage"):WaitForChild("SwitchDungeon"):FireServer(unpack(args))
    end
    

    local function findNextDungeon()
        local player = game:GetService("Players").LocalPlayer
        
        -- Get current dungeon and difficulty from UI
        local currentDungeon = workspace.DungeonSettings.SessionName.Value
        local currentDifficulty = workspace.DungeonSettings.Difficulty.Value
    
        -- Validate inputs
        if not currentDungeon or not currentDifficulty or not dungeonLevels[currentDungeon] then
            print("Invalid dungeon or difficulty")
            return nil
        end
    
        -- Create ordered lists for both dungeons and difficulties
        local orderedDungeons = {
            "Raided Village",
            "Sunken Fortress",
            "Cursed Marshes",
            "Ragnarök's Descent",
            "Thundering Peaks",
            "Fallen Paradise",
            "Eternal Domain",
            "Stardust Citadel",
            "Ethereal Farlands",
            "Hellbound Sanctum"
        }
    
        local orderedDifficulties = {"Normal", "Expert", "Chaos"}
    
        -- Find current indices
        local currentDungeonIndex = 0
        local currentDifficultyIndex = 0
    
        for i, dungeonName in ipairs(orderedDungeons) do
            if dungeonName == currentDungeon then
                currentDungeonIndex = i
                break
            end
        end
    
        for i, difficulty in ipairs(orderedDifficulties) do
            if difficulty == currentDifficulty then
                currentDifficultyIndex = i
                break
            end
        end
    
        -- Return nil if we're at the last dungeon's Chaos difficulty
        if currentDungeon == "Hellbound Sanctum" and currentDifficulty == "Chaos" then
            print("Already at the final dungeon and difficulty")
            return nil
        end
    
        local nextDungeon, nextDifficulty
    
        -- If at Chaos difficulty of any dungeon except last
        if currentDifficultyIndex == 3 then
            nextDungeon = orderedDungeons[currentDungeonIndex + 1]
            nextDifficulty = "Normal"  -- Go to next dungeon's Normal
        -- If at Normal or Expert difficulty
        else
            nextDungeon = currentDungeon
            nextDifficulty = orderedDifficulties[currentDifficultyIndex + 1]
        end
    
        local nextLevel = dungeonLevels[nextDungeon][nextDifficulty]
        
        print(string.format("Next dungeon: %s (%s) - Level %d", 
            nextDungeon, nextDifficulty, nextLevel))
        
        return nextDungeon, nextDifficulty, nextLevel
    end
    
    local function switchToNextDungeon()
        -- Get next dungeon info
        local nextDungeon, nextDifficulty, nextLevel = findNextDungeon()
        
        -- If no next dungeon found, exit
        if not nextDungeon then
            return
        end
        
        -- Construct arguments with next dungeon info
        local args = {
            [1] = {
                ["Map"] = nextDungeon,
                ["Halloween"] = false,
                ["LevelRequirement"] = nextLevel,
                ["Difficulty"] = nextDifficulty,
                ["Hardcore"] = false,
                ["NoHit"] = false,
                ["Private"] = false,
                ["Calamity"] = false
            }
        }
        
        -- Fire the remote
        game:GetService("ReplicatedStorage"):WaitForChild("SwitchDungeon"):FireServer(unpack(args))
    end

  -- Spawn a new task to wait for dungeon status changes
    task.spawn(function()
        if value then -- Only run the logic when the checkbox is enabled
            while true do
                local dungeonFailed = Workspace.dungeonFailed.Value
                local dungeonFinished = Workspace.dungeonFinished.Value

                if dungeonFailed then
                    print(dungeonFailed)
                    findPreviousDungeon()
                    switchToPreviousDungeon()
                    break
                elseif dungeonFinished then
                    print(dungeonFinished)
                    
                    -- Get the completion screen and elapsed time
                    local success, elapsedValue = pcall(function()
                        return game:GetService("Players").LocalPlayer.PlayerGui
                            :WaitForChild("CompletionScreen", 10)
                            :WaitForChild("CompletionBorder", 10)
                            :WaitForChild("CompletionMain", 10)
                            :WaitForChild("ElapsedValue", 10).Text
                    end)

                    print (elapsedValue)
                
                    if success and elapsedValue then
                        local elapsedTime = timeStringToSeconds(elapsedValue)
                        local timeLimit = 255 
                        local timeOver = elapsedTime - timeLimit
                
                        -- Only proceed to next dungeon if we're within the time limit
                        if timeOver <= 0 then
                            findNextDungeon()
                            switchToNextDungeon()
                        else
                            print("Time limit exceeded by " .. timeOver .. " seconds. Staying in current dungeon.")
                        end
                    else
                        print("Could not get elapsed time value")
                        -- If we can't get the time, don't proceed to next dungeon
                    end
                    
                    break
                end

                task.wait(0.1) -- Small delay to avoid busy waiting
            end
        end
    end)
end)




AutoJoinSection:Checkbox({
    Title = "Auto Join",
    Description = "Automatically join dungeons",
    Default = settings.autoJoinDungeon,
}, function(value)
    settings.autoJoinDungeon = value
    saveSettings(settings)
    print("Auto Join toggled:", value)
    print(selectedDungeon)
    print(selectedDifficulty)
    
    if value then
        task.spawn(function()
            while value do
                -- Get the actual level requirement from the table
                local requiredLevel = dungeonLevels[selectedDungeon] and dungeonLevels[selectedDungeon][selectedDifficulty] or 0
                
                -- Prepare arguments for the remote with correct format
                local args = {
                    [1] = {
                        ["Map"] = selectedDungeon,
                        ["Easter"] = false,
                        ["LevelRequirement"] = requiredLevel,
                        ["Difficulty"] = selectedDifficulty,
                        ["Hardcore"] = false,
                        ["NoHit"] = false,
                        ["Private"] = false,
                        ["Calamity"] = false
                    }
                }
                
                -- Use InvokeServer to create party/join dungeon
                game:GetService("ReplicatedStorage"):WaitForChild("CreateParty"):InvokeServer(unpack(args))
                wait (5)
                game:GetService("ReplicatedStorage"):WaitForChild("StartDungeon"):FireServer()

                
                -- Wait for dungeon to load
                task.wait(5)
                
                -- Wait before next check
                task.wait(1)
            end
        end)
    end
end)

local elementalRaidTiers = {
    [15] = "One",
    [35] = "Two",
    [55] = "Three",
    [75] = "Four",
    [95] = "Five",
    [115] = "Six",
    [135] = "Seven",
    [155] = "Eight",
    [175] = "Nine",
    [195] = "Ten"
}



AutoJoinSection:Dropdown({
    Title = "Select Elemental Raid Tier",
    Description = "Elemental Raids",
    Multi = false,
    Options = {
        ["Level 15+"] = false,
        ["Level 35+"] = false,
        ["Level 55+"] = false,
        ["Level 75+"] = false,
        ["Level 95+"] = false,
        ["Level 115+"] = false,
        ["Level 135+"] = false,
        ["Level 155+"] = false,
        ["Level 175+"] = false,
        ["Level 195+"] = false
    },
    Default = "Level " .. tostring(settings.selectedElementalTier) .. "+"  -- Ensure default is formatted
}, function(options)
    for tier, isSelected in pairs(options) do
        if isSelected then
            selectedElementalTier = tonumber(tier:match("%d+"))  -- Extract number from string
            settings.selectedElementalTier = selectedElementalTier  -- Update settings
            saveSettings(settings)  -- Save settings
            break
        end
    end
end)

AutoJoinSection:Checkbox({
    Title = "Auto Elemental Raids",
    Description = "Automatically join Elemental Raids",
    Default = settings.autoElementalRaid,
}, function(value)
    settings.autoElementalRaid = value
    saveSettings(settings)
    if value then
        task.spawn(function()
            while value do
                local args = {
                    [1] = {
                        ["Map"] = "Elemental Raids",
                        ["Calamity"] = false,
                        ["LevelRequirement"] = selectedElementalTier,
                        ["Hardcore"] = false,
                        ["NoHit"] = false,
                        ["Difficulty"] = elementalRaidTiers[selectedElementalTier],
                        ["Private"] = false
                    }
                }
                
                game:GetService("ReplicatedStorage"):WaitForChild("CreateParty"):InvokeServer(unpack(args))
                
                -- Wait for some time before the next attempt
                task.wait(5)
            end
        end)
    end
end)

local infiniteTowerDifficulties = {
    ["Destruction"] = 70,
    ["Tempest"] = 90,
    ["Blooming"] = 110,
    ["Eternity"] = 130,
    ["Dimensions"] = 150,
    ["Embers"] = 170
}


AutoJoinSection:Dropdown({
    Title = "Select Infinite Tower Difficulty",
    Description = "Join Infinite Tower",
    Multi = false,
    Options = {
        ["Destruction (Level 70+)"] = false,
        ["Tempest (Level 90+)"] = false,
        ["Blooming (Level 110+)"] = false,
        ["Eternity (Level 130+)"] = false,
        ["Dimensions (Level 150+)"] = false,
        ["Embers (Level 170+)"] = false
    },
    Default = settings.selectedDifficulty .. " (Level " .. infiniteTowerDifficulties[settings.selectedDifficulty] .. "+)",
}, function(options)
    for difficulty, isSelected in pairs(options) do
        if isSelected then
            -- Extract the base difficulty name by removing the level requirement
            local baseDifficulty = difficulty:match("^([%w]+)")
            selectedDifficulty = baseDifficulty
            settings.selectedDifficulty = baseDifficulty
            saveSettings(settings)
            break
        end
    end
end)

AutoJoinSection:Checkbox({
    Title = "Auto Join Infinite Tower",
    Description = "Automatically join Infinite Tower",
    Default = settings.autoJoinInfiniteTower,
}, function(value)
    settings.autoJoinInfiniteTower = value
    saveSettings(settings)
    if value then
        task.spawn(function()
            while settings.autoJoinInfiniteTower do
                local levelRequirement = infiniteTowerDifficulties[selectedDifficulty]
                local args = {
                    [1] = {
                        ["Map"] = "Infinite Tower",
                        ["Calamity"] = false,
                        ["LevelRequirement"] = levelRequirement,
                        ["Private"] = false,
                        ["NoHit"] = false,
                        ["Difficulty"] = selectedDifficulty,
                        ["Hardcore"] = false
                    }
                }
                
                print("Joining Infinite Tower with Level Requirement: Level " .. levelRequirement .. "+")
                game:GetService("ReplicatedStorage"):WaitForChild("CreateParty"):InvokeServer(unpack(args))
                
                task.wait(5)  -- Wait before the next attempt
            end
        end)
    end
end)

AutoJoinSection:Checkbox({
    Title = "Auto Join Global Boss",
    Description = "Automatically joins Global",
    Default = settings.autoJoinGlobalBoss,
}, function(value)
    settings.autoJoinGlobalBoss = value
    saveSettings(settings)
    
    if value then
        task.spawn(function()
            local TeleportService = game:GetService("TeleportService")
            local Players = game:GetService("Players")
            local PlaceId = 14928194914
            local LobbyPlaceId = 11872917490  -- Added lobby place ID

            local function isWithinTimeRange()
                local currentTime = os.time()
                local utcTime = os.date("!*t", currentTime)
                local hours = utcTime.hour
                local minutes = utcTime.min
                
                if hours % 3 == 0 then
                    local totalMinutes = hours * 60 + minutes
                    local startMinutes = hours * 60
                    local endMinutes = hours * 60 + 3
                    
                    print("Current UTC time:", string.format("%02d:%02d", hours, minutes))
                    return totalMinutes >= startMinutes and totalMinutes <= endMinutes
                end
                return false
            end

            -- Main loop - only runs while checkbox is enabled
            while task.wait(1) and settings.autoJoinGlobalBoss do
                if isWithinTimeRange() then
                    -- Check if we're in Infinite Tower
                    local isInInfiniteTower = workspace:FindFirstChild("DungeonSettings") 
                        and workspace.DungeonSettings:FindFirstChild("SessionName")
                        and workspace.DungeonSettings.SessionName.Value == "Infinite Tower"

                    if isInInfiniteTower then
                        print("In Infinite Tower, returning to lobby first...")
                        TeleportService:Teleport(LobbyPlaceId, Players.LocalPlayer)
                        task.wait(5)  -- Wait for teleport to complete
                    elseif game.PlaceId ~= PlaceId then
                        print("Time is within range (Global Boss time). Attempting teleport...")
                        local success, error = pcall(function()
                            TeleportService:Teleport(PlaceId, Players.LocalPlayer)
                        end)
                        
                        if not success then
                            print("Teleport failed:", error)
                        end
                    end
                end
            end
        end)
    end
end)

AutoJoinSection:Checkbox({
    Title = "Auto Leave Global Boss",
    Description = "Automatically Leave Global",
    Default = settings.autoLeaveGlobalBoss,
}, function(value)
    settings.autoLeaveGlobalBoss = value
    saveSettings(settings)

    local Players = game:GetService("Players")
    local TeleportService = game:GetService("TeleportService")

    -- Constants
    local TARGET_PLACE_ID = 11872917490
    local WAIT_TIME = 480 -- 8 minutes in seconds

    -- Main auto leave function
    local function checkAndTeleport()
        local dungeonSettings = workspace:FindFirstChild("DungeonSettings")
        
        if dungeonSettings and dungeonSettings:FindFirstChild("SessionName") then
            local sessionName = dungeonSettings.SessionName.Value
            
            if sessionName == "Global Boss" then
                -- Wait 8 minutes
                task.wait(WAIT_TIME)
                
                -- Attempt to teleport
                local success, error = pcall(function()
                    TeleportService:Teleport(TARGET_PLACE_ID, Players.LocalPlayer)
                end)
                
                if not success then
                    warn("Failed to teleport: " .. tostring(error))
                end
            end
        end
    end

    -- Start checking when the script runs
    checkAndTeleport()
end)

hasAutoEquipped = true


-- Update the Auto Sell checkbox to check if Auto Equip is enabled
AutoSellSection:Checkbox({
    Title = "Auto Sell",
    Description = "Equip Best should be ON",
    Default = settings.autoSell,
}, function(value)
    settings.autoSell = value
    saveSettings(settings)
    print("[AutoSell] Auto Sell toggled:", value)
    
    -- Check if Auto Equip is enabled
    if not hasAutoEquipped then
        print("[AutoSell] ERROR: Auto Sell cannot run until Auto Equip has been activated")
        return
    end
    
    if value then
        task.spawn(function()
            startAutoSellProcess()
        end)
    end
end)

-- Function to start the auto-sell process
local function startAutoSellProcess()
    print("[AutoSell] Starting auto-sell process...")
    
    task.spawn(function()
        -- Get inventory frame
        local inventoryFrame = game:GetService("Players").LocalPlayer.PlayerGui.Inventory.Inventory.RightSide.ScrollingFrame
        print("[AutoSell] Found inventory frame:", inventoryFrame.Name)
        
        local args = {
            [1] = {
                ["armors"] = {},
                ["rings"] = {},
                ["helmets"] = {},
                ["legs"] = {},
                ["spells"] = {},
                ["sigils"] = {},
                ["weapons"] = {}
            }
        }
        
        print("[AutoSell] Initialized sell arguments with empty categories")
        print("[AutoSell] Starting inventory scan...")
        
        local itemCount = 0
        for _, item in ipairs(inventoryFrame:GetChildren()) do
            itemCount = itemCount + 1
            print(string.format("[AutoSell] Checking item %d: %s", itemCount, item.Name))
            
            if item:FindFirstChild("itemStats") then
                local guid = item.itemStats.GUID.Value
                local rarity = item.itemStats.itemRarity.Value
                local itemType = item.itemStats.itemType.Value
                
                print(string.format("[AutoSell] Item details - GUID: %s, Rarity: %s, Type: %s", 
                    guid, rarity, itemType))
                
                -- Debug checkbox states
                print(string.format("[AutoSell] Checkbox states for %s items: %s", 
                    rarity,
                    tostring((rarity == "common" and settings.sellCommon) or
                    (rarity == "uncommon" and settings.sellUncommon) or
                    (rarity == "rare" and settings.sellRare) or
                    (rarity == "epic" and settings.sellEpic) or
                    (rarity == "legendary" and settings.sellLegendary) or
                    (rarity == "heirloom" and settings.sellHeirloom) or
                    false)))  -- Default false in case none match

                -- Check rarity against settings
                if (rarity == "common" and settings.sellCommon) or
                   (rarity == "uncommon" and settings.sellUncommon) or
                   (rarity == "rare" and settings.sellRare) or
                   (rarity == "epic" and settings.sellEpic) or
                   (rarity == "legendary" and settings.sellLegendary) or
                   (rarity == "heirloom" and settings.sellHeirloom) then
                    
                    print(string.format("[AutoSell] Adding %s %s (GUID: %s) to sell list", 
                        rarity, itemType, guid))
                    table.insert(args[1][itemType], guid)
                    
                    -- Print current count for this item type
                    print(string.format("[AutoSell] Current count for %s: %d", 
                        itemType, #args[1][itemType]))
                end
            else
                print(string.format("[AutoSell] WARNING: Item %s does not have itemStats", item.Name))
            end
        end
        
        -- Print final sell arguments
        print("[AutoSell] Final sell arguments:")
        for category, items in pairs(args[1]) do
            print(string.format("[AutoSell] %s: %d items", category, #items))
        end
        
        -- Attempt to sell items
        print("[AutoSell] Attempting to sell items...")
        
        local sellItems = game:GetService("ReplicatedStorage"):FindFirstChild("sellItems")
        if not sellItems then
            print("[AutoSell] sellItems RemoteFunction not found. AutoSell is unavailable in this context.")
            return
        end

        local success, result = pcall(function()
            return sellItems:InvokeServer(unpack(args))
        end)

        if success then
            print("[AutoSell] Items successfully sold")
        else
            print("[AutoSell] ERROR selling items:", result)
        end
    end)
end

-- Run the auto-sell process if the setting is enabled at startup
if settings.autoSell then
    startAutoSellProcess()
end






AutofarmSection:Checkbox({
    Title = "Auto Start",
    Description = "Automatic starting of dungeons",
    Default = settings.autoStartDungeon,
}, function(value)
    settings.autoStartDungeon = value
    saveSettings(settings)
    print("Auto Start toggled:", value)
    
    if value then
        task.spawn(function()
            while value do
                game:GetService("ReplicatedStorage"):WaitForChild("StartDungeon"):FireServer()
                task.wait(1)
            end
        end)
    end
end)

-- Variables to track auto invest state
local isAutoInvesting = false
local selectedInvestType = "Physical"

AutoInvestSection:Dropdown({
    Title = "Investment Type",
    Description = "Choose between Physical or Spell investment",
    Multi = false,
    Options = {
        ["Physical"] = false,
        ["Spell"] = false
    },
    Default = settings.investmentType
}, function(options)
    for option, state in pairs(options) do
        if state then
            selectedInvestType = option
            settings.investmentType = option
            saveSettings(settings)
        end
    end
end)

AutoInvestSection:Checkbox({
    Title = "Auto Invest",
    Description = "Automatic investment of skill points",
    Default = settings.autoInvest,
}, function(value)
    settings.autoInvest = value
    saveSettings(settings)
    print("Auto Invest toggled:", value)
    isAutoInvesting = value
    
    if value then
        task.spawn(function()
            while isAutoInvesting do
                local args = {
                    [1] = selectedInvestType:lower(),
                    [2] = 1
                }
                game:GetService("ReplicatedStorage"):WaitForChild("addSkillPoints"):FireServer(unpack(args))
                task.wait(.2)
            end
        end)
    end
end)

-- Update the Auto Equip checkbox to set the tracking variable
AutofarmSection:Checkbox({
    Title = "Auto Equip",
    Description = "Automatic equipping of the best items",
    Default = settings.autoEquip,
}, function(value)
    settings.autoEquip = value
    saveSettings(settings)
    print("Auto Equip toggled:", value)
    
    if value then
        -- Initial equip when turned on
        game:GetService("ReplicatedStorage"):WaitForChild("EquipBest"):FireServer()
        hasAutoEquipped = true  -- Set to true when Auto Equip is activated
        
        -- Start monitoring dungeon completion
        task.spawn(function()
            while value do
                if workspace.dungeonFinished.Value then
                    task.wait(5) -- Wait 5 seconds after dungeon completion
                    if value then -- Check if still enabled
                        game:GetService("ReplicatedStorage"):WaitForChild("EquipBest"):FireServer()
                    end
                end
                task.wait(0.1)
            end
        end)
    end
end)

-- Add this function to check cooldowns
local function checkCooldowns()
    while isAutoDodgeEnabled do  -- Use a tracking variable for Auto Dodge
        local cooldownE = player:FindFirstChild("cooldownE")
        local cooldownQ = player:FindFirstChild("cooldownQ")
        
        -- Convert cooldowns to numbers with error handling
        local cooldownEValue = cooldownE and tonumber(cooldownE.Value) or 0
        local cooldownQValue = cooldownQ and tonumber(cooldownQ.Value) or 0
      
        task.wait(.03)  -- Check every 0.1 seconds
    end
end

-- Update the Auto Dodge checkbox to start checking cooldowns
AutofarmSection:Checkbox({
    Title = "Auto Dodge",
    Description = "Automatic dodging of attacks",
    Default = settings.autoDodge,
}, function(value)
    settings.autoDodge = value
    saveSettings(settings)
    print("Auto Dodge toggled:", value)
    isAutoDodgeEnabled = value  -- Track the state
    
    if value then
        task.spawn(checkCooldowns)  -- Start checking cooldowns when enabled
    end
end)

AutofarmSection:Checkbox({
    Title = "Auto Spell",
    Description = "Automatic casting of spells",
    Default = settings.autoSpell,
}, function(value)
    settings.autoSpell = value
    saveSettings(settings)
    print("Auto Spell toggled:", value)
    isAutoSpellEnabled = value  -- Track the state
    
    if value then
        task.spawn(function()
            while isAutoSpellEnabled do  -- Use tracking variable instead of 'value'
                -- Only cast spells if we have a target and are near our hover position
                if CURRENT_TARGET and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local playerRoot = player.Character.HumanoidRootPart
                    local targetPos = CURRENT_TARGET.Position
                    local idealHeight = targetPos.Y + HOVER_HEIGHT
                    local heightDifference = math.abs(playerRoot.Position.Y - idealHeight)
                    
                    -- Only cast if within 10 studs of ideal hover height
                    if heightDifference <= 10 then
                        -- Cast all spells simultaneously
                        local spells = {"Q", "E", "R"}
                        for _, spell in ipairs(spells) do
                            local args = {
                                [1] = spell
                            }
                            game:GetService("ReplicatedStorage"):WaitForChild("useSpell"):FireServer(unpack(args))
                        end
                    end
                end
                task.wait(0.2)
            end
        end)
    end
end)

AutofarmSection:Checkbox({
    Title = "Auto Claim Playtime",
    Description = "Claims All PT Rewards",
    Default = settings.autoClaimPlaytime,
}, function(value)
    settings.autoClaimPlaytime = value  -- Update the setting based on checkbox state
    saveSettings(settings)  -- Save the updated settings

    if value then
        task.spawn(function()
            for i = 1, 12 do
                local args = { [1] = i }
                game:GetService("ReplicatedStorage"):WaitForChild("ClaimPlaytimeReward"):InvokeServer(unpack(args))
                task.wait(0.3)  -- Add a small delay between claims to prevent server overload
            end
            print("All playtime rewards claimed.")
        end)
    end
end)

AutofarmSection:Checkbox({
    Title = "Auto Retry",
    Description = "Retries",
    Default = settings.autoRetry,
}, function(value)
    settings.autoRetry = value
    saveSettings(settings)
    if value then
        -- Wait for workspace.dungeonFinished to be true
        while not workspace.dungeonFinished do
            wait(0.1)  -- Check every 0.1 seconds
        end

        -- Once dungeonFinished is true, wait for 1 second before firing voteRemote
        wait(1)

        -- Fire the voteRemote
        local args = {
            [1] = "repeat"
        }

        game:GetService("ReplicatedStorage"):WaitForChild("voteRemote"):FireServer(unpack(args))
    end
end)

AutofarmSection:Checkbox({
    Title = "Auto Leave",
    Description = "Leaves",
    Default = settings.autoLeave,
}, function(value)
    settings.autoLeave = value
    saveSettings(settings)
    local TeleportService = game:GetService("TeleportService")
    local PlaceID = 11872917490
    local dungeonFinished = Workspace:WaitForChild("dungeonFinished")
    local dungeonFailed = Workspace:WaitForChild("dungeonFailed")
    
    -- Spawn a new task to monitor both dungeonFinished and dungeonFailed
    task.spawn(function()
        dungeonFinished.Changed:Connect(function()
            if dungeonFinished.Value == true then
                TeleportService:Teleport(PlaceID, game.Players.LocalPlayer)
            end
        end)
        
        dungeonFailed.Changed:Connect(function()
            if dungeonFailed.Value == true then
                TeleportService:Teleport(PlaceID, game.Players.LocalPlayer)
            end
        end)
    end)
end)

AutofarmSection:Checkbox({
    Title = "Leave @ Max Inventory",
    Description = "Leaves when Inventory is full",
    Default = settings.autoLeaveINV,
}, function(value)
    settings.autoLeaveINV = value
    saveSettings(settings)
    
    local TeleportService = game:GetService("TeleportService")
    local PlaceID = 11872917490
    local inventoryFrame = game:GetService("Players").LocalPlayer.PlayerGui.Inventory.Inventory.RightSide.ScrollingFrame

    -- Function to check inventory size and teleport if necessary
    local function checkInventory()
        local itemCount = #inventoryFrame:GetChildren()
        print("Current inventory item count:", itemCount)  -- Print the number of items
        -- Only teleport if the current place ID is not the target place ID
        if itemCount >= 285 and game.PlaceId ~= PlaceID then
            TeleportService:Teleport(PlaceID, game.Players.LocalPlayer)
        end
    end

    -- Continuously check inventory size if the feature is enabled
    if value then
        task.spawn(function()
            while settings.autoLeaveINV do
                checkInventory()
                task.wait(1)  -- Check every second
            end
        end)
    end
end)






AutofarmSection:Slider({
    Title = "Fly Speed",
    Description = "Speed of Flight.",
    Min = 0,
    Max = 300,
    Default = settings.flySpeed,
}, function(value)
    SPEED = value
    settings.flySpeed = value
    saveSettings(settings)
end)


AutofarmSection:Slider({
    Title = "Auto Dodge Height",
    Description = "Auto Dodge Height",
    Min = 0,
    Max = 100,
    Default = settings.autoDodgeHeight,
}, function(value)
    HOVER_ADJUSTMENT = value
    AutoDodgeSliderValue = value
    settings.autoDodgeHeight = value
    saveSettings(settings)
end)

-- Update the target hover height calculation
targetHoverHeight = HOVER_HEIGHT + HOVER_ADJUSTMENT


local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local folderPath = "thunderOC"
local playerName = Players.LocalPlayer.Name
local filePath = folderPath .. "/" .. playerName .. ".json"  -- Save as JSON file

-- Create the slider for Hover Height
AutofarmSection:Slider({
    Title = "Hover Height",
    Description = "Default Height",
    Min = 0,
    Max = 100,
    Default = settings.defaultHeight,
}, function(value)
    HOVER_HEIGHT = value
    settings.defaultHeight = value
    saveSettings(settings)
end)






