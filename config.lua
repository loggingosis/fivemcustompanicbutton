Config = {}

-- Key binding (default F9). You can change to another control or also add a command.
Config.KeyMappingName = 'panicbutton'
Config.DefaultKey = 'F9'

-- Anti-spam
Config.CooldownSeconds = 20

-- Blip settings
Config.Blip = {
    Sprite = 161,        -- radius/alert style icons vary; 161 is a "radius" style blip, you can change
    Color = 1,           -- 1 = red
    Scale = 1.2,
    Display = 4,
    ShortRange = false,
    Text = 'PANIC BUTTON',
    DurationSeconds = 120, -- how long the blip stays
}

-- Radius circle settings
Config.Radius = {
    Enabled = true,
    Radius = 80.0,          -- meters
    Color = { r = 255, g = 0, b = 0, a = 110 },
    DurationSeconds = 120
}

-- Notification text
Config.Messages = {
    Triggered = '^1PANIC:^7 %s pressed panic at ^3(%.1f, %.1f, %.1f)^7',
    Received = '^1PANIC:^7 %s needs help. Location marked.',
    Cooldown = '^3Panic cooldown:^7 %ds remaining.'
}

-- Sound options:
-- Option A: Use an in-game frontend sound (no extra files needed).
Config.Sound = {
    Enabled = true,
    UseNui = false, -- set true to use custom audio file via NUI
    Frontend = {
        SoundName = 'TIMER_STOP',     -- change to any valid sound
        SoundSet  = 'HUD_MINI_GAME_SOUNDSET'
    },

    -- Option B (custom audio): NUI audio file in html/ (ogg/mp3/wav).
    Nui = {
        File = 'panic.ogg',   -- put this file in html/ and set UseNui=true
        Volume = 0.75
    }
}

-- Optional: Only allow certain players (example by ACE)
-- If true, players must have ace "panicbutton.use" or the event will be ignored client-side.
Config.RequireAce = false
Config.AceName = 'panicbutton.use'
