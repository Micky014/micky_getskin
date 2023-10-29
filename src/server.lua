------------------------
--====== Config ======--
------------------------

-- Discord Webhook URL for send skin
local DiscordWebhook = ''

-- Configure here the clothes you want to be sent in the WebHook
local Clothes = {
    'tshirt_1',    'tshirt_2',
    'torso_1',     'torso_2',
    'arms',        'arms_2',
    'pants_1',     'pants_2', 
    'shoes_1',     'shoes_2',
    'mask_1',      'mask_2',
    'chain_1',     'chain_2',
    'helmet_1',    'helmet_2',
    'ears_1',      'ears_2',
    'bags_1',      'bags_2',
    'glasses_1',   'glasses_2',
    'bracalets_1', 'bracalets_2',
    'watches_1',   'watches_2'
}

------------------------
--====== Script ======--
------------------------

RegisterCommand('getskin', function(src, args, raw)
    if src == 0 then 
        return print('only players can use this command')
    end

    if args[1] then
        ubi = table.concat(args, ' ')
        title = 'Get Skin - '..ubi
    end

    title = title or 'Get Skin'

    TriggerClientEvent('micky_getskin:getSkin', src, title)
end, false)

RegisterServerEvent('micky_getskin:sendSkin', function(skin, title)
    local playerName = GetPlayerName(source)
    local playerClothes = ''

    for k,v in pairs(Clothes) do
        if skin[v] then
            if v:find('_1') or v == 'arms' then
                playerClothes = playerClothes..'[\''..v..'\'] = '..skin[v]..','..GetNeedSpaces(v, skin[v])
            elseif v:find('_2') then
                playerClothes = playerClothes..'[\''..v..'\'] = '..skin[v]..',\n'
            else
                playerClothes = playerClothes..'[\''..v..'\'] = '..skin[v]..',\n'
            end
        end
    end

    embed = {
        author = { name = playerName },
        title = title,
        description = '```lua\n'..playerClothes..'```'
    }

    SendWebhook(embed)
end)

function SendWebhook(embed)
    PerformHttpRequest(DiscordWebhook, function(err, text, headers) 
        if err ~= 204 then
            print('error: ', err, text)
        end
    end, 'POST', json.encode({ embeds = { embed } }), { 
        ['Content-Type'] = 'application/json' 
    })
end

function GetMaxSpace()
    local max = 0

    for k,v in pairs(Clothes) do
        if #v > max then
            max = #v
        end
    end

    return max
end

maxSpace = GetMaxSpace()

function GetNeedSpaces(cloth, numCloth)
    spaces, clothLength = '    ', #cloth

    if tostring(numCloth):len() ~= 1 then
        clothLength = clothLength - 1
        for i=1, tostring(numCloth):len() do
            clothLength = clothLength + 1
        end
    end

    for i=1, (maxSpace - clothLength) do
        spaces = spaces..' '
    end

    return spaces
end