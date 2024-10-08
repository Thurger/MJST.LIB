--- STEAMODDED HEADER
--- MOD_NAME: MJST.LIB
--- MOD_ID: mjst_lib
--- MOD_AUTHOR: [MJST]
--- MOD_DESCRIPTION: MJST LIB
--- BADGE_COLOUR: F0AC14
--- PREFIX: mjst_lib
--- VERSION: 1.1.2
--- DISPLAY_NAME: MJST's LIB
--- PRIORITY: -100

----------------------------------------------
------------MOD CODE -------------------------

sendInfoMessage("[MJST.LIB]: LOADING...")

if not NFS then sendErrorMessage("[MJST.LIB](main.lua line 18): ERROR - NFS missing", "MJST.LIB") return end
if not SMODS then sendErrorMessage("[MJST.LIB](main.lua line 19): ERROR - SMODS missing", "MJST.LIB") return end

NFS.load(SMODS.current_mod.path .. "src/atlases.lua")()

NFS.load(SMODS.current_mod.path .. "src/Card.lua")()
NFS.load(SMODS.current_mod.path .. "src/Hand.lua")()

-- NFS.load(SMODS.current_mod.path .. "src/spectrals/vanish.lua")()

sendInfoMessage("[MJST.LIB]: LOADED!")

----------------------------------------------
------------MOD CODE END----------------------