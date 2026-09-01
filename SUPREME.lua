local UI = (function()
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local UI = {}

local Theme = {
    Background = Color3.fromRGB(22, 22, 24),
    Topbar = Color3.fromRGB(30, 30, 33),
    Section = Color3.fromRGB(45, 45, 50),
    Element = Color3.fromRGB(32, 32, 36),
    ElementHover = Color3.fromRGB(38, 38, 43),
    ElementSelected = Color3.fromRGB(55, 90, 150),
    Stroke = Color3.fromRGB(58, 58, 64),
    Text = Color3.new(1, 1, 1),
    SubText = Color3.fromRGB(150, 150, 155),
    Accent = Color3.fromRGB(75, 150, 255),
}

local function Corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
    return c
end

local function Stroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or Theme.Stroke
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local function Make(class, props)
    local i = Instance.new(class)
    if props then
        for k, v in pairs(props) do
            i[k] = v
        end
    end
    return i
end

local function CreateWindow(config)
    config = config or {}
    local name = config.Name or "UI"

    local _window = { Tabs = {} }

    local ScreenGui = Make("ScreenGui", {
        Name = name .. "_UI",
        ResetOnSpawn = false,
        DisplayOrder = 10,
        IgnoreGuiInset = true,
        Enabled = true,
    })

    local MainFrame = Make("Frame", {
        Size = UDim2.fromOffset(370, 460),
        Position = UDim2.new(0.5, -185, 0.5, -230),
        BackgroundColor3 = Theme.Background,
        ClipsDescendants = true,
    })
    Corner(MainFrame, 10)
    Stroke(MainFrame, Theme.Stroke, 1)
    MainFrame.Parent = ScreenGui

    local Topbar = Make("Frame", {
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = Theme.Topbar,
    })
    Corner(Topbar, 10)
    Topbar.Parent = MainFrame

    local TopbarCorner = Make("Frame", {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 1, -4),
        BackgroundColor3 = Theme.Topbar,
        ZIndex = 0,
    })
    TopbarCorner.Parent = Topbar

    Make("TextLabel", {
        Text = name,
        Size = UDim2.new(1, -90, 1, 0),
        Position = UDim2.fromOffset(14, 0),
        BackgroundTransparency = 1,
        TextColor3 = Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Topbar,
    })

    local MinimizeBtn = Make("TextButton", {
        Text = "-",
        Size = UDim2.fromOffset(24, 24),
        Position = UDim2.new(1, -58, 0.5, -12),
        BackgroundColor3 = Theme.Element,
        TextColor3 = Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        BorderSizePixel = 0,
        Parent = Topbar,
    })
    Corner(MinimizeBtn, 6)

    local CloseBtn = Make("TextButton", {
        Text = "X",
        Size = UDim2.fromOffset(24, 24),
        Position = UDim2.new(1, -28, 0.5, -12),
        BackgroundColor3 = Theme.Element,
        TextColor3 = Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        BorderSizePixel = 0,
        Parent = Topbar,
    })
    Corner(CloseBtn, 6)

    local TabsFrame = Make("Frame", {
        Size = UDim2.new(1, 0, 0, 34),
        Position = UDim2.new(0, 0, 0, 38),
        BackgroundColor3 = Theme.Background,
    })
    TabsFrame.Parent = MainFrame

    local TabsLayout = Make("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center,
    })
    TabsLayout.Parent = TabsFrame

    local TabsPad = Make("UIPadding", {
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
    })
    TabsPad.Parent = TabsFrame

    local Content = Make("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, -72),
        Position = UDim2.new(0, 0, 0, 72),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Theme.Stroke,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0),
    })
    Content.Parent = MainFrame

    Make("UIPadding", {
        PaddingTop = UDim.new(0, 8),
        PaddingBottom = UDim.new(0, 12),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        Parent = Content,
    })

    local dragging = false
    local dragOffset = Vector2.zero
    Topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragOffset = MainFrame.AbsolutePosition - UserInputService:GetMouseLocation()
        end
    end)
    Topbar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging then
            local m = UserInputService:GetMouseLocation() + dragOffset
            MainFrame.Position = UDim2.fromOffset(m.X, m.Y)
        end
    end)

    local minimised = false
    MinimizeBtn.MouseButton1Click:Connect(function()
        minimised = not minimised
        TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
            Size = minimised and UDim2.fromOffset(370, 38) or UDim2.fromOffset(370, 460),
        }):Play()
    end)
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui.Enabled = false
    end)

    _window.ScreenGui = ScreenGui
    _window.MainFrame = MainFrame
    _window.SetVisible = function(v)
        ScreenGui.Enabled = v
    end

    local function ShowTab(tab)
        for _, t in ipairs(_window.Tabs) do
            local active = t == tab
            t.Page.Visible = active
            t.TabButton.BackgroundColor3 = active and Theme.ElementSelected or Theme.Section
            t.TabButton.TextColor3 = active and Color3.new(1, 1, 1) or Theme.SubText
        end
        Content.CanvasPosition = Vector2.zero
    end

    function _window:CreateTab(tabName)
        local page = Make("Frame", {
            Name = tabName,
            Size = UDim2.new(1, 0, 0, 0),
            BackgroundTransparency = 1,
            AutomaticSize = Enum.AutomaticSize.Y,
        })
        page.Parent = self.Content

        local layout = Make("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0, 8),
        })
        layout.Parent = page

        local tabBtn = Make("TextButton", {
            Text = tabName,
            Size = UDim2.new(0, 70, 0, 26),
            BackgroundColor3 = Theme.Section,
            TextColor3 = Theme.SubText,
            Font = Enum.Font.Gotham,
            TextSize = 13,
            BorderSizePixel = 0,
        })
        Corner(tabBtn, 6)
        tabBtn.Size = UDim2.new(0, math.max(50, tabBtn.TextBounds.X + 20), 0, 26)
        tabBtn.Parent = TabsFrame

        local tab = {
            Name = tabName,
            Page = page,
            TabButton = tabBtn,
            ElementCount = 0,
        }

        tabBtn.MouseButton1Click:Connect(function()
            ShowTab(tab)
        end)

        table.insert(self.Tabs, tab)
        if #self.Tabs == 1 then
            ShowTab(tab)
        end

        function tab:CreateSection(title)
            self.ElementCount = self.ElementCount + 1
            return Make("TextLabel", {
                Text = title:upper(),
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                TextColor3 = Theme.Accent,
                Font = Enum.Font.GothamBold,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                LayoutOrder = self.ElementCount,
                Parent = self.Page,
            })
        end

        function tab:CreateParagraph(text)
            self.ElementCount = self.ElementCount + 1
            return Make("TextLabel", {
                Text = text or "",
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundTransparency = 1,
                TextColor3 = Theme.SubText,
                Font = Enum.Font.Gotham,
                TextSize = 11,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                LayoutOrder = self.ElementCount,
                Parent = self.Page,
            })
        end

        function tab:CreateToggle(opts)
            opts = opts or {}
            self.ElementCount = self.ElementCount + 1
            local state = opts.CurrentValue or false

            local row = Make("Frame", {
                BackgroundColor3 = Theme.Element,
                Size = UDim2.new(1, 0, 0, 34),
                LayoutOrder = self.ElementCount,
                Parent = self.Page,
            })
            Corner(row, 7)
            Stroke(row, Theme.Stroke, 1)

            Make("TextLabel", {
                Text = opts.Name or "",
                Size = UDim2.new(1, -50, 1, 0),
                Position = UDim2.fromOffset(11, 0),
                BackgroundTransparency = 1,
                TextColor3 = Theme.Text,
                Font = Enum.Font.Gotham,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = row,
            })

            local switch = Make("Frame", {
                Size = UDim2.fromOffset(32, 18),
                Position = UDim2.new(1, -44, 0.5, -9),
                BackgroundColor3 = Theme.Section,
                Parent = row,
            })
            Corner(switch, 9)

            local knob = Make("Frame", {
                Size = UDim2.fromOffset(14, 14),
                Position = UDim2.fromOffset(2, 2),
                BackgroundColor3 = Color3.fromRGB(120, 120, 120),
                Parent = switch,
            })
            Corner(knob, 7)

            local function apply(s)
                state = s
                switch.BackgroundColor3 = s and Theme.Accent or Theme.Section
                knob.BackgroundColor3 = s and Color3.new(1, 1, 1) or Color3.fromRGB(120, 120, 120)
                knob.Position = s and UDim2.fromOffset(16, 2) or UDim2.fromOffset(2, 2)
            end
            apply(state)

            local lock = false
            local function fire()
                if lock then return end
                lock = true
                local new = not state
                apply(new)
                if opts.Callback then
                    pcall(opts.Callback, new)
                end
                task.defer(function() lock = false end)
            end
            row.MouseButton1Click:Connect(fire)
            switch.MouseButton1Click:Connect(fire)

            row.MouseEnter:Connect(function()
                TweenService:Create(row, TweenInfo.new(0.12), { BackgroundColor3 = Theme.ElementHover }):Play()
            end)
            row.MouseLeave:Connect(function()
                TweenService:Create(row, TweenInfo.new(0.12), { BackgroundColor3 = Theme.Element }):Play()
            end)

            local toggle = {
                Row = row,
                Set = function(_, v)
                    apply(v)
                    if opts.Callback then
                        pcall(opts.Callback, v)
                    end
                end,
                Get = function()
                    return state
                end,
            }
            _window:_RegisterBindable(toggle, row, opts.Name)

            return toggle
        end

        function tab:CreateSlider(opts)
            opts = opts or {}
            self.ElementCount = self.ElementCount + 1
            local min = opts.Range[1] or 0
            local max = opts.Range[2] or 100
            local val = opts.CurrentValue or min
            local inc = opts.Increment or 1

            local row = Make("Frame", {
                BackgroundColor3 = Theme.Element,
                Size = UDim2.new(1, 0, 0, 56),
                LayoutOrder = self.ElementCount,
                Parent = self.Page,
            })
            Corner(row, 7)
            Stroke(row, Theme.Stroke, 1)

            Make("TextLabel", {
                Text = opts.Name or "",
                Size = UDim2.new(1, -70, 0, 18),
                Position = UDim2.fromOffset(11, 5),
                BackgroundTransparency = 1,
                TextColor3 = Theme.Text,
                Font = Enum.Font.Gotham,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = row,
            })

            local valLabel = Make("TextLabel", {
                Text = tostring(math.floor(val + 0.5)),
                Size = UDim2.new(0, 56, 0, 18),
                Position = UDim2.new(1, -60, 0, 5),
                BackgroundTransparency = 1,
                TextColor3 = Theme.SubText,
                Font = Enum.Font.GothamBold,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = row,
            })

            local track = Make("Frame", {
                Size = UDim2.new(1, -24, 0, 8),
                Position = UDim2.new(0.5, 0, 1, -18),
                AnchorPoint = Vector2.new(0.5, 0),
                BackgroundColor3 = Theme.Section,
                Parent = row,
            })
            Corner(track, 4)

            local fill = Make("Frame", {
                Size = UDim2.new(0, 0, 1, 0),
                BackgroundColor3 = Theme.Accent,
                Parent = track,
            })
            Corner(fill, 4)

            local grip = Make("Frame", {
                Size = UDim2.fromOffset(14, 14),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromOffset(0, 4),
                BackgroundColor3 = Color3.new(1, 1, 1),
                Parent = track,
            })
            Corner(grip, 7)

            local draggingSlider = false

            local function update(x)
                local trackPos = track.AbsolutePosition
                local trackW = track.AbsoluteSize.X
                local ratio = (x - trackPos.X) / trackW
                ratio = math.clamp(ratio, 0, 1)
                local raw = min + (max - min) * ratio
                val = math.clamp(math.floor((raw + 0.0001) / inc + 0.5) * inc, min, max)
                local r = (val - min) / (max - min)
                fill.Size = UDim2.new(0, trackW * r, 1, 0)
                grip.Position = UDim2.fromScale(r, 0.5)
                valLabel.Text = tostring(math.floor(val + 0.5))
            end

            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSlider = true
                    update(UserInputService:GetMouseLocation().X)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and draggingSlider then
                    draggingSlider = false
                    if opts.Callback then pcall(opts.Callback, val) end
                end
            end)
            RunService.RenderStepped:Connect(function()
                if draggingSlider then
                    update(UserInputService:GetMouseLocation().X)
                end
            end)
            task.defer(function()
                task.wait()
                update(val)
            end)

            return {
                Set = function(_, v)
                    val = math.clamp(v, min, max)
                    update(val)
                end,
                Get = function()
                    return val
                end,
                Destroyed = function()
                end,
            }
        end

        return tab
    end

    _window.Bindables = {}

    function _window:RegisterBindable(opts)
        table.insert(self.Bindables, opts)
    end

    function _window:_RegisterBindable(toggle, row, name)
        table.insert(self.Bindables, {
            Toggle = toggle,
            Row = row,
            Name = name,
        })
    end

    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
    end
    ScreenGui.Parent = CoreGui

    return _window
end

UI.CreateWindow = CreateWindow
UI.Theme = Theme

return UI
end)()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer

local OriginalAmbient = Lighting.Ambient
local OriginalBrightness = Lighting.Brightness

local ESP_CONFIG = {
    TOP_OFFSET = Vector3.new(0, 3, 0),
    BOTTOM_OFFSET = Vector3.new(0, 3.5, 0),
    DISTANCE_DIVISOR = 3.5,
    MIN_HEIGHT = 6,
    MIN_WIDTH = 4,
}
local MIN_BULLET_SPEED = 1

local S = {
    Aimbot_Enabled = false,
    Aimbot_WallCheck = true,
    Aimbot_Target_NPCs = false,
    Aim_Smoothing = 0.2,
    Aim_FOV = 150,
    Show_FOV = false,
    ESP_Enabled = false,
    Tracers_Enabled = false,
    ESP_MaxDistance = math.huge,
    NPC_ESP_Enabled = false,
    NPC_Tracers_Enabled = false,
    NPC_ESP_MaxDistance = 1500,
    Fullbright_Enabled = false,
    Prediction_Enabled = false,
    Bullet_Speed = 1500,
    Watermark_Enabled = false,
}

local ESP_Cache = {}
local Visibility_Cache = {}
local Tracked_NPCs = {}
local NPC_ID_Map = {}
local NPC_Counter = 0

local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude

local function refreshRayFilter()
    local list = {}
    local char = LocalPlayer.Character
    local cam = workspace.CurrentCamera
    if char then table.insert(list, char) end
    if cam then table.insert(list, cam) end
    rayParams.FilterDescendantsInstances = list
end

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Visible = false
FOVCircle.NumSides = 60

local function ClearEntityESP(id)
    if ESP_Cache[id] then
        ESP_Cache[id].Box:Remove()
        ESP_Cache[id].Text:Remove()
        ESP_Cache[id].Tracer:Remove()
        ESP_Cache[id] = nil
    end
    Visibility_Cache[id] = nil
end

local function HideESP(id)
    local cached = ESP_Cache[id]
    if not cached then return end
    cached.Box.Visible = false
    cached.Text.Visible = false
    cached.Tracer.Visible = false
end

local function GetNPCId(npc)
    return NPC_ID_Map[npc]
end

Players.PlayerRemoving:Connect(function(player)
    ClearEntityESP(tostring(player.UserId))
end)

local function IsNPC(model)
    local hum = model:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    if not model:FindFirstChild("HumanoidRootPart") then return false end
    if Players:GetPlayerFromCharacter(model) then return false end
    return true
end

local function CheckAndAddNPC(obj)
    if IsNPC(obj) and not NPC_ID_Map[obj] then
        NPC_Counter = NPC_Counter + 1
        local id = "NPC_" .. NPC_Counter
        NPC_ID_Map[obj] = id
        Tracked_NPCs[obj] = true
    end
end

local function RemoveNPC(obj)
    local id = NPC_ID_Map[obj]
    if id then
        ClearEntityESP(id)
        NPC_ID_Map[obj] = nil
        Tracked_NPCs[obj] = nil
    end
end

task.spawn(function()
    local count = 0
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then CheckAndAddNPC(obj) end
        count = count + 1
        if count % 500 == 0 then task.wait() end
    end
end)

workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("Model") then
        task.delay(0.3, function() CheckAndAddNPC(obj) end)
    end
end)
workspace.DescendantRemoving:Connect(RemoveNPC)

local function GetVisibility(targetId, char)
    local currentTime = tick()
    if Visibility_Cache[targetId] and (currentTime - Visibility_Cache[targetId].lastUpdate) < 0.1 then
        return Visibility_Cache[targetId].isVisible
    end
    local cam = workspace.CurrentCamera
    if not cam then return false end
    local partsToCheck = {
        char:FindFirstChild("Head"),
        char:FindFirstChild("HumanoidRootPart"),
        char:FindFirstChild("Right Arm") or char:FindFirstChild("RightUpperArm"),
        char:FindFirstChild("Left Arm") or char:FindFirstChild("LeftUpperArm"),
        char:FindFirstChild("Right Leg") or char:FindFirstChild("RightUpperLeg"),
        char:FindFirstChild("Left Leg") or char:FindFirstChild("LeftUpperLeg"),
    }
    local origin = cam.CFrame.Position
    local isVisible = false
    for _, part in pairs(partsToCheck) do
        if part and part:IsA("BasePart") then
            local result = workspace:Raycast(origin, part.Position - origin, rayParams)
            if result and result.Instance:IsDescendantOf(char) then
                isVisible = true
                break
            end
        end
    end
    Visibility_Cache[targetId] = { isVisible = isVisible, lastUpdate = currentTime }
    return isVisible
end

local function DrawESP(id, char, hrp, name, team, isNPC)
    local showBox = isNPC and S.NPC_ESP_Enabled or (not isNPC and S.ESP_Enabled)
    local showTracer = isNPC and S.NPC_Tracers_Enabled or (not isNPC and S.Tracers_Enabled)
    local maxDist = isNPC and S.NPC_ESP_MaxDistance or S.ESP_MaxDistance
    if not showBox and not showTracer then return end

    local cam = workspace.CurrentCamera
    if not cam then return end
    local dist = (cam.CFrame.Position - hrp.Position).Magnitude
    if dist > maxDist or dist == 0 then return end
    local rootScreen, onScreen = cam:WorldToViewportPoint(hrp.Position)
    if not onScreen then return end

    if not ESP_Cache[id] then
        ESP_Cache[id] = { Box = Drawing.new("Square"), Text = Drawing.new("Text"), Tracer = Drawing.new("Line") }
        ESP_Cache[id].Box.Thickness = 1.5
        ESP_Cache[id].Box.Filled = false
        ESP_Cache[id].Text.Size = 14
        ESP_Cache[id].Text.Center = true
        ESP_Cache[id].Text.Outline = true
        ESP_Cache[id].Tracer.Thickness = 1.5
    end

    local box, text, tracer = ESP_Cache[id].Box, ESP_Cache[id].Text, ESP_Cache[id].Tracer
    local topScreenPos = cam:WorldToViewportPoint(hrp.Position + ESP_CONFIG.TOP_OFFSET)
    local bottomScreenPos = cam:WorldToViewportPoint(hrp.Position - ESP_CONFIG.BOTTOM_OFFSET)
    local height = math.abs(bottomScreenPos.Y - topScreenPos.Y)
    local width = height / 2
    if height < ESP_CONFIG.MIN_HEIGHT then
        height = ESP_CONFIG.MIN_HEIGHT
        width = ESP_CONFIG.MIN_WIDTH
    end

    local visible = GetVisibility(id, char)
    local renderColor
    if isNPC then
        renderColor = visible and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(200, 0, 255)
    else
        renderColor = Color3.new(1, 0, 0)
        if team == LocalPlayer.Team and team ~= nil then
            renderColor = Color3.new(0, 0.5, 1)
        elseif visible then
            renderColor = Color3.new(0, 1, 0)
        end
    end

    if showBox then
        box.Size = Vector2.new(width, height)
        box.Position = Vector2.new(rootScreen.X - (width / 2), topScreenPos.Y)
        box.Color = renderColor
        box.Visible = true
        local prefix = isNPC and "[NPC] " or ""
        text.Text = string.format("%s%s [%dm]", prefix, name, math.floor(dist / ESP_CONFIG.DISTANCE_DIVISOR))
        text.Position = Vector2.new(rootScreen.X, topScreenPos.Y - 18)
        text.Color = renderColor
        text.Visible = true
    end

    if showTracer then
        tracer.From = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)
        tracer.To = Vector2.new(rootScreen.X, bottomScreenPos.Y)
        tracer.Color = renderColor
        tracer.Visible = true
    end
end

local function HideAllESP()
    for id in pairs(ESP_Cache) do HideESP(id) end
end

local function CleanupStaleESP()
    local now = tick()
    for id, cache in pairs(ESP_Cache) do
        if cache.LastDrawn and (now - cache.LastDrawn) > 0.5 then
            ClearEntityESP(id)
        end
    end
end

local function GetClosestTarget()
    if not S.Aimbot_Enabled then return nil end
    local cam = workspace.CurrentCamera
    if not cam then return nil end
    local target = nil
    local shortestDistance = S.Aim_FOV
    local mousePos = UserInputService:GetMouseLocation()

    local function CheckTarget(entityId, character)
        local aimPart = character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
        if not aimPart then return end
        local screenPos, onScreen = cam:WorldToViewportPoint(aimPart.Position)
        if onScreen then
            local distanceToMouse = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
            if distanceToMouse < shortestDistance then
                if S.Aimbot_WallCheck then
                    if GetVisibility(entityId, character) then
                        target = aimPart
                        shortestDistance = distanceToMouse
                    end
                else
                    target = aimPart
                    shortestDistance = distanceToMouse
                end
            end
        end
    end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if player.Team ~= LocalPlayer.Team or player.Team == nil then
                CheckTarget(tostring(player.UserId), player.Character)
            end
        end
    end

    if S.Aimbot_Target_NPCs then
        for npc in pairs(Tracked_NPCs) do
            local npcId = GetNPCId(npc)
            if npcId and (npc.PrimaryPart or npc:FindFirstChild("HumanoidRootPart")) then
                CheckTarget(npcId, npc)
            end
        end
    end

    return target
end

local Window = UI.CreateWindow({ Name = "SUPREME HUB" })

local CombatTab = Window:CreateTab("Combat")
local VisualsTab = Window:CreateTab("Visuals")

CombatTab:CreateSection("Aimbot")
CombatTab:CreateToggle({ Name = "Aimbot", CurrentValue = false, stateKey = "Aimbot_Enabled", Callback = function(v) S.Aimbot_Enabled = v end })
CombatTab:CreateSection("Aimbot Settings")
CombatTab:CreateToggle({ Name = "Aimbot Wall Check", CurrentValue = true, Callback = function(v) S.Aimbot_WallCheck = v end })
CombatTab:CreateToggle({ Name = "Aimbot Targets NPCs", CurrentValue = false, Callback = function(v) S.Aimbot_Target_NPCs = v end })
CombatTab:CreateToggle({ Name = "Aimbot Prediction", CurrentValue = false, Callback = function(v) S.Prediction_Enabled = v end })
CombatTab:CreateSlider({ Name = "Bullet Speed", Range = { 100, 5000 }, Increment = 50, CurrentValue = 1500, Callback = function(v) S.Bullet_Speed = v end })
CombatTab:CreateSlider({ Name = "Aimbot Smoothing", Range = { 0.05, 1 }, Increment = 0.05, CurrentValue = 0.2, Callback = function(v) S.Aim_Smoothing = v end })
CombatTab:CreateSlider({ Name = "FOV Radius", Range = { 50, 800 }, Increment = 10, CurrentValue = 150, Callback = function(v) S.Aim_FOV = v end })
CombatTab:CreateToggle({ Name = "Show FOV Circle", CurrentValue = false, Callback = function(v) S.Show_FOV = v end })

VisualsTab:CreateSection("Players")
VisualsTab:CreateToggle({ Name = "Player ESP", CurrentValue = false, stateKey = "ESP_Enabled", Callback = function(v) S.ESP_Enabled = v end })
VisualsTab:CreateToggle({ Name = "ESP Tracers", CurrentValue = false, Callback = function(v) S.Tracers_Enabled = v end })
VisualsTab:CreateSection("NPCs")
VisualsTab:CreateToggle({ Name = "NPC ESP", CurrentValue = false, stateKey = "NPC_ESP_Enabled", Callback = function(v) S.NPC_ESP_Enabled = v end })
VisualsTab:CreateToggle({ Name = "NPC ESP Tracers", CurrentValue = false, Callback = function(v) S.NPC_Tracers_Enabled = v end })
VisualsTab:CreateSlider({ Name = "NPC ESP Max Distance", Range = { 50, 5000 }, Increment = 50, CurrentValue = 1500, Callback = function(v) S.NPC_ESP_MaxDistance = v end })
VisualsTab:CreateSection("Extras")
VisualsTab:CreateToggle({ Name = "Fullbright", CurrentValue = false, stateKey = "Fullbright_Enabled", Callback = function(v) S.Fullbright_Enabled = v end })
VisualsTab:CreateToggle({ Name = "Watermark", CurrentValue = false, stateKey = "Watermark_Enabled", Callback = function(v) S.Watermark_Enabled = v end })

local featureBinds = {}
local prevState = {}
local bindingTarget = nil

local function ToggleBindable(entry)
    if entry.Toggle then
        entry.Toggle:Set(not entry.Toggle:Get())
    elseif entry.OnToggle then
        entry.OnToggle()
    end
end

local function wireMiddleClick()
    for _, entry in ipairs(Window.Bindables) do
        if entry.Row then
            entry.Row.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton3 then
                    bindingTarget = entry
                end
            end)
        end
    end
end

RunService.RenderStepped:Connect(function()
    for entry, kc in pairs(featureBinds) do
        local held = UserInputService:IsKeyDown(kc)
        if held and not prevState[entry] then
            prevState[entry] = true
            ToggleBindable(entry)
        elseif not held then
            prevState[entry] = false
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if bindingTarget then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            local key = input.KeyCode
            if key ~= Enum.KeyCode.RightShift then
                featureBinds[bindingTarget] = key
                prevState[bindingTarget] = false
                bindingTarget = nil
            end
        end
        return
    end
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        Window:SetVisible(not Window.ScreenGui.Enabled)
    end
end)

local watermarkGui, watermarkFrame, watermarkText
local function buildWatermark()
    watermarkGui = Instance.new("ScreenGui")
    watermarkGui.Name = "WatermarkGUI"
    watermarkGui.ResetOnSpawn = false
    watermarkGui.DisplayOrder = 200
    watermarkGui.IgnoreGuiInset = true
    watermarkGui.Enabled = false

    watermarkFrame = Instance.new("Frame")
    watermarkFrame.Size = UDim2.fromOffset(220, 34)
    watermarkFrame.Position = UDim2.new(0, 20, 0, 20)
    watermarkFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 26)
    watermarkFrame.BorderSizePixel = 0
    watermarkFrame.Active = true

    Instance.new("UICorner", watermarkFrame).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", watermarkFrame)
    stroke.Color = Color3.fromRGB(55, 55, 60)
    stroke.Thickness = 1

    watermarkText = Instance.new("TextLabel", watermarkFrame)
    watermarkText.Size = UDim2.new(1, 0, 1, 0)
    watermarkText.Position = UDim2.fromOffset(12, 0)
    watermarkText.BackgroundTransparency = 1
    watermarkText.Text = "Loading..."
    watermarkText.TextColor3 = Color3.new(1, 1, 1)
    watermarkText.Font = Enum.Font.GothamBold
    watermarkText.TextSize = 13
    watermarkText.TextXAlignment = Enum.TextXAlignment.Left
    watermarkText.TextYAlignment = Enum.TextYAlignment.Center

    watermarkFrame.Parent = watermarkGui
    watermarkGui.Parent = CoreGui
end
buildWatermark()

local dragging = false
local dragOffset = Vector2.zero
watermarkFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragOffset = watermarkFrame.AbsolutePosition - UserInputService:GetMouseLocation()
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

local Frames = 0
local LastFrametime = 0

RunService.RenderStepped:Connect(function(dt)
    if dragging then
        local pos = UserInputService:GetMouseLocation() + dragOffset
        watermarkFrame.Position = UDim2.fromOffset(pos.X, pos.Y)
    end
    watermarkGui.Enabled = S.Watermark_Enabled
    Frames = Frames + 1
    LastFrametime = LastFrametime + dt
    if LastFrametime >= 0.5 then
        local fps = math.floor(Frames / LastFrametime)
        local ping = 0
        pcall(function()
            ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        end)
        watermarkText.Text = string.format("%s  |  %d FPS  |  %d MS", LocalPlayer.Name, fps, ping)
        Frames = 0
        LastFrametime = 0
    end
end)

task.defer(function()
    task.wait(0.5)
    wireMiddleClick()
end)

local function ShowNotification(text)
    task.spawn(function()
        local sg = Instance.new("ScreenGui")
        sg.Name = "NotifGUI"
        sg.ResetOnSpawn = false
        sg.DisplayOrder = 999
        sg.IgnoreGuiInset = true
        local f = Instance.new("Frame")
        f.Size = UDim2.new(0, 300, 0, 30)
        f.Position = UDim2.fromOffset(20, 40)
        f.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
        f.BackgroundTransparency = 0.2
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
        local t = Instance.new("TextLabel", f)
        t.Size = UDim2.new(1, 0, 1, 0)
        t.BackgroundTransparency = 1
        t.Text = text
        t.TextColor3 = Color3.new(1, 1, 1)
        t.Font = Enum.Font.Gotham
        t.TextSize = 13
        t.TextWrapped = true
        f.Parent = sg
        sg.Parent = CoreGui
        task.wait(3)
        sg:Destroy()
    end)
end

-- Confirm GUI built ok
task.defer(function()
    task.wait(0.3)
    ShowNotification("SUPREME HUB loaded - Right Shift to toggle menu")
end)

RunService.RenderStepped:Connect(function()
    pcall(function()
        local cam = workspace.CurrentCamera
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
        if not cam then return end

        refreshRayFilter()

        local mousePos = UserInputService:GetMouseLocation()

        FOVCircle.Visible = S.Show_FOV
        if S.Show_FOV then
            FOVCircle.Position = mousePos
            FOVCircle.Radius = S.Aim_FOV
        end

        if S.Fullbright_Enabled then
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.Brightness = 2
        else
            Lighting.Ambient = OriginalAmbient
            Lighting.Brightness = OriginalBrightness
        end

        HideAllESP()
        CleanupStaleESP()
        local now = tick()

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local id = tostring(player.UserId)
                    DrawESP(id, player.Character, hrp, player.Name, player.Team, false)
                    if ESP_Cache[id] then ESP_Cache[id].LastDrawn = now end
                end
            end
        end

        for npc in pairs(Tracked_NPCs) do
            local npcId = GetNPCId(npc)
            if npcId then
                if npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                    local hrp = npc:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        DrawESP(npcId, npc, hrp, npc.Name, nil, true)
                        if ESP_Cache[npcId] then ESP_Cache[npcId].LastDrawn = now end
                    end
                else
                    RemoveNPC(npc)
                end
            end
        end

        if S.Aimbot_Enabled and mousemoverel then
            local aimTarget = GetClosestTarget()
            if aimTarget then
                local aimPos = aimTarget.Position
                if S.Prediction_Enabled then
                    local d = (aimPos - cam.CFrame.Position).Magnitude
                    local speed = math.max(S.Bullet_Speed, MIN_BULLET_SPEED)
                    aimPos = aimPos + (aimTarget.AssemblyLinearVelocity * (d / speed))
                end
                local screenPos, onScreen = cam:WorldToViewportPoint(aimPos)
                if onScreen then
                    local moveX = (screenPos.X - mousePos.X) * S.Aim_Smoothing
                    local moveY = (screenPos.Y - mousePos.Y) * S.Aim_Smoothing
                    mousemoverel(moveX, moveY)
                end
            end
        end
    end)
end)
