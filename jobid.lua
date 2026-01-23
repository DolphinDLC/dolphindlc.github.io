-- Dolphin Job ID Teleporter
-- Fixed Dragging + Smooth Animations

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Monochrome Colors
local COLOR_BACKGROUND = Color3.fromRGB(20, 20, 20)
local COLOR_ELEVATED = Color3.fromRGB(35, 35, 35)
local COLOR_SURFACE = Color3.fromRGB(30, 30, 30)
local COLOR_ACCENT = Color3.fromRGB(255, 255, 255)
local COLOR_TEXT = Color3.fromRGB(240, 240, 240)
local COLOR_TEXT_SECONDARY = Color3.fromRGB(160, 160, 160)
local COLOR_SUCCESS = Color3.fromRGB(100, 255, 100)
local COLOR_ERROR = Color3.fromRGB(255, 100, 100)
local COLOR_HOVER = Color3.fromRGB(45, 45, 45)

-- Create main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DolphinJobTeleport"
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn = false

-- Main container
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 380, 0, 340)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -170)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = COLOR_BACKGROUND
mainFrame.ClipsDescendants = true
mainFrame.Active = true
mainFrame.Selectable = true

-- Rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = mainFrame

-- Header with drag area
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 50)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = COLOR_ELEVATED
header.BorderSizePixel = 0
header.Active = true
header.Selectable = true

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 14, 0, 0)
headerCorner.Parent = header

-- Title
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "DOLPHIN TELEPORTER"
title.TextColor3 = COLOR_ACCENT
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextTransparency = 0
title.Parent = header

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 10)
closeButton.BackgroundColor3 = COLOR_SURFACE
closeButton.TextColor3 = COLOR_TEXT
closeButton.Text = "✕"
closeButton.TextSize = 18
closeButton.Font = Enum.Font.GothamBold
closeButton.AutoButtonColor = false
closeButton.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

-- Content area
local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -30, 1, -100)
content.Position = UDim2.new(0, 15, 0, 65)
content.BackgroundTransparency = 1
content.Parent = mainFrame

-- Current Job ID section
local currentSection = Instance.new("Frame")
currentSection.Name = "CurrentSection"
currentSection.Size = UDim2.new(1, 0, 0, 80)
currentSection.Position = UDim2.new(0, 0, 0, 0)
currentSection.BackgroundColor3 = COLOR_SURFACE
currentSection.Parent = content

local currentCorner = Instance.new("UICorner")
currentCorner.CornerRadius = UDim.new(0, 10)
currentCorner.Parent = currentSection

local currentLabel = Instance.new("TextLabel")
currentLabel.Name = "CurrentLabel"
currentLabel.Size = UDim2.new(1, -20, 0, 20)
currentLabel.Position = UDim2.new(0, 15, 0, 15)
currentLabel.BackgroundTransparency = 1
currentLabel.Text = "CURRENT JOB ID"
currentLabel.TextColor3 = COLOR_TEXT_SECONDARY
currentLabel.TextSize = 11
currentLabel.Font = Enum.Font.GothamMedium
currentLabel.TextXAlignment = Enum.TextXAlignment.Left
currentLabel.Parent = currentSection

local currentJobId = Instance.new("TextLabel")
currentJobId.Name = "CurrentJobId"
currentJobId.Size = UDim2.new(1, -90, 0, 30)
currentJobId.Position = UDim2.new(0, 15, 0, 35)
currentJobId.BackgroundTransparency = 1
currentJobId.Text = tostring(game.JobId)
currentJobId.TextColor3 = COLOR_TEXT
currentJobId.TextSize = 16
currentJobId.Font = Enum.Font.GothamBold
currentJobId.TextXAlignment = Enum.TextXAlignment.Left
currentJobId.TextTruncate = Enum.TextTruncate.AtEnd
currentJobId.Parent = currentSection

-- Copy button
local copyButton = Instance.new("TextButton")
copyButton.Name = "CopyButton"
copyButton.Size = UDim2.new(0, 70, 0, 32)
copyButton.Position = UDim2.new(1, -80, 0, 35)
copyButton.BackgroundColor3 = COLOR_ELEVATED
copyButton.TextColor3 = COLOR_TEXT
copyButton.Text = "COPY"
copyButton.TextSize = 12
copyButton.Font = Enum.Font.GothamMedium
copyButton.AutoButtonColor = false
copyButton.Parent = currentSection

local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 8)
copyCorner.Parent = copyButton

-- Target Job ID section
local targetSection = Instance.new("Frame")
targetSection.Name = "TargetSection"
targetSection.Size = UDim2.new(1, 0, 0, 100)
targetSection.Position = UDim2.new(0, 0, 0, 95)
targetSection.BackgroundTransparency = 1
targetSection.Parent = content

local targetLabel = Instance.new("TextLabel")
targetLabel.Name = "TargetLabel"
targetLabel.Size = UDim2.new(1, 0, 0, 20)
targetLabel.Position = UDim2.new(0, 0, 0, 0)
targetLabel.BackgroundTransparency = 1
targetLabel.Text = "TARGET JOB ID"
targetLabel.TextColor3 = COLOR_TEXT_SECONDARY
targetLabel.TextSize = 11
targetLabel.Font = Enum.Font.GothamMedium
targetLabel.TextXAlignment = Enum.TextXAlignment.Left
targetLabel.Parent = targetSection

local jobIdInput = Instance.new("TextBox")
jobIdInput.Name = "JobIdInput"
jobIdInput.Size = UDim2.new(1, 0, 0, 45)
jobIdInput.Position = UDim2.new(0, 0, 0, 25)
jobIdInput.BackgroundColor3 = COLOR_SURFACE
jobIdInput.TextColor3 = COLOR_TEXT
jobIdInput.TextSize = 16
jobIdInput.Font = Enum.Font.Gotham
jobIdInput.PlaceholderText = "Enter Job ID..."
jobIdInput.PlaceholderColor3 = COLOR_TEXT_SECONDARY
jobIdInput.Text = ""
jobIdInput.ClearTextOnFocus = false
jobIdInput.Parent = targetSection

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 10)
inputCorner.Parent = jobIdInput

local inputPadding = Instance.new("UIPadding")
inputPadding.PaddingLeft = UDim.new(0, 15)
inputPadding.PaddingRight = UDim.new(0, 15)
inputPadding.Parent = jobIdInput

-- Teleport button
local teleportButton = Instance.new("TextButton")
teleportButton.Name = "TeleportButton"
teleportButton.Size = UDim2.new(1, 0, 0, 48)
teleportButton.Position = UDim2.new(0, 0, 1, -48)
teleportButton.BackgroundColor3 = COLOR_ELEVATED
teleportButton.TextColor3 = COLOR_ACCENT
teleportButton.Text = "Join"
teleportButton.TextSize = 16
teleportButton.Font = Enum.Font.GothamBold
teleportButton.AutoButtonColor = false
teleportButton.Parent = content

local teleportCorner = Instance.new("UICorner")
teleportCorner.CornerRadius = UDim.new(0, 10)
teleportCorner.Parent = teleportButton

-- Status message
local statusMessage = Instance.new("TextLabel")
statusMessage.Name = "StatusMessage"
statusMessage.Size = UDim2.new(1, -40, 0, 20)
statusMessage.Position = UDim2.new(0, 20, 1, -25)
statusMessage.BackgroundTransparency = 1
statusMessage.Text = ""
statusMessage.TextColor3 = COLOR_TEXT_SECONDARY
statusMessage.TextSize = 12
statusMessage.Font = Enum.Font.Gotham
statusMessage.TextXAlignment = Enum.TextXAlignment.Center
statusMessage.Visible = false
statusMessage.Parent = mainFrame

-- Final hierarchy
mainFrame.Parent = screenGui
screenGui.Parent = playerGui

-- Simple drag functionality (FIXED)
local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        update(input)
    end
end)

-- Smooth hover animations
local function createHoverEffect(button, defaultColor, hoverColor)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = defaultColor}):Play()
    end)
end

-- Apply hover effects
createHoverEffect(teleportButton, COLOR_ELEVATED, COLOR_HOVER)
createHoverEffect(copyButton, COLOR_ELEVATED, COLOR_HOVER)
createHoverEffect(closeButton, COLOR_SURFACE, COLOR_HOVER)

-- Input field focus effects
jobIdInput.Focused:Connect(function()
    TweenService:Create(jobIdInput, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    }):Play()
end)

jobIdInput.FocusLost:Connect(function()
    TweenService:Create(jobIdInput, TweenInfo.new(0.2), {
        BackgroundColor3 = COLOR_SURFACE
    }):Play()
end)

-- Copy functionality
copyButton.MouseButton1Click:Connect(function()
    local currentId = tostring(game.JobId)
    
    -- Try to copy to clipboard
    local success = pcall(function()
        if setclipboard then
            setclipboard(currentId)
            return true
        end
        return false
    end)
    
    if success then
        copyButton.Text = "COPIED!"
        TweenService:Create(copyButton, TweenInfo.new(0.2), {
            TextColor3 = COLOR_SUCCESS,
            BackgroundColor3 = Color3.fromRGB(30, 50, 30)
        }):Play()
        
        statusMessage.Text = "Job ID copied to clipboard"
        statusMessage.TextColor3 = COLOR_SUCCESS
        statusMessage.Visible = true
        
        wait(1.5)
        
        copyButton.Text = "COPY"
        TweenService:Create(copyButton, TweenInfo.new(0.2), {
            TextColor3 = COLOR_TEXT,
            BackgroundColor3 = COLOR_ELEVATED
        }):Play()
        
        statusMessage.Visible = false
    else
        copyButton.Text = "ERROR!"
        TweenService:Create(copyButton, TweenInfo.new(0.2), {
            TextColor3 = COLOR_ERROR,
            BackgroundColor3 = Color3.fromRGB(50, 30, 30)
        }):Play()
        
        statusMessage.Text = "Failed to copy"
        statusMessage.TextColor3 = COLOR_ERROR
        statusMessage.Visible = true
        
        wait(1.5)
        
        copyButton.Text = "COPY"
        TweenService:Create(copyButton, TweenInfo.new(0.2), {
            TextColor3 = COLOR_TEXT,
            BackgroundColor3 = COLOR_ELEVATED
        }):Play()
        
        statusMessage.Visible = false
    end
end)

-- Close button
closeButton.MouseButton1Click:Connect(function()
    TweenService:Create(mainFrame, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    
    wait(0.3)
    screenGui:Destroy()
end)

-- Teleport function
teleportButton.MouseButton1Click:Connect(function()
    local jobId = jobIdInput.Text:gsub("%s+", "")
    
    if #jobId == 0 then
        -- Shake animation
        local shake1 = TweenService:Create(jobIdInput, TweenInfo.new(0.05), {Position = UDim2.new(0, -5, 0, 25)})
        local shake2 = TweenService:Create(jobIdInput, TweenInfo.new(0.05), {Position = UDim2.new(0, 5, 0, 25)})
        local shake3 = TweenService:Create(jobIdInput, TweenInfo.new(0.05), {Position = UDim2.new(0, 0, 0, 25)})
        
        shake1:Play()
        wait(0.05)
        shake2:Play()
        wait(0.05)
        shake3:Play()
        
        statusMessage.Text = "Please enter a Job ID"
        statusMessage.TextColor3 = COLOR_ERROR
        statusMessage.Visible = true
        wait(2)
        statusMessage.Visible = false
        return
    end
    
    -- Validate Job ID
    local isValid = false
    if jobId:match("^%d+$") then
        isValid = true
    elseif jobId:match("^%x+%-%x+%-%x+%-%x+%-%x+$") then
        isValid = true
    end
    
    if not isValid then
        TweenService:Create(jobIdInput, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(50, 30, 30)
        }):Play()
        
        statusMessage.Text = "Invalid Job ID format"
        statusMessage.TextColor3 = COLOR_ERROR
        statusMessage.Visible = true
        wait(2)
        
        TweenService:Create(jobIdInput, TweenInfo.new(0.2), {
            BackgroundColor3 = COLOR_SURFACE
        }):Play()
        
        statusMessage.Visible = false
        return
    end
    
    -- Start teleport
    teleportButton.Text = "TELEPORTING..."
    teleportButton.AutoButtonColor = false
    
    TweenService:Create(teleportButton, TweenInfo.new(0.3), {
        BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    }):Play()
    
    statusMessage.Text = "..."
    statusMessage.TextColor3 = COLOR_TEXT
    statusMessage.Visible = true
    
    -- Attempt teleport
    local success, errorMsg = pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, player)
    end)
    
    if not success then
        teleportButton.Text = "Join"
        TweenService:Create(teleportButton, TweenInfo.new(0.3), {
            BackgroundColor3 = COLOR_ELEVATED
        }):Play()
        
        statusMessage.Text = "Error: " .. (errorMsg or "Unknown")
        statusMessage.TextColor3 = COLOR_ERROR
        wait(3)
        statusMessage.Visible = false
    end
end)

-- Enter key support
jobIdInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        teleportButton:Activate()
    end
end)

-- Auto-focus input
wait(0.5)
jobIdInput:CaptureFocus()

print("[Dolphin] loaded")
