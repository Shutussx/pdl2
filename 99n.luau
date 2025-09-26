local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 220, 0, 100)
main.Position = UDim2.new(0.5, -110, 0.1, 0)
main.BackgroundColor3 = Color3.fromRGB(30,30,30)
main.BorderSizePixel = 0

local header = Instance.new("Frame", main)
header.Size = UDim2.new(1,0,0,40)
header.BackgroundColor3 = Color3.fromRGB(50,50,50)
header.BorderSizePixel = 0

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1,0,1,0)
title.BackgroundTransparency = 1
title.Text = "🔥 Campfire Magnet 🔥"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold

local btn = Instance.new("TextButton", main)
btn.Size = UDim2.new(1,0,0,60)
btn.Position = UDim2.new(0,0,0,40)
btn.Text = "▶ Start Magnet"
btn.BackgroundColor3 = Color3.fromRGB(45,200,45)
btn.TextColor3 = Color3.fromRGB(255,255,255)
btn.TextScaled = true
btn.Font = Enum.Font.GothamBold
btn.BorderSizePixel = 0

-- Magnet toggle
local magnetOn = false
local campfireCFrame = CFrame.new(0.03, 6.07, -1.84)

-- Function to “interact” with logs (simulate clicks)
local function interact(obj)
    -- Try to click all parts in the model
    for _, part in ipairs(obj:GetDescendants()) do
        if part:IsA("BasePart") then
            -- Example: simulate mouse click (local player)
            if game:GetService("VirtualInputManager") then
                local vm = game:GetService("VirtualInputManager")
                vm:SendMouseButtonEvent(0,0,0,true,game,0)
                vm:SendMouseButtonEvent(0,0,0,false,game,0)
            end
        end
    end
end

btn.MouseButton1Click:Connect(function()
    magnetOn = not magnetOn
    btn.Text = magnetOn and "⛔ Stop Magnet" or "▶ Start Magnet"
    btn.BackgroundColor3 = magnetOn and Color3.fromRGB(200,45,45) or Color3.fromRGB(45,200,45)

    if magnetOn then
        task.spawn(function()
            while magnetOn do
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("Model") and (obj.Name == "Log" or obj.Name == "Small Tree") then
                        interact(obj) -- 🔹 interact first
                        local part = obj:FindFirstChildWhichIsA("BasePart")
                        if part then
                            obj:PivotTo(campfireCFrame + Vector3.new(math.random(-3,3),0,math.random(-3,3)))
                        end
                    elseif obj:IsA("BasePart") and (obj.Name == "Log" or obj.Name == "Small Tree") then
                        interact(obj)
                        obj.CFrame = campfireCFrame + Vector3.new(math.random(-3,3),0,math.random(-3,3))
                    end
                end
                task.wait(0.5)
            end
        end)
    end
end)

-- Right-click drag logic
local dragging = false
local dragStart, startPos

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

header.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)