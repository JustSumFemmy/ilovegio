--// Settings
getgenv().Wait = getgenv().Wait or 0.25
getgenv().PlaceId = 46955756

--// Services
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

--// Wait for game to load
if not game:IsLoaded() then
    game.Loaded:Wait()
end

--// Auto execute on teleport
local scriptURL = "https://raw.githubusercontent.com/JustSumFemmy/ilovegio/main/script.lua"

if syn and syn.queue_on_teleport then
    syn.queue_on_teleport(game:HttpGet(scriptURL))
elseif queue_on_teleport then
    queue_on_teleport(game:HttpGet(scriptURL))
end

--// Safe invoke
local function safeInvoke(remote, ...)
    if remote then
        pcall(function()
            remote:InvokeServer(...)
        end)
    end
end

--// Rejoin function
local function rejoin()
    task.wait(2)
    TeleportService:Teleport(getgenv().PlaceId, LocalPlayer)
end

--// Detect failed teleports
LocalPlayer.OnTeleport:Connect(function(state)
    if state == Enum.TeleportState.Failed then
        rejoin()
    end
end)

--// Detect kicks / errors
game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
    if child.Name == "ErrorPrompt" then
        rejoin()
    end
end)

--// Main
if game.PlaceId ~= getgenv().PlaceId then
    local winnerRemote = workspace:FindFirstChild("Winner")
    safeInvoke(winnerRemote)

    task.wait(1)
    TeleportService:Teleport(getgenv().PlaceId)
else
    local skipVote = workspace:FindFirstChild("SkipWaitVote")
    local buyZombie = workspace:FindFirstChild("BuyZombie")
    local makeZombie = workspace:FindFirstChild("Make")

    safeInvoke(skipVote)

    while task.wait(getgenv().Wait) do
        pcall(function()
            safeInvoke(buyZombie, "Speedy")
            safeInvoke(makeZombie, "Speedy")
        end)
    end
end
