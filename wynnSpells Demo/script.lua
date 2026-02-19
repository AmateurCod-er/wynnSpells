vanilla_model.PLAYER:setVisible(false)
vanilla_model.ARMOR:setVisible(false)
vanilla_model.CAPE:setVisible(false)


local wynnSpells = require("wynnSpells")

-- "reset_all", when another spell is cast, end the current spell animation, and play the new one
-- "reset_each", when the SAME spell is cast, restart it's animation. Different spells however will play their animations on top of one another
-- "play_all", when the SAME spell is cast, ignore it it's animation is currently playing. Different spells however will play their animations on top of one another
-- "play_one", when another spell is cast, ignore it if any other spell animation is currently playing
wynnSpells.anim_mode = "reset_all"
-- The default if not set, or if invalid, is "reset_all"

-- Call a function depending on the spell
function MageRLR()
	log("you cast Heal")
end

function Teleport()
	log("you cast Teleport")
	-- Animations can be played within functions, if you want to do both
	animations.model.WarriorRRR:play()
end

function MageSpell3()
	log("you cast Meteor")
end

function RRL()
	log("you cast some 4th spell, but idk which lol")
end


-- Send your class and if you're holding a valid weapon in chat
function pings.demonstration(state)
    log("you are a " .. wynnSpells.get_class() .. ", is your weapon valid: " .. tostring(wynnSpells.get_valid_weapon()) .. ", and finally is it shiny: " .. tostring(wynnSpells.get_holding_shiny()))
end

local mainPage = action_wheel:newPage(ApertureSciencePromoGuy)
action_wheel:setPage(mainPage)
local demonstration = mainPage:newAction(ShowChestplate)
    :title("is there a way to make this not toggle?: Disabled")
    :toggleTitle("I forget how action wheels work lol: Enabled")
    :item("ender_pearl")
    :toggleItem("ender_eye")
    :setOnToggle(pings.demonstration)