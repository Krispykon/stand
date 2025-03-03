-- Modern Browser-Style UI for Roblox with Animations and Stand
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- State variables
local menuEnabled = false
local espEnabled = false
local invisibilityEnabled = false
local speedEnabled = false
local godModeEnabled = false
local noClipEnabled = false
local standEnabled = false
local standAttacking = false

-- Animation configurations
local MENU_ANIMATION_TIME = 0.3
local BUTTON_ANIMATION_TIME = 0.2
local STAND_ATTACK_COOLDOWN = 1.5

-- Tween configurations
local tweenInfo = TweenInfo.new(
    MENU_ANIMATION_TIME,
    Enum.EasingStyle.Quart,
    Enum.EasingDirection.Out
)

local buttonTweenInfo = TweenInfo.new(
    BUTTON_ANIMATION_TIME,
    Enum.EasingStyle.Quad,
    Enum.EasingDirection.Out
)

-- Create main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrowserMenu"
screenGui.Parent = game.CoreGui

-- Main browser window
local browserFrame = Instance.new("Frame")
browserFrame.Size = UDim2.new(0, 800, 0, 600)
browserFrame.Position = UDim2.new(0.5, -400, 0.5, -300)
browserFrame.BackgroundColor3 = Color3.fromRGB(245, 246, 247)
browserFrame.BorderSizePixel = 0
browserFrame.Visible = false
browserFrame.Active = true
browserFrame.Draggable = true
browserFrame.Parent = screenGui

-- Top bar (like Chrome's title bar)
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.Position = UDim2.new(0, 0, 0, 0)
topBar.BackgroundColor3 = Color3.fromRGB(53, 54, 58)
topBar.BorderSizePixel = 0
topBar.Parent = browserFrame

-- Browser controls bar
local controlsBar = Instance.new("Frame")
controlsBar.Size = UDim2.new(1, 0, 0, 40)
controlsBar.Position = UDim2.new(0, 0, 0, 40)
controlsBar.BackgroundColor3 = Color3.fromRGB(242, 242, 242)
controlsBar.BorderSizePixel = 0
controlsBar.Parent = browserFrame

-- URL bar
local urlBar = Instance.new("TextBox")
urlBar.Size = UDim2.new(0.7, 0, 0, 30)
urlBar.Position = UDim2.new(0.15, 0, 0, 5)
urlBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
urlBar.Text = "konnzzz browser menu"
urlBar.TextColor3 = Color3.fromRGB(0, 0, 0)
urlBar.TextScaled = true
urlBar.BorderSizePixel = 0
urlBar.Parent = controlsBar

-- Content area
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, 0, 1, -80)
contentArea.Position = UDim2.new(0, 0, 0, 80)
contentArea.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
contentArea.BorderSizePixel = 0
contentArea.Parent = browserFrame

-- Enhanced button creation with animations
local function createModernButton(name, yOffset, callback)
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Size = UDim2.new(0.9, 0, 0, 50)
    buttonContainer.Position = UDim2.new(0.05, 0, 0, yOffset)
    buttonContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    buttonContainer.BackgroundTransparency = 0
    buttonContainer.BorderSizePixel = 0
    buttonContainer.Parent = contentArea

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -60, 1, 0)
    button.Position = UDim2.new(0, 0, 0, 0)
    button.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    button.Text = name
    button.TextColor3 = Color3.fromRGB(50, 50, 50)
    button.TextSize = 18
    button.Font = Enum.Font.SourceSansSemibold
    button.BorderSizePixel = 0
    button.Parent = buttonContainer
    
    -- Add hover and click animations
    button.MouseEnter:Connect(function()
        local hoverTween = TweenService:Create(button, buttonTweenInfo, {
            BackgroundColor3 = Color3.fromRGB(230, 230, 230),
            TextColor3 = Color3.fromRGB(0, 0, 0)
        })
        hoverTween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local leaveTween = TweenService:Create(button, buttonTweenInfo, {
            BackgroundColor3 = Color3.fromRGB(240, 240, 240),
            TextColor3 = Color3.fromRGB(50, 50, 50)
        })
        leaveTween:Play()
    end)

    local status = Instance.new("Frame")
    status.Size = UDim2.new(0, 50, 1, 0)
    status.Position = UDim2.new(1, 0, 0, 0)
    status.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
    status.BorderSizePixel = 0
    status.Parent = buttonContainer

    button.MouseButton1Click:Connect(function()
        -- Click animation
        local clickTween = TweenService:Create(button, TweenInfo.new(0.1), {
            Size = UDim2.new(0.98, -60, 0.95, 0)
        })
        clickTween:Play()
        
        callback()
        
        -- Reset size after click
        wait(0.1)
        local resetTween = TweenService:Create(button, TweenInfo.new(0.1), {
            Size = UDim2.new(1, -60, 1, 0)
        })
        resetTween:Play()
        
        -- Status color transition
        local newColor = status.BackgroundColor3 == Color3.fromRGB(239, 68, 68) 
            and Color3.fromRGB(34, 197, 94) 
            or Color3.fromRGB(239, 68, 68)
        
        local statusTween = TweenService:Create(status, buttonTweenInfo, {
            BackgroundColor3 = newColor
        })
        statusTween:Play()
    end)

    return buttonContainer
end

-- Feature Functions
function esp()
    espEnabled = not espEnabled
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            if espEnabled then
                local billboard = Instance.new("BillboardGui", player.Character.Head)
                billboard.Name = "ESP"
                billboard.Size = UDim2.new(2, 0, 2, 0)
                billboard.AlwaysOnTop = true
                local text = Instance.new("TextLabel", billboard)
                text.Size = UDim2.new(1, 0, 1, 0)
                text.Text = player.Name
                text.TextColor3 = Color3.new(1, 0, 0)
                text.BackgroundTransparency = 1
                text.TextScaled = true
            else
                local head = player.Character.Head
                if head:FindFirstChild("ESP") then
                    head.ESP:Destroy()
                end
            end
        end
    end
end

function invisibility()
    invisibilityEnabled = not invisibilityEnabled
    if LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                local transparency = invisibilityEnabled and 1 or 0
                local transparencyTween = TweenService:Create(v, TweenInfo.new(0.5), {
                    Transparency = transparency
                })
                transparencyTween:Play()
                
                if v:IsA("BasePart") then
                    v.CanCollide = not invisibilityEnabled
                end
            end
        end
    end
end

function speed()
    speedEnabled = not speedEnabled
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local humanoid = LocalPlayer.Character.Humanoid
        local targetSpeed = speedEnabled and 100 or 16
        local currentSpeed = humanoid.WalkSpeed
        
        -- Smooth speed transition
        local speedTween = TweenService:Create(humanoid, TweenInfo.new(0.5), {
            WalkSpeed = targetSpeed
        })
        speedTween:Play()
    end
end

function godMode()
    godModeEnabled = not godModeEnabled
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.MaxHealth = godModeEnabled and 10000 or 100
        LocalPlayer.Character.Humanoid.Health = godModeEnabled and 10000 or 100
    end
end

function noClip()
    noClipEnabled = not noClipEnabled
    RunService.Stepped:Connect(function()
        if noClipEnabled and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

function teleportToRandomPlayer()
    local players = Players:GetPlayers()
    if #players > 1 then
        local target
        repeat
            target = players[math.random(1, #players)]
        until target ~= LocalPlayer and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character:SetPrimaryPartCFrame(target.Character.HumanoidRootPart.CFrame)
        end
    end
end

function teleportToMouse()
    local mouse = LocalPlayer:GetMouse()
    if mouse and mouse.Hit and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character:SetPrimaryPartCFrame(mouse.Hit)
    end
end

-- Stand Creation and Management
local function createStand()
    local stand = Instance.new("Model")
    stand.Name = "Stand"
    
    -- Create main body parts
    local torso = Instance.new("Part")
    torso.Size = Vector3.new(2, 2, 1)
    torso.BrickColor = BrickColor.new("Really black")
    torso.Name = "Torso"
    torso.Transparency = 0.2
    torso.CanCollide = false
    torso.Parent = stand
    
    local head = Instance.new("Part")
    head.Size = Vector3.new(1, 1, 1)
    head.BrickColor = BrickColor.new("Really black")
    head.Name = "Head"
    head.Transparency = 0.2
    head.CanCollide = false
    head.Parent = stand
    
    -- Create arms for attacking
    local rightArm = Instance.new("Part")
    rightArm.Size = Vector3.new(1, 2, 1)
    rightArm.BrickColor = BrickColor.new("Really black")
    rightArm.Name = "RightArm"
    rightArm.Transparency = 0.2
    rightArm.CanCollide = false
    rightArm.Parent = stand
    
    local leftArm = rightArm:Clone()
    leftArm.Name = "LeftArm"
    leftArm.Parent = stand
    
    -- Create welds
    local headWeld = Instance.new("Weld")
    headWeld.Part0 = torso
    headWeld.Part1 = head
    headWeld.C0 = CFrame.new(0, 1.5, 0)
    headWeld.Parent = torso
    
    local rightArmWeld = Instance.new("Weld")
    rightArmWeld.Part0 = torso
    rightArmWeld.Part1 = rightArm
    rightArmWeld.C0 = CFrame.new(1.5, 0, 0)
    rightArmWeld.Parent = torso
    
    local leftArmWeld = Instance.new("Weld")
    leftArmWeld.Part0 = torso
    leftArmWeld.Part1 = leftArm
    leftArmWeld.C0 = CFrame.new(-1.5, 0, 0)
    leftArmWeld.Parent = torso
    
    return stand
end

-- Stand attack function
local function standAttack()
    if standAttacking then return end
    standAttacking = true
    
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("Stand") then return end
    
    local stand = character.Stand
    local rightArm = stand:FindFirstChild("RightArm")
    local leftArm = stand:FindFirstChild("LeftArm")
    
    -- Rapid punch animation
    for i = 1, 10 do
        local arm = i % 2 == 0 and rightArm or leftArm
        if arm then
            -- Create punch animation
            local punchTween = TweenService:Create(arm, TweenInfo.new(0.1), {
                CFrame = arm.CFrame * CFrame.new(0, 0, -2)
            })
            punchTween:Play()
            wait(0.05)
            
            -- Reset arm position
            local resetTween = TweenService:Create(arm, TweenInfo.new(0.1), {
                CFrame = arm.CFrame
            })
            resetTween:Play()
            
            -- Check for hits
            local rayOrigin = arm.Position
            local rayDirection = arm.CFrame.LookVector * 4
            local raycastParams = RaycastParams.new()
            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
            raycastParams.FilterDescendantsInstances = {character}
            
            local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
            if raycastResult and raycastResult.Instance then
                local hitPlayer = Players:GetPlayerFromCharacter(raycastResult.Instance.Parent)
                if hitPlayer then
                    local humanoid = hitPlayer.Character:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid.Health = humanoid.Health - 10
                    end
                end
            end
        end
        wait(0.1)
    end
    
    wait(STAND_ATTACK_COOLDOWN)
    standAttacking = false
end

-- Toggle stand function
function toggleStand()
    standEnabled = not standEnabled
    local character = LocalPlayer.Character
    if not character then return end
    
    if standEnabled then
        local stand = createStand()
        stand.Parent = character
        
        -- Position stand behind player
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            stand:SetPrimaryPartCFrame(rootPart.CFrame * CFrame.new(0, 0, 3))
            
            -- Make stand follow player
            local connection = RunService.Heartbeat:Connect(function()
                if not standEnabled or not character:FindFirstChild("Stand") then
                    connection:Disconnect()
                    return
                end
                
                local targetCFrame = rootPart.CFrame * CFrame.new(0, 0, 3)
                stand:SetPrimaryPartCFrame(targetCFrame)
            end)
        end
    else
        local stand = character:FindFirstChild("Stand")
        if stand then
            stand:Destroy()
        end
    end
end

-- Create buttons with proper spacing
local yOffset = 20
local spacing = 60

createModernButton("ESP", yOffset, esp)
createModernButton("Invisibility", yOffset + spacing, invisibility)
createModernButton("Speed", yOffset + spacing * 2, speed)
createModernButton("God Mode", yOffset + spacing * 3, godMode)
createModernButton("No Clip", yOffset + spacing * 4, noClip)
createModernButton("Teleport to Random Player", yOffset + spacing * 5, teleportToRandomPlayer)
createModernButton("Toggle Stand", yOffset + spacing * 6, toggleStand)

-- Enhanced key bindings with stand attack
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.P then
        menuEnabled = not menuEnabled
        
        -- Animate menu appearance/disappearance
        if menuEnabled then
            browserFrame.Position = UDim2.new(0.5, -400, 0, -600)
            browserFrame.Visible = true
            
            local appearTween = TweenService:Create(browserFrame, tweenInfo, {
                Position = UDim2.new(0.5, -400, 0.5, -300)
            })
            appearTween:Play()
        else
            local disappearTween = TweenService:Create(browserFrame, tweenInfo, {
                Position = UDim2.new(0.5, -400, 1, 100)
            })
            disappearTween:Play()
            
            disappearTween.Completed:Connect(function()
                browserFrame.Visible = false
            end)
        end
    elseif input.KeyCode == Enum.KeyCode.U then
        teleportToMouse()
    elseif input.KeyCode == Enum.KeyCode.G and standEnabled then
        standAttack()
    end
end)

print("Enhanced Browser-Style Menu with Stand Loaded")
