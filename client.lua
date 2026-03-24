local lastTrigger = 0
local activeAlerts = {} -- list of { blip=, radiusBlip=, expiresAt= }

local function hasAce()
    if not Config.RequireAce then return true end
    return IsPlayerAceAllowed(PlayerId(), Config.AceName)
end

local function chat(msg)
    TriggerEvent('chat:addMessage', { args = { msg } })
end

local function playAlertSound()
    if not (Config.Sound and Config.Sound.Enabled) then return end

    if Config.Sound.UseNui then
        -- NUI audio (requires html/ui.html + html/ui.js)
        SendNUIMessage({
            type = 'panic_sound',
            file = Config.Sound.Nui.File,
            volume = Config.Sound.Nui.Volume or 0.75
        })
    else
        -- Built-in sound (no files)
        local s = Config.Sound.Frontend
        PlaySoundFrontend(-1, s.SoundName or 'TIMER_STOP', s.SoundSet or 'HUD_MINI_GAME_SOUNDSET', true)
    end
end

local function makeBlip(coords, label)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, Config.Blip.Sprite)
    SetBlipColour(blip, Config.Blip.Color)
    SetBlipScale(blip, Config.Blip.Scale)
    SetBlipDisplay(blip, Config.Blip.Display)
    SetBlipAsShortRange(blip, Config.Blip.ShortRange)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(label)
    EndTextCommandSetBlipName(blip)

    return blip
end

local function makeRadius(coords)
    if not (Config.Radius and Config.Radius.Enabled) then return nil end
    local r = Config.Radius.Radius or 80.0
    local rb = AddBlipForRadius(coords.x, coords.y, coords.z, r)
    local c = Config.Radius.Color or { r = 255, g = 0, b = 0, a = 110 }
    SetBlipColour(rb, Config.Blip.Color)
    SetBlipAlpha(rb, c.a or 110)
    return rb
end

local function cleanupExpired()
    local t = GetGameTimer()
    for i = #activeAlerts, 1, -1 do
        local a = activeAlerts[i]
        if a.expiresAt <= t then
            if a.blip and DoesBlipExist(a.blip) then RemoveBlip(a.blip) end
            if a.radiusBlip and DoesBlipExist(a.radiusBlip) then RemoveBlip(a.radiusBlip) end
            table.remove(activeAlerts, i)
        end
    end
end

CreateThread(function()
    while true do
        cleanupExpired()
        Wait(1000)
    end
end)

local function triggerPanic()
    if not hasAce() then return end

    local ped = PlayerPedId()
    if ped == 0 then return end

    local t = GetGameTimer()
    if (t - lastTrigger) < 500 then return end -- local debounce
    lastTrigger = t

    local coords = GetEntityCoords(ped)
    TriggerServerEvent('panic_button:trigger', { x = coords.x, y = coords.y, z = coords.z })
end

-- Key mapping + command
RegisterCommand(Config.KeyMappingName, function()
    triggerPanic()
end, false)

RegisterKeyMapping(Config.KeyMappingName, 'Panic Button', 'keyboard', Config.DefaultKey)

RegisterNetEvent('panic_button:cooldown', function(remaining)
    chat(string.format(Config.Messages.Cooldown, tonumber(remaining) or 0))
end)

RegisterNetEvent('panic_button:receive', function(data)
    if type(data) ~= 'table' or type(data.coords) ~= 'table' then return end

    local coords = data.coords
    local name = data.name or 'Unknown'
    local label = Config.Blip.Text or 'PANIC BUTTON'

    -- Message
    chat(string.format(Config.Messages.Received, name))
    chat(string.format(Config.Messages.Triggered, name, coords.x, coords.y, coords.z))

    -- Sound
    playAlertSound()

    -- Blip + radius
    local blip = makeBlip(coords, label .. ' - ' .. name)
    local radiusBlip = makeRadius(coords)

    local durationMs = (Config.Blip.DurationSeconds or 120) * 1000
    local expiresAt = GetGameTimer() + durationMs

    table.insert(activeAlerts, {
        blip = blip,
        radiusBlip = radiusBlip,
        expiresAt = expiresAt
    })

    -- Optional: set waypoint for receivers
    SetNewWaypoint(coords.x, coords.y)
end)
