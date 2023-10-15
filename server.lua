QBCore = exports['qb-core']:GetCoreObject()

local logolsunmu = true -- log sistemini kullanmak istemiyor iseniz false yapmanız yeterlidir.

local webhook = "webhookhere"

QBCore.Commands.Add("magictest", "Magic bullet test", {{name="id", help="Oyunucun İD'si"}}, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
    local target = args[1]
	if Player ~= nil then
        TriggerClientEvent("magic:start", target)
    else
		TriggerClientEvent('QBCore:Notify', source,  "ID Bulunamadı!", "error")
	end
end, "admin")

RegisterNetEvent('yolver')
AddEventHandler('yolver', function()
    local src = source
    SendDiscord(src, subject, description, 0000000)
    DropPlayer(src, "Magic bullet algılandı")
end)

function ExtractIdentifiers(src)
    local identifiers = {
        steam = "N/A",
        ip = "N/A",
        discord = "N/A",
        license = "N/A",
        xbl = "N/A",
        live = "N/A",
        tokens = "N/A",
        fivem = "N/A"
    }
    
    for k,v in ipairs(GetPlayerIdentifiers(src)) do
        if v:match("^steam:") then
            identifiers.steam = v
        elseif v:match("^license:") then
            identifiers.license = v
        elseif v:match("^live:") then
            identifiers.live = v
        elseif v:match("^xbl:") then
            identifiers.xbl  = v
        elseif v:match("^discord:") then
            identifiers.discord = v
        elseif v:match("^ip:") then
            identifiers.ip = v
        elseif v:match("^fivem:") then
            identifiers.fivem = v
        end
    end

    for i = 0, GetNumPlayerTokens(src) - 1 do 
        identifiers.tokens = GetPlayerToken(src, i)
    end

    return identifiers
end

function SendDiscord(source,title,des,color)
    if GetPlayerName(source) == nil or webhook == "" or logolsunmu == false then
        return
    end

    local id = ExtractIdentifiers(source);
    
    embed = {{
        ["author"] = {
            ["name"] = "Magic Bullet Log",
            ["icon_url"] = "https://cdn.discordapp.com/icons/846918734718566420/dc1fd8d634a75a1bf0896ff35a7d94db.webp?size=96",
            ["url"] = "https://discord.gg/wilddev"
        },
        ["color"] = color,
        ["fields"] = {
            { ["name"] = "Kullanıcı Bilgileri", ["value"] = "\n**Name:** "..GetPlayerName(source).."\n**Ingame ID:** "..source.."\n**Ping:** "..GetPlayerPing(source).."\n**IP:** "..string.gsub(id.ip, "ip:", "").."\n**Steam:** "..id.steam.."\n**FiveM:** "..id.fivem.."\n**License:** "..id.license.."\n**Token:** ".. id.tokens .."\n**Discord:** <@!"..string.gsub(id.discord, "discord:", "")..">\n**XBL:** "..id.xbl.."\n**Live:** "..id.live, ["inline"] = true },
            { ["name"] = "Server İsmi", ["value"] = "```"..GetConvar("sv_hostname").."```" }
        },
        ["footer"] = {
            ["text"] = "https://discord.gg/wilddev",
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }
        
    }}

    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({embeds  = embed}), { ['Content-Type'] = 'application/json' })
end