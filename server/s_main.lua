



local logs = "your-webhook-here"


local kick_msg = "Hmm, what you wanna do in this inspector?"
local discord_msg = '`Player try to use nui_devtools`\n`and he got a kick`'
local color_msg = 16767235




-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------

function GetLicensesFromPlayer(PlayerServerId)
	local identifiers = GetPlayerIdentifiers(PlayerServerId)
	local Idents = {}
	for _, v in pairs(identifiers) do
		if string.find(v, "steam:") then
			Idents.steam = v
		elseif string.find(v, "license:") then
			Idents.license = v
		elseif string.find(v, "discord:") then
			Idents.discord = v
		elseif string.find(v, "ip:") then
			Idents.ip = v
		end
	end
	return Idents
end


function sendToDiscord (source,message,color,identifier)
	if logs == "your-webhook-here" end
		return
	end
	local name = GetPlayerName(source)
	if not color then
		color = color_msg
	end
	local sendD = {
		{
			["color"] = color,
			["title"] = message,
			["description"] = "`Player`: **"..name.."**\nSteam: **"..identifier.steam.."** \nIP: **"..identifier.ip.."**\nDiscord: **"..identifier.discord.."**\nFivem: **"..identifier.license.."**",
			["footer"] = {
				["text"] = "© QamarQ & vjuton - "..os.date("%x %X %p")
			},
		}
	}
	PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "Devtool Blocker", embeds = sendD}), { ['Content-Type'] = 'application/json' })
end


RegisterServerEvent(GetCurrentResourceName())
AddEventHandler(GetCurrentResourceName(), function()
	local identifier = GetLicensesFromPlayer(source)

	if checkmethod == 'steam' then

		if json.encode(allowlist) == "[]" then
			sendToDiscord (source, discord_msg, color_msg,identifier)
			DropPlayer(source, kick_msg)
			return
		end

		if allowlist then
			local allowed = false
			for _, v in pairs(allowlist) do
				if v == identifier.steam then
					allowed = true
					break
				end
			end

			if not allowed then
				sendToDiscord (source, discord_msg, color_msg,identifier)
				DropPlayer(source, kick_msg)
				return
			end
		end

	elseif checkmethod == 'SQL' then
		local identifierDb = extendedVersionV1Final and identifier.license or identifier.steam
		MySQL.Async.fetchAll("SELECT group FROM users WHERE identifier = @identifier",{['@identifier'] = identifierDb }, function(results)
			if results[1].group ~= 'admin' or results[1].group ~= 'superadmin' then
				sendToDiscord (source, discord_msg, color_msg,identifier)
				DropPlayer(source, kick_msg)
			end
		end)
	end
end)
