Config = {}

-- The following groups are allowed to use /reports command.
Config.WhitelistedGroups      = { ['staff'] = true, ['mod'] = true, ['moderator'] = true, ['admin'] = true, ['administrator'] = true, ['superadmin'] = true, ['owner'] = true }

Config.ServerPrefix           = "[MyServerName]"

-- Set it to false if you don't want to send logs where discord webhook is located.
Config.USE_WEBHOOK            = true

-- Insert the channel webhook that you want in order to send logs when a player submits a report.
Config.WEBHOOK                = "https://discord.com/api/webhooks/918894571990188072/h7u1C_lHxqZjD13GtFJrEQvvACu3V6KP39ls08AUkYOgQDBSWzRpLTY0EzepOugyk1xX"

-- Insert your discord server name, example: [MY SERVER]
Config.DISCORD_NAME           = "[MyServerName]"

-- Insert your discord logo image, example: https://i.imgur.com/xxxxxx.png
Config.DISCORD_IMAGE          = "https://i.imgur.com/xxxxxxxx.png"

-- Insert your discord footer text.
Config.DISCORD_FOOTER         = "© Support Team"

-- Set it to false if you dont want any reports to be stored in sql (database).
Config.STORE_IN_SQL           = false