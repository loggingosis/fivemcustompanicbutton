local cooldown = {} -- [src] = os.time() when usable again

local function now()
    return os.time()
end

RegisterNetEvent('panic_button:trigger', function(coords)
    local src = source
    if type(coords) ~= 'table' or coords.x == nil or coords.y == nil or coords.z == nil then return end

    local t = now()
    local readyAt = cooldown[src] or 0
    if t < readyAt then
        TriggerClientEvent('panic_button:cooldown', src, readyAt - t)
        return
    end

    cooldown[src] = t + (Config.CooldownSeconds or 20)

    local name = GetPlayerName(src) or ('ID ' .. tostring(src))

    -- Broadcast to everyone: name + coords
    TriggerClientEvent('panic_button:receive', -1, {
        src = src,
        name = name,
        coords = { x = coords.x + 0.0, y = coords.y + 0.0, z = coords.z + 0.0 }
    })
end)

AddEventHandler('playerDropped', function()
    cooldown[source] = nil
end)
