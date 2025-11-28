local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local ATTACKER_PANTS_ID = "71322661859196"
local DEFENDER_PANTS_ID = "82267040223924"

local function GetRandomString(length)
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local str = ""
    for i = 1, length do
        local randIndex = math.random(1, #chars)
        str = str .. string.sub(chars, randIndex, randIndex)
    end
    return str
end

local CoreGui = game:GetService("CoreGui")
local SafeContainer = Instance.new("Folder")
SafeContainer.Name = GetRandomString(math.random(10, 20))
SafeContainer.Parent = CoreGui

local Window = Rayfield:CreateWindow({
   Name = "ESP v1.4 | by Varap",
   LoadingTitle = "Loading...",
   ConfigurationSaving = {
      Enabled = true,
      FileName = "ESP_for_The_Lost_Front_Config",
      FolderName = "Rayfield_Configs",
   },
   ToggleUIKeybind = Enum.KeyCode.RightControl,
})

local settings = {
    TeamCheck = false,
    BoxEnabled = true,
    TracersEnabled = false, 
    NameEnabled = false,    
    HealthBarEnabled = true, 
    ShowDistance = true,
    
    AttackerColor = Color3.fromRGB(255, 50, 50),         
    DefenderColor = Color3.fromRGB(50, 150, 255),       
    Thickness = 1,
    
    ChamsEnabled = true,
    FillTransparency = 0.5,
    OutlineTransparency = 0,
}

local VisualsTab = Window:CreateTab("Visuals", "eye")

VisualsTab:CreateSection("General")

VisualsTab:CreateToggle({
   Name = "Team Check",
   CurrentValue = settings.TeamCheck,
   Flag = "ESP_TeamCheck",
   Callback = function(v) settings.TeamCheck = v end,
})

VisualsTab:CreateSection("ESP Elements")

VisualsTab:CreateToggle({
   Name = "Boxes",
   CurrentValue = settings.BoxEnabled,
   Flag = "ESP_Box",
   Callback = function(v) settings.BoxEnabled = v end,
})

VisualsTab:CreateToggle({
   Name = "Tracers (Lines)",
   CurrentValue = settings.TracersEnabled,
   Flag = "ESP_Tracers",
   Callback = function(v) settings.TracersEnabled = v end,
})

VisualsTab:CreateToggle({
   Name = "Player Names",
   CurrentValue = settings.NameEnabled,
   Flag = "ESP_Names",
   Callback = function(v) settings.NameEnabled = v end,
})

VisualsTab:CreateToggle({
   Name = "Health Bar",
   CurrentValue = settings.HealthBarEnabled,
   Flag = "ESP_Health",
   Callback = function(v) settings.HealthBarEnabled = v end,
})

VisualsTab:CreateToggle({
   Name = "Distance (Text)",
   CurrentValue = settings.ShowDistance,
   Flag = "ESP_Distance",
   Callback = function(v) settings.ShowDistance = v end,
})

VisualsTab:CreateSection("Chams Settings")

VisualsTab:CreateToggle({
   Name = "Enable Chams",
   CurrentValue = settings.ChamsEnabled,
   Flag = "Chams_Enabled",
   Callback = function(v) settings.ChamsEnabled = v end,
})

VisualsTab:CreateSlider({
    Name = "Fill Transparency",
    Range = {0, 1},
    Increment = 0.05,
    Suffix = "",
    CurrentValue = settings.FillTransparency,
    Flag = "Chams_Fill",
    Callback = function(v) settings.FillTransparency = v end,
})

VisualsTab:CreateSlider({
    Name = "Outline Transparency",
    Range = {0, 1},
    Increment = 0.05,
    Suffix = "",
    CurrentValue = settings.OutlineTransparency,
    Flag = "Chams_Outline",
    Callback = function(v) settings.OutlineTransparency = v end,
})

local ColorsTab = Window:CreateTab("Colors", "palette")

ColorsTab:CreateSection("Team Appearance")

ColorsTab:CreateColorPicker({
    Name = "Attackers Color",
    Color = settings.AttackerColor,
    Flag = "Col_Attacker",
    Callback = function(v) settings.AttackerColor = v end,
})

ColorsTab:CreateColorPicker({
    Name = "Defenders Color",
    Color = settings.DefenderColor,
    Flag = "Col_Defender",
    Callback = function(v) settings.DefenderColor = v end,
})

local PlayersTab = Window:CreateTab("Players", "user")

local InfoParagraph = PlayersTab:CreateParagraph({Title = "Player Info", Content = "Select a player from the list below."})

local function GetTeamNameString(player)
    if not player.Character then return "No Character (Dead/Loading)" end
    
    local pants = player.Character:FindFirstChildWhichIsA("Pants")
    if pants then
        local template = tostring(pants.PantsTemplate)
        if string.find(template, ATTACKER_PANTS_ID) then
            return "Attackers"
        elseif string.find(template, DEFENDER_PANTS_ID) then
            return "Defenders"
        end
    end
    
    return "Lobby / Unknown"
end

local function GetPlayerDevice(player)
    local devObj = player:FindFirstChild("device")
    if devObj then
        if devObj:IsA("StringValue") then
            return devObj.Value
        else
            return tostring(devObj)
        end
    end
    return "Unknown"
end

local PlayerDropdown = PlayersTab:CreateDropdown({
    Name = "Select Player",
    Options = {},
    CurrentOption = "",
    MultipleOptions = false,
    
    Callback = function(Option)
        local selectedName = Option[1]
        local player = game:GetService("Players"):FindFirstChild(selectedName)
        
        if player then
            local age = player.AccountAge
            local userId = player.UserId
            local teamName = GetTeamNameString(player)
            local device = GetPlayerDevice(player)
            
            InfoParagraph:Set({
                Title = player.DisplayName .. " (@" .. player.Name .. ")",
                Content = "Account Age: " .. age .. " days\nTeam: " .. teamName .. "\nDevice: " .. device .. "\nUserID: " .. userId
            })
        else
            InfoParagraph:Set({Title = "Error", Content = "Player left or not found."})
        end
    end,
})

local function UpdatePlayerList()
    local pList = {}
    for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
        table.insert(pList, p.Name)
    end
    PlayerDropdown:Refresh(pList)
end

game:GetService("Players").PlayerAdded:Connect(UpdatePlayerList)
game:GetService("Players").PlayerRemoving:Connect(UpdatePlayerList)
UpdatePlayerList()

PlayersTab:CreateButton({
    Name = "Refresh List",
    Callback = UpdatePlayerList
})

local InfoTab = Window:CreateTab("Info", "info")

InfoTab:CreateSection("Credits")

InfoTab:CreateParagraph({Title = "Developer", Content = "Discord: varap228"})

InfoTab:CreateButton({
    Name = "Copy Discord Username",
    Callback = function()
        setclipboard("varap228")
        Rayfield:Notify({
            Title = "Success",
            Content = "Discord username copied to clipboard!",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

InfoTab:CreateSection("Update Log")


InfoTab:CreateParagraph({
    Title = "v1.4",
    Content = "- Added Team Check"
})

InfoTab:CreateParagraph({
    Title = "v1.3",
    Content = "- Added Info Tab & Discord Copy\n- CoreGui Highlight Support"
})

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

local espCache = {}

local function GetTeamColor(character)
    local pants = character:FindFirstChildWhichIsA("Pants")
    
    if pants then
        local template = tostring(pants.PantsTemplate)
        if string.find(template, ATTACKER_PANTS_ID) then
            return settings.AttackerColor, true, "Attackers"
        elseif string.find(template, DEFENDER_PANTS_ID) then
            return settings.DefenderColor, true, "Defenders"
        end
    end
    
    return Color3.new(1,1,1), false, "Lobby"
end

local function handleHighlight(player, character, color)
    if not espCache[player] then espCache[player] = {} end
    
    local highlight = espCache[player].Highlight
    
    if highlight and highlight.Adornee == character then
        highlight.FillColor = color
        highlight.OutlineColor = color
        highlight.Enabled = settings.ChamsEnabled
        return
    end
    
    if highlight then highlight:Destroy() end

    highlight = Instance.new("Highlight")
    highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    highlight.Enabled = settings.ChamsEnabled
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.FillTransparency = settings.FillTransparency
    highlight.OutlineTransparency = settings.OutlineTransparency
    
    highlight.Parent = SafeContainer
    highlight.Adornee = character
    
    espCache[player].Highlight = highlight
end

local function createEspCache(player)
    if espCache[player] then return end
    espCache[player] = {}
    
    local box = Drawing.new("Square")
    box.Visible = false
    box.Thickness = 1
    box.Filled = false
    espCache[player].Box = box

    local tracer = Drawing.new("Line")
    tracer.Visible = false
    tracer.Thickness = 1
    espCache[player].Tracer = tracer

    local name = Drawing.new("Text")
    name.Visible = false
    name.Center = true
    name.Outline = true
    name.Font = 2
    name.Size = 13
    espCache[player].NameText = name

    local dist = Drawing.new("Text")
    dist.Visible = false
    dist.Center = true
    dist.Outline = true
    dist.Font = 2
    dist.Size = 13
    espCache[player].DistanceText = dist

    local hpBarBg = Drawing.new("Square")
    hpBarBg.Visible = false
    hpBarBg.Filled = true
    hpBarBg.Color = Color3.new(0,0,0)
    hpBarBg.Transparency = 0.5
    espCache[player].HP_BG = hpBarBg

    local hpBar = Drawing.new("Square")
    hpBar.Visible = false
    hpBar.Filled = true
    hpBar.Color = Color3.new(0,1,0)
    espCache[player].HP_Bar = hpBar
end

local function removeEsp(player)
    if espCache[player] then
        for _, obj in pairs(espCache[player]) do
            if typeof(obj) == "Instance" then obj:Destroy() else obj:Remove() end
        end
        espCache[player] = nil
    end
end

RunService:BindToRenderStep("ESP_Update", Enum.RenderPriority.Camera.Value, function()
    local myTeam = "Lobby"
    if localPlayer.Character then
        local _, _, tName = GetTeamColor(localPlayer.Character)
        myTeam = tName
    end

    for player, cache in pairs(espCache) do
        local character = player.Character
        
        if character and character.Parent and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
            
            local currentColor, isInTeam, targetTeam = GetTeamColor(character)
            
            if not isInTeam then
                for _, obj in pairs(cache) do
                    if typeof(obj) ~= "Instance" then obj.Visible = false end
                    if typeof(obj) == "Instance" and obj:IsA("Highlight") then obj.Enabled = false end
                end
                continue 
            end

            if settings.TeamCheck and targetTeam == myTeam and myTeam ~= "Lobby" then
                for _, obj in pairs(cache) do
                    if typeof(obj) ~= "Instance" then obj.Visible = false end
                    if typeof(obj) == "Instance" and obj:IsA("Highlight") then obj.Enabled = false end
                end
                continue
            end

            local rootPart = character.HumanoidRootPart
            local hum = character.Humanoid
            
            local screenPos, onScreen = camera:WorldToViewportPoint(rootPart.Position)

            if onScreen then
                local scaleFactor = 750 / screenPos.Z
                local sizeY = 5 * scaleFactor
                local sizeX = sizeY * 0.6
                local boxPos = Vector2.new(screenPos.X - sizeX / 2, screenPos.Y - sizeY / 2)

                if settings.BoxEnabled then
                    cache.Box.Size = Vector2.new(sizeX, sizeY)
                    cache.Box.Position = boxPos
                    cache.Box.Color = currentColor
                    cache.Box.Visible = true
                else
                    cache.Box.Visible = false
                end

                if settings.TracersEnabled then
                    cache.Tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                    cache.Tracer.To = Vector2.new(screenPos.X, screenPos.Y + sizeY/2)
                    cache.Tracer.Color = currentColor
                    cache.Tracer.Visible = true
                else
                    cache.Tracer.Visible = false
                end

                if settings.NameEnabled then
                    cache.NameText.Text = player.Name
                    cache.NameText.Position = Vector2.new(screenPos.X, boxPos.Y - 16)
                    cache.NameText.Color = currentColor
                    cache.NameText.Visible = true
                else
                    cache.NameText.Visible = false
                end

                if settings.ShowDistance then
                    local dist = (camera.CFrame.Position - rootPart.Position).Magnitude
                    cache.DistanceText.Text = math.floor(dist) .. "m"
                    cache.DistanceText.Position = Vector2.new(screenPos.X, boxPos.Y + sizeY + 2)
                    cache.DistanceText.Color = currentColor
                    cache.DistanceText.Visible = true
                else
                    cache.DistanceText.Visible = false
                end

                if settings.HealthBarEnabled then
                    local hpPercent = hum.Health / hum.MaxHealth
                    local barHeight = sizeY * hpPercent
                    
                    cache.HP_BG.Size = Vector2.new(2, sizeY)
                    cache.HP_BG.Position = Vector2.new(boxPos.X - 5, boxPos.Y)
                    cache.HP_BG.Visible = true

                    cache.HP_Bar.Size = Vector2.new(2, barHeight)
                    cache.HP_Bar.Position = Vector2.new(boxPos.X - 5, boxPos.Y + (sizeY - barHeight))
                    cache.HP_Bar.Color = Color3.fromHSV(hpPercent * 0.3, 1, 1)
                    cache.HP_Bar.Visible = true
                else
                    cache.HP_BG.Visible = false
                    cache.HP_Bar.Visible = false
                end

            else
                for _, obj in pairs(cache) do
                    if typeof(obj) ~= "Instance" then obj.Visible = false end
                end
            end

            handleHighlight(player, character, currentColor)
            if cache.Highlight then
                cache.Highlight.FillTransparency = settings.FillTransparency
                cache.Highlight.OutlineTransparency = settings.OutlineTransparency
            end

        else
            for _, obj in pairs(cache) do
                if typeof(obj) ~= "Instance" then obj.Visible = false end
                if typeof(obj) == "Instance" and obj:IsA("Highlight") then obj.Enabled = false end
            end
        end
    end
end)

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= localPlayer then createEspCache(player) end
end

Players.PlayerAdded:Connect(createEspCache)
Players.PlayerRemoving:Connect(removeEsp)

Rayfield:LoadConfiguration()
