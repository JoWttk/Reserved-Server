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

-- improvisado

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Teleport = game:GetService("TeleportService")
local Store = game:GetService("DataStoreService"):GetDataStore("ReservedServer")

local TeleportEvent = Instance.new("RemoteEvent")
TeleportEvent.Name = "TeleportToReserved"
TeleportEvent.Parent = ReplicatedStorage

local ErrorEvent = Instance.new("RemoteEvent")
ErrorEvent.Name = "TeleportError"
ErrorEvent.Parent = ReplicatedStorage

TeleportEvent.OnServerEvent:Connect(function(player, code)
	local serverId = Store:GetAsync("CODE_" .. tostring(code))

	if serverId and type(serverId) == "string" then
		Teleport:TeleportToPrivateServer(game.PlaceId, serverId, {player})
	else
		ErrorEvent:FireClient(player, "C�digo Inv�lido")
	end
end)