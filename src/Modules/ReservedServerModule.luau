local ReservedServerModule = {}

local Config = require(script.Parent:WaitForChild("Config"))
local UI = script.Parent.Parent:WaitForChild("UI")

local Teleport = game:GetService("TeleportService")
local Memory = game:GetService("MemoryStoreService")
local Store = Memory:GetSortedMap("ReservedServer")

local PLACE_ID = game.PlaceId
local EXPIRATION_TIME = 4 * 60 * 60

function ReservedServerModule.Create(Player: Player)
	if not Config.CheckRanks(Player) then return end
	if Player.PlayerGui:FindFirstChild("CreateServer") then return end

	local CreateTrainingUI = UI:WaitForChild("CreateServer"):Clone()
	CreateTrainingUI.Parent = Player.PlayerGui
	CreateTrainingUI.Enabled = true

	local Main = CreateTrainingUI.Main

	Main.Generate.MouseButton1Click:Connect(function()
		local RandomCode = tostring(math.random(1000, 9999))
		Main.Generate.Visible = false
		Main.Ok.Visible = true
		Main.Code.Text = RandomCode

		task.spawn(function()
			local success, serverId = pcall(function()
				return Teleport:ReserveServerAsync(PLACE_ID)
			end)

			if success then
				pcall(function()
					Store:SetAsync("CODE_" .. RandomCode, serverId, EXPIRATION_TIME)
				end)
			else
				warn("Erro ao reservar servidor:", serverId)
			end
		end)
	end)

	Main.Ok.MouseButton1Click:Connect(function()
		CreateTrainingUI:Destroy()
	end)

	Main.Close.MouseButton1Click:Connect(function()
		CreateTrainingUI:Destroy()
	end)
end

function ReservedServerModule.Join(Player: Player)
	local CodeGui = UI:WaitForChild("JoinServer"):Clone()
	CodeGui.Parent = Player.PlayerGui
	CodeGui.Enabled = true

	local Main = CodeGui.Main
	local Box = Main.Code

	Main.Close.MouseButton1Click:Connect(function()
		CodeGui:Destroy()
	end)
end

return ReservedServerModule