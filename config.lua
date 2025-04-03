

Config = {}

Config.Locale = 'en'

--- Admind Groups for admin commands like forcelog , /ck /unck

Config.AdminGroups = {
	'gameadmin',
	'management',
	'leadadmin',
	'developer',
}

Config.Commands = {
    setPlaytime = 'setp', -- Command for admins to set players' playtime
    getPlaytime = 'playtime' -- Command to check playtime
}

Config.Messages = {
    playtimeMessage = 'You have a total of %s playtime!',
    setPlaytimeSuccess = 'You have successfully set %s\'s playtime to %s minutes.',
    notAdmin = 'You do not have permission to use this command.'
}


Config.Forcelog = ''  -- Forcelog
Config.CK = ''  -- CK Logs
Config.UNCK = ''  -- UNCK Logs

-- Add the message to be broadcasted to all players when a character is CK'd
Config.CKMessage = "^4[Local News]:^1%s has been announced dead."


-- Allows players to delete their characters
Config.CanDelete = true
-- This is the default number of slots for EVERY player
-- If you want to manage extra slots for specific players you can do it by using '/setslots' and '/remslots' commands
Config.Slots = 4

Config.SpawnLocations = {
	["Los Santos International"] = vector4(-1037.94, -2738.067, 20.16927, 329.55),
	["Pillbox Train Station"] = vector4(-207.7108, -1017.7524, 30.1383, 339.5241),
	["Davis Train Stations"] = vector4(98.54, -1711.429, 30.11266, 49.68),
	["Rockford Hills Train Stations"] = vector4(-797.1931, -97.6604, 37.6561, 297.5867),
	["El Rancho"] = vector4(1240.7811, -1456.5840, 34.9481, 2.4663),
	["Downtown Vinewood"] = vector4(296.7486, 188.1068, 104.1899, 162.6970),
	["Vespucci Beach"] = vector4(-1635.4027, -1011.8973, 13.1042, 47.7446),
	["Sandy Shore"] = vector4(1841.7018, 3668.8408, 33.6752, 210.8810),
	["Paleto Bay"] = vector4(-5.5486, 6844.0889, 32.1384, 352.5911),
	["Mission Row"] = vector4(433.4250, -974.8745, 30.7112, 90.7667),
	["Vinewood Police"] = vector4(671.4628, 2.4144, 84.0756, 98.7740),
}

if IsDuplicityVersion() then
	--------------------

	-- Text to prepend to each character (char#:identifier) - keep it short
	Config.Prefix = 'char'
	--------------------

	-- Default identifier to store for characters - this should always match es_extended (recommended: license)
	Config.Identifier = 'license'
else
	-- Sets the location for the character selection scene
	-- To set the spawn location for new characters, modify the default value in the `users` SQL table
	Config.Spawn = vector4(-113.7, 565.3, 195.2, 0)
	--------------------

-- Camera offset
	Config.Offset = vector4(0, 1.9, 0.4, 0)  -- Define the offset coordinates in the Config table
	
	-- Do not use unless you are prepared to adjust your resources to correctly reset data
	-- Information: https://github.com/thelindat/esx_multicharacter#relogging
	Config.Relog = true
	--------------------

	-- Default appearance for new characters
	Config.Default = {
		mom = 21,
		dad = 0,
		face_md_weight = 50,
		skin_md_weight = 50,
		nose_1 = 0,
		nose_2 = 0,
		nose_3 = 0,
		nose_4 = 0,
		nose_5 = 0,
		nose_6 = 0,
		cheeks_1 = 0,
		cheeks_2 = 0,
		cheeks_3 = 0,
		lip_thickness = 0,
		jaw_1 = 0,
		jaw_2 = 0,
		chin_1 = 0,
		chin_2 = 0,
		chin_13 = 0,
		chin_4 = 0,
		neck_thickness = 0,
		hair_1 = 0,
		hair_2 = 0,
		hair_color_1 = 0,
		hair_color_2 = 0,
		tshirt_1 = 0,
		tshirt_2 = 0,
		torso_1 = 0,
		torso_2 = 0,
		decals_1 = 0,
		decals_2 = 0,
		arms = 0,
		arms_2 = 0,
		pants_1 = 0,
		pants_2 = 0,
		shoes_1 = 0,
		shoes_2 = 0,
		mask_1 = 0,
		mask_2 = 0,
		bproof_1 = 0,
		bproof_2 = 0,
		chain_1 = 0,
		chain_2 = 0,
		helmet_1 = -1,
		helmet_2 = 0,
		glasses_1 = 0,
		glasses_2 = 0,
		watches_1 = -1,
		watches_2 = 0,
		bracelets_1 = -1,
		bracelets_2 = 0,
		bags_1 = 0,
		bags_2 = 0,
		eye_color = 0,
		eye_squint = 0,
		eyebrows_2 = 0,
		eyebrows_1 = 0,
		eyebrows_3 = 0,
		eyebrows_4 = 0,
		eyebrows_5 = 0,
		eyebrows_6 = 0,
		makeup_1 = 0,
		makeup_2 = 0,
		makeup_3 = 0,
		makeup_4 = 0,
		lipstick_1 = 0,
		lipstick_2 = 0,
		lipstick_3 = 0,
		lipstick_4 = 0,
		ears_1 = -1,
		ears_2 = 0,
		chest_1 = 0,
		chest_2 = 0,
		chest_3 = 0,
		bodyb_1 = -1,
		bodyb_2 = 0,
		bodyb_3 = -1,
		bodyb_4 = 0,
		age_1 = 0,
		age_2 = 0,
		blemishes_1 = 0,
		blemishes_2 = 0,
		blush_1 = 0,
		blush_2 = 0,
		blush_3 = 0,
		complexion_1 = 0,
		complexion_2 = 0,
		sun_1 = 0,
		sun_2 = 0,
		moles_1 = 0,
		moles_2 = 0,
		beard_1 = 0,
		beard_2 = 0,
		beard_3 = 0,
		beard_4 = 0
	}
end