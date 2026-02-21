local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")

local P = Players.LocalPlayer

local function f(class, props)
    local o = Instance.new(class)
    for k,v in pairs(props or {}) do o[k] = v end
    return o
end

-- MAIN GUI
local Gui = f("ScreenGui", {
    Parent = P:WaitForChild("PlayerGui"),
    Name = "BLORAX_INVISIBLE_CLONE"
})

local Frame = f("Frame", {
    Parent = Gui,
    Size = UDim2.new(0,300,0,150),
    Position = UDim2.new(0.5,-150,0.3,0),
    BackgroundColor3 = Color3.fromRGB(60,20,20),
    BackgroundTransparency = 0.3,
    Active = true,
    Draggable = true
})
f("UICorner", { Parent = Frame, CornerRadius = UDim.new(0,10) })

-- HEADER
local Header = f("TextLabel", {
    Parent = Frame,
    Size = UDim2.new(1,0,0,40),
    BackgroundTransparency = 1,
    Text = "Swiftthub | .gg/dlph",
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextColor3 = Color3.fromRGB(255,255,255)
})

-- CLOSE BUTTON
local Close = f("TextButton", {
    Parent = Frame,
    Size = UDim2.new(0,28,0,28),
    Position = UDim2.new(1,-34,0,6),
    BackgroundColor3 = Color3.fromRGB(255,0,0),
    BorderSizePixel = 0,
    Text = "X",
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextColor3 = Color3.fromRGB(230,230,230)
})
f("UICorner", { Parent = Close, CornerRadius = UDim.new(0,6) })
Close.MouseButton1Click:Connect(function() Gui:Destroy() end)

-- ACTIVATE BUTTON
local ActivateBtn = f("TextButton", {
    Parent = Frame,
    Size = UDim2.new(0,270,0,60),
    Position = UDim2.new(0,15,0,65),
    BackgroundColor3 = Color3.fromRGB(255,0,0),
    BorderSizePixel = 0,
    Text = "clone 🚽🚽🚽",
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextColor3 = Color3.fromRGB(255,255,255)
})
f("UICorner", { Parent = ActivateBtn, CornerRadius = UDim.new(0,8) })

-- ACTIVATE BUTTON BEHAVIOR
ActivateBtn.MouseButton1Click:Connect(function()
    ActivateBtn.Text = "Activating..."
    ActivateBtn.BackgroundColor3 = Color3.fromRGB(150,150,150)
    
    task.spawn(function()
        local backpack = P:WaitForChild("Backpack")
        local char = P.Character
        
        if not char or not char:FindFirstChild("Humanoid") then
            ActivateBtn.Text = "No Character!"
            task.wait(2)
            ActivateBtn.Text = "Activate Invisible Clone"
            ActivateBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
            return
        end
        
        local humanoid = char.Humanoid
        
        -- Step 1: Find and equip Invisibility Cloak
        local invisCloak = backpack:FindFirstChild("Invisibility Cloak") or char:FindFirstChild("Invisibility Cloak")
        if not invisCloak then
            ActivateBtn.Text = "No Invisibility Cloak!"
            task.wait(2)
            ActivateBtn.Text = "Activate Invisible Clone"
            ActivateBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
            return
        end
        
        -- Equip invisibility cloak
        if invisCloak.Parent == backpack then
            humanoid:EquipTool(invisCloak)
            task.wait(0.1)
        end
        
        -- Step 2: Activate invisibility cloak
        pcall(function()
            invisCloak:Activate()
        end)
        
        -- Wait super short for fade to start
        task.wait(0.5)
        
        -- Step 3: Find and equip Quantum Cloner immediately
        local quantumCloner = backpack:FindFirstChild("Quantum Cloner") or char:FindFirstChild("Quantum Cloner")
        if not quantumCloner then
            ActivateBtn.Text = "No Quantum Cloner!"
            task.wait(2)
            ActivateBtn.Text = "Activate Invisible Clone"
            ActivateBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
            return
        end
        
        -- Equip quantum cloner instantly
        if quantumCloner.Parent == backpack then
            humanoid:EquipTool(quantumCloner)
        end
        
        -- Step 4: Activate quantum cloner instantly with no wait
        pcall(function()
            quantumCloner:Activate()
        end)
        
        task.wait(0.5)
        
        ActivateBtn.Text = "Clone Created!"
        ActivateBtn.BackgroundColor3 = Color3.fromRGB(0,255,0)
        task.wait(2)
        ActivateBtn.Text = "Activate Invisible Clone"
        ActivateBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
    end)
end)
