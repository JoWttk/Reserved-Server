local isReservedServer = game.PrivateServerId ~= "" and game.PrivateServerOwnerId == 0

if isReservedServer then
	print("Servidor RESERVADO")
else
	print("Servidor público ou VIP")
end
