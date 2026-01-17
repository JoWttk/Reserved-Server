local ProximityPromptService = game.ProximityPromptService
task.wait(1)
local Module = require(script.Parent.Modules.ReservedServerModule)

ProximityPromptService.PromptTriggered:Connect(function(prompt, player)
	if prompt.Name == "JoinReserveServer" then
		Module.Join(player)
	elseif prompt.Name == "CreateReserveServer" then
		Module.Create(player)
	end
end)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Teleport = game:GetService("TeleportService")
local Memory = game:GetService("MemoryStoreService")
local Store = Memory:GetSortedMap("ReservedServer")

local TeleportEvent = Instance.new("RemoteEvent")
TeleportEvent.Name = "TeleportToReserved"
TeleportEvent.Parent = ReplicatedStorage

local ErrorEvent = Instance.new("RemoteEvent")
ErrorEvent.Name = "TeleportError"
ErrorEvent.Parent = ReplicatedStorage

TeleportEvent.OnServerEvent:Connect(function(player, code)
	local success, serverId = pcall(function()
		return Store:GetAsync("CODE_" .. tostring(code))
	end)

	if success and serverId then
		Teleport:TeleportToPrivateServer(game.PlaceId, serverId, {player})
	else
		ErrorEvent:FireClient(player, "Código Inválido")
	end
end)