--[[
    Script Name: AdminGuiEnhanced
    Description: Creates a functional admin GUI based on the provided image, now with a minimize button.
    Environment: Roblox (LocalScript)
    Language: Lua
--]]

-- Services
local COREGUI = cloneref(game:GetService("CoreGui"))
local Players = cloneref(game:GetService("Players"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local TweenService = cloneref(game:GetService("TweenService"))
local HttpService = cloneref(game:GetService("HttpService"))
local MarketplaceService = cloneref(game:GetService("MarketplaceService"))
local RunService = cloneref(game:GetService("RunService"))
local TeleportService = cloneref(game:GetService("TeleportService"))
local StarterGui = cloneref(game:GetService("StarterGui"))
local GuiService = cloneref(game:GetService("GuiService"))
local Lighting = cloneref(game:GetService("Lighting"))
local ContextActionService = cloneref(game:GetService("ContextActionService"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local GroupService = cloneref(game:GetService("GroupService") or game:GetService("GroupService")) -- Fallback for older Roblox versions
local PathService = cloneref(game:GetService("PathfindingService"))
local SoundService = cloneref(game:GetService("SoundService"))
local Teams = cloneref(game:GetService("Teams"))
local StarterPlayer = cloneref(game:GetService("StarterPlayer"))
local InsertService = cloneref(game:GetService("InsertService"))
local ChatService = cloneref(game:GetService("Chat"))
local ProximityPromptService = cloneref(game:GetService("ProximityPromptService"))
local ContentProvider = cloneref(game:GetService("ContentProvider"))
local StatsService = cloneref(game:GetService("Stats"))
local MaterialService = cloneref(game:GetService("MaterialService"))
local AvatarEditorService = cloneref(game:GetService("AvatarEditorService"))
local TextService = cloneref(game:GetService("TextService"))
local TextChatService = cloneref(game:GetService("TextChatService"))
local CaptureService = cloneref(game:GetService("CaptureService"))
local VoiceChatService = cloneref(game:GetService("VoiceChatService"))
local IYMouse = cloneref(Players.LocalPlayer:GetMouse())
local PlayerGui = cloneref(Players.LocalPlayer:FindFirstChildWhichIsA("PlayerGui"))

-- Player and GUI setup
local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Configuration for the theme (colors, fonts, etc.)
local theme = {
    BackgroundColor = Color3.fromRGB(35, 35, 35),
    SecondaryColor = Color3.fromRGB(45, 45, 45),
    TertiaryColor = Color3.fromRGB(28, 28, 28),
    AccentColor = Color3.fromRGB(220, 20, 60), -- Red for the selected item underline
    TextColor = Color3.fromRGB(240, 240, 240),
    MutedTextColor = Color3.fromRGB(180, 180, 180),
    Font = Enum.Font.SourceSans,
    Title = "Jawa Hub | Version: 1.0.0"
}

-- Clean up any existing GUI to prevent duplicates
if PlayerGui:FindFirstChild("AdminScreenGui") then
    PlayerGui.AdminScreenGui:Destroy()
end

-- 1. Main GUI Container
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdminScreenGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = PlayerGui

-- 2. Main Window Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
local originalSize = UDim2.new(0, 600, 0, 400) -- Simpan ukuran asli
mainFrame.Size = originalSize
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.BackgroundColor3 = theme.BackgroundColor
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true -- Allows the window to be moved
mainFrame.ClipsDescendants = true -- Ensures child elements don't go outside the frame
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- 3. Top Bar (for Title and Buttons)
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 35)
topBar.BackgroundColor3 = theme.TertiaryColor
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -80, 1, 0) -- Beri ruang untuk 2 tombol
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.Text = theme.Title
titleLabel.TextColor3 = theme.TextColor
titleLabel.Font = theme.Font
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.BackgroundTransparency = 1
titleLabel.Parent = topBar

-- Tombol Tutup (Close)
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 35, 1, 0)
closeButton.Position = UDim2.new(1, -35, 0, 0) -- Posisi paling kanan
closeButton.Text = "X"
closeButton.TextColor3 = theme.TextColor
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 18
closeButton.BackgroundColor3 = theme.TertiaryColor
closeButton.BorderSizePixel = 0
closeButton.Parent = topBar

closeButton.MouseEnter:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.2), {BackgroundColor3 = theme.AccentColor}):Play()
end)
closeButton.MouseLeave:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.2), {BackgroundColor3 = theme.TertiaryColor}):Play()
end)
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Tombol Minimize
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 35, 1, 0)
minimizeButton.Position = UDim2.new(1, -70, 0, 0) -- Posisi di kiri tombol close
minimizeButton.Text = "–" -- Karakter minus panjang
minimizeButton.TextColor3 = theme.TextColor
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.TextSize = 20
minimizeButton.BackgroundColor3 = theme.TertiaryColor
minimizeButton.BorderSizePixel = 0
minimizeButton.Parent = topBar

minimizeButton.MouseEnter:Connect(function()
    TweenService:Create(minimizeButton, TweenInfo.new(0.2), {BackgroundColor3 = theme.AccentColor}):Play()
end)
minimizeButton.MouseLeave:Connect(function()
    TweenService:Create(minimizeButton, TweenInfo.new(0.2), {BackgroundColor3 = theme.TertiaryColor}):Play()
end)

-- 4. Main Content Area (Container for Sidebar and Pages)
local mainContent = Instance.new("Frame")
mainContent.Name = "MainContent"
mainContent.Size = UDim2.new(1, 0, 1, -35)
mainContent.Position = UDim2.new(0, 0, 0, 35)
mainContent.BackgroundTransparency = 1
mainContent.Parent = mainFrame

-- Logika untuk Minimize/Restore
local isMinimized = false
minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized -- Toggle status

    local goalSize
    if isMinimized then
        goalSize = UDim2.new(originalSize.X.Scale, 220, 0, topBar.Size.Y.Offset)
        mainContent.Visible = false
    else
        goalSize = originalSize
        mainContent.Visible = true
    end
    
    -- Animasi perubahan ukuran
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(mainFrame, tweenInfo, {Size = goalSize})
    tween:Play()
end)


-- 5. Sidebar (Left Navigation)
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 160, 1, 0)
sidebar.BackgroundColor3 = theme.SecondaryColor
sidebar.BorderSizePixel = 0
sidebar.Parent = mainContent

local sidebarLayout = Instance.new("UIListLayout")
sidebarLayout.Padding = UDim.new(0, 5)
sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
sidebarLayout.Parent = sidebar

-- 6. Content Frame (Right side where pages are shown)
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -160, 1, 0)
contentFrame.Position = UDim2.new(0, 160, 0, 0)
contentFrame.BackgroundColor3 = theme.BackgroundColor
contentFrame.BorderSizePixel = 0
contentFrame.ClipsDescendants = true
contentFrame.Parent = mainContent

local contentPadding = Instance.new("UIPadding")
contentPadding.PaddingTop = UDim.new(0, 10)
contentPadding.PaddingLeft = UDim.new(0, 15)
contentPadding.PaddingRight = UDim.new(0, 15)
contentPadding.Parent = contentFrame

-- Data for Navigation Buttons
local navButtonsData = {
    {Name = "Home", Icon = "rbxassetid://5107921325"}, -- Example Icon ID
    {Name = "Main", Icon = "rbxassetid://5107921325"},
    {Name = "Automatically", Icon = "rbxassetid://5107921325"},
    {Name = "Inventory", Icon = "rbxassetid://5107921325"},
    {Name = "Shop", Icon = "rbxassetid://5107921325"},
    {Name = "Quests", Icon = "rbxassetid://5107921325"},
    {Name = "Teleport", Icon = "rbxassetid://5107921325"},
    {Name = "Webhook", Icon = "rbxassetid://5107921325"},
}
local pageFrames = {}
local activeTab = nil

-- Function to switch between pages
local function switchPage(pageName)
    for name, frame in pairs(pageFrames) do
        frame.Visible = (name == pageName)
    end
    -- Update button appearance
    for _, button in ipairs(sidebar:GetChildren()) do
        if button:IsA("TextButton") then
            local indicator = button:FindFirstChild("Indicator")
            if button.Name == pageName .. "Button" then
                button.BackgroundColor3 = theme.TertiaryColor
                if indicator then indicator.Visible = true end
            else
                button.BackgroundColor3 = theme.SecondaryColor
                if indicator then indicator.Visible = false end
            end
        end
    end
    activeTab = pageName
end

-- 7. Create Navigation Buttons and their corresponding Pages
for i, data in ipairs(navButtonsData) do
    local name = data.Name
    
    local navButton = Instance.new("TextButton")
    navButton.Name = name .. "Button"
    navButton.Size = UDim2.new(1, -10, 0, 40)
    navButton.Text = "   | " .. name
    navButton.TextColor3 = theme.TextColor
    navButton.Font = theme.Font
    navButton.TextSize = 16
    navButton.TextXAlignment = Enum.TextXAlignment.Left
    navButton.BackgroundColor3 = theme.SecondaryColor
    navButton.BorderSizePixel = 0
    navButton.LayoutOrder = i
    navButton.Parent = sidebar
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = navButton
    
    -- Red indicator for selected tab
    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.Size = UDim2.new(0, 3, 1, 0)
    indicator.BackgroundColor3 = theme.AccentColor
    indicator.BorderSizePixel = 0
    indicator.Visible = false
    indicator.Parent = navButton

    -- Page creation
    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "Page"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.Visible = false
    page.CanvasSize = UDim2.new(0, 0, 0, 0) -- Auto-sizing canvas
    page.ScrollBarThickness = 5
    page.Parent = contentFrame
    pageFrames[name] = page
    
    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Padding = UDim.new(0, 10)
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Parent = page
    
    local pageTitle = Instance.new("TextLabel")
    pageTitle.Name = "PageTitle"
    pageTitle.Size = UDim2.new(1, 0, 0, 30)
    pageTitle.Text = "| " .. name
    pageTitle.Font = Enum.Font.SourceSansBold
    pageTitle.TextSize = 28
    pageTitle.TextColor3 = theme.TextColor
    pageTitle.TextXAlignment = Enum.TextXAlignment.Left
    pageTitle.BackgroundTransparency = 1
    pageTitle.LayoutOrder = 0
    pageTitle.Parent = page

    navButton.MouseButton1Click:Connect(function()
        switchPage(name)
    end)
end

--== Function ==--
local toggles = { EnableFlight = false, EnableWalkSpeed = false }
local options = { FlightSpeed = 50, WalkSpeed = 50 }
local originalWalkSpeed = 16

function handleFlight()
	while toggles.EnableFlight do
		local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
		local hrp = character and character:FindFirstChild("HumanoidRootPart")
		if hrp then
			local moveDirection = Vector3.new(0, 0, 0)
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then
				moveDirection += camera.CFrame.LookVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then
				moveDirection -= camera.CFrame.LookVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then
				moveDirection -= camera.CFrame.RightVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then
				moveDirection += camera.CFrame.RightVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
				moveDirection += camera.CFrame.UpVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
				moveDirection -= camera.CFrame.UpVector
			end

			hrp.Velocity = moveDirection.Magnitude > 0 and moveDirection.Unit * options.FlightSpeed or Vector3.zero
		end
		task.wait()
	end
end

-- Mendapatkan kecepatan jalan asli pemain saat karakter dimuat
localPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    originalWalkSpeed = humanoid.WalkSpeed
    -- Jika kecepatan jalan diaktifkan sebelum respawn, terapkan kembali
    if toggles.EnableWalkSpeed then
        humanoid.WalkSpeed = options.WalkSpeed
    end
end)

function handleWalkSpeed()
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        if toggles.EnableWalkSpeed then
            originalWalkSpeed = humanoid.WalkSpeed 
            humanoid.WalkSpeed = options.WalkSpeed
            print("WalkSpeed diatur ke: " .. options.WalkSpeed)
        else
            humanoid.WalkSpeed = originalWalkSpeed 
            print("WalkSpeed diatur kembali ke: " .. originalWalkSpeed)
        end
    else
        warn("Humanoid tidak ditemukan di karakter.")
        -- Jika humanoid tidak ditemukan, pastikan status toggle dan UI mencerminkan ini
        toggles.EnableWalkSpeed = false
    end
end

-- 8. Customize the "Home" page as per the image
local homePage = pageFrames["Home"]

-- Helper function to create interactive buttons
local function createInteractiveButton(parent, text, subtext, layoutOrder)
    local button = Instance.new("TextButton")
    button.Name = text .. "Button"
    button.Size = UDim2.new(1, 0, 0, 50)
    button.BackgroundColor3 = theme.SecondaryColor
    button.BorderSizePixel = 0
    button.Text = ""
    button.LayoutOrder = layoutOrder
    button.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -30, 0.5, 0)
    title.Position = UDim2.new(0, 15, 0.1, 0)
    title.Text = text
    title.Font = theme.Font
    title.TextSize = 16
    title.TextColor3 = theme.TextColor
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.Parent = button

    if subtext then
        local subtitle = Instance.new("TextLabel")
        subtitle.Size = UDim2.new(1, -30, 0.5, 0)
        subtitle.Position = UDim2.new(0, 15, 0.5, 0)
        subtitle.Text = subtext
        subtitle.Font = theme.Font
        subtitle.TextSize = 12
        subtitle.TextColor3 = theme.MutedTextColor
        subtitle.TextXAlignment = Enum.TextXAlignment.Left
        subtitle.BackgroundTransparency = 1
        subtitle.Parent = button
    end
    
    return button
end

-- Create Fly Button
local localFlyButton = createInteractiveButton(homePage, "Flying", "You can activate it by pressing J/this botton", 3)
local flyIcon = Instance.new("TextLabel")
flyIcon.Size = UDim2.new(0, 20, 1, 0)
flyIcon.Position = UDim2.new(1, -35, 0, 0)
flyIcon.Text = "OFF"
flyIcon.Font = Enum.Font.SourceSansBold
flyIcon.TextSize = 16
flyIcon.TextColor3 = theme.MutedTextColor
flyIcon.BackgroundTransparency = 1
flyIcon.Parent = localFlyButton

localFlyButton.MouseButton1Click:Connect(function()
    toggles.EnableFlight = not toggles.EnableFlight
    flyIcon.Text = (flyIcon.Text == "OFF" and "ON" or "OFF")
    flyIcon.TextColor3 = flyIcon.Text == "ON" and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(80, 80, 80)
    if toggles.EnableFlight then
        task.spawn(handleFlight)
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.J then
		toggles.EnableFlight = not toggles.EnableFlight
        flyIcon.Text = (flyIcon.Text == "OFF" and "ON" or "OFF")
        flyIcon.TextColor3 = flyIcon.Text == "ON" and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(80, 80, 80)
		if toggles.EnableFlight then
			task.spawn(handleFlight)
		end
	end
end)

-- Create Walk Speed Button
local localWalkSpeedButton = createInteractiveButton(homePage, "Walk Speed", "You can walk faster", 4)
local walkSpeedIcon = Instance.new("TextLabel")
walkSpeedIcon.Size = UDim2.new(0, 20, 1, 0)
walkSpeedIcon.Position = UDim2.new(1, -35, 0, 0)
walkSpeedIcon.Text = "OFF"
walkSpeedIcon.Font = Enum.Font.SourceSansBold
walkSpeedIcon.TextSize = 16
walkSpeedIcon.TextColor3 = theme.MutedTextColor
walkSpeedIcon.BackgroundTransparency = 1
walkSpeedIcon.Parent = localWalkSpeedButton

localWalkSpeedButton.MouseButton1Click:Connect(function()
    toggles.EnableWalkSpeed = not toggles.EnableWalkSpeed
    walkSpeedIcon.Text = (walkSpeedIcon.Text == "OFF" and "ON" or "OFF")
    walkSpeedIcon.TextColor3 = walkSpeedIcon.Text == "ON" and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(80, 80, 80)
    
    handleWalkSpeed()
end)

-- 9. Initialize by showing the "Home" page by default
switchPage("Home")
