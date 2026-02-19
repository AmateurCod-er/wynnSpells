--- @module wynnSpells
local wynnSpells = {}

-- ====================
-- Inputs and stuff
-- ====================
local ATTACK_KEY = keybinds:newKeybind("Attack", keybinds:getVanillaKey("key.attack"))
local USE_KEY = keybinds:newKeybind("Use", keybinds:getVanillaKey("key.use"))
ATTACK_KEY:setOnPress(function()
	wynnSpells.spell_casting(0)
end)
USE_KEY:setOnPress(function()
    wynnSpells.spell_casting(1)
end)

--- Load all of the Wynntils QuickCast keybinds
function wynnSpells.wynntils_keybinds()
	local FIRST_SPELL = keybinds:newKeybind("First", keybinds:getVanillaKey("Cast 1st Spell"))
	local SECOND_SPELL = keybinds:newKeybind("First", keybinds:getVanillaKey("Cast 2nd Spell"))
	local THIRD_SPELL = keybinds:newKeybind("First", keybinds:getVanillaKey("Cast 3rd Spell"))
	local FOURTH_SPELL = keybinds:newKeybind("First", keybinds:getVanillaKey("Cast 4th Spell"))

	FIRST_SPELL:setOnPress(function()
		wynnSpells.spell_casting(1, true)
		wynnSpells.spell_casting(0, true)
		wynnSpells.spell_casting(1, true)
	end)

	SECOND_SPELL:setOnPress(function()
		wynnSpells.spell_casting(1, true)
		wynnSpells.spell_casting(1, true)
		wynnSpells.spell_casting(1, true)
	end)

	THIRD_SPELL:setOnPress(function()
		wynnSpells.spell_casting(1, true)
		wynnSpells.spell_casting(0, true)
		wynnSpells.spell_casting(0, true)
	end)

	FOURTH_SPELL:setOnPress(function()
		wynnSpells.spell_casting(1, true)
		wynnSpells.spell_casting(1, true)
		wynnSpells.spell_casting(0, true)
	end)
	return false
end

-- Hiding all of the wynntils keybinds in a pcall, so that if it errors out for whatever reason I dont need to deal with it lol
pcall(wynnSpells.wynntils_keybinds())

-- ====================
-- Determining class
-- ====================
local shiny = false
local weapon = false
local prev_weapon = ""
local class = "Unknown"
local cast_window = 0


local LIST_OF_WANDS = {["Squidword's Clarinet"] = true, ["Valix"] = true, ["The Brain Smasher"] = true, ["Stave of Tribute"] = true, ["Stick of Brilliance"] = true, ["Dusty Staff"] = true, ["Timbre"] = true, ["Dark Needle"] = true, ["Salamander"] = true, ["Gavel's Memory"] = true, ["Viper"] = true, ["Continuum"] = true, ["Staff of the Dark Vexations"] = true, ["Paradise"] = true, ["Meltok"] = true, ["The Magician"] = true, ["Midnight Bell"] = true, ["Kelight's Toothbrush"] = true, ["Psychoruin"] = true, ["Walking Stick"] = true, ["Celestial"] = true, ["Mage-Crafted Staff"] = true, ["Wind Spine"] = true, ["Kamikaze"] = true, ["Broken Harp"] = true, ["Harmstick"] = true, ["Tribal Flute"] = true, ["Phoenix"] = true, ["Upgraded Phoenix"] = true, ["Curse"] = true, ["Magicant"] = true, ["Soul"] = true, ["Frozen Brook"] = true, ["Holly"] = true, ["Viking Breath"] = true, ["The Creationist"] = true, ["Unholy Wand"] = true, ["Monk's Battle Staff"] = true, ["Wipe"] = true, ["Hellkite's Wing"] = true, ["Paradigm Shift"] = true, ["Blight"] = true, ["Doomsday"] = true, ["Earth Relic Wand"] = true, ["Thunder Relic Wand"] = true, ["Water Relic Wand"] = true, ["Fire Relic Wand"] = true, ["Air Relic Wand"] = true, ["Relic Wand"] = true, ["Altimeter"] = true, ["Cerid's Dynamo"] = true, ["Sunrise"] = true, ["The Medic"] = true, ["North Pole"] = true, ["Scroll of Nythiar"] = true, ["Frustration"] = true, ["Sanare"] = true, ["Emerald Staff"] = true, ["Torch"] = true, ["Tragedy"] = true, ["Hydra"] = true, ["Griffin"] = true, ["Crystal Thorn"] = true, ["Fulminate Staff"] = true, ["Rot of Dernel"] = true, ["Niflheim"] = true, ["Wishing Star"] = true, ["Tashkil"] = true, ["Genetor"] = true, ["Ligfamblawende"] = true, ["Voidlight"] = true, ["Squall's Breath"] = true, ["Sigil of Existence"] = true, ["Starburst"] = true, ["Wybel Ivory Wand"] = true, ["Antipode"] = true, ["Storm Surge"] = true, ["Whimsy"] = true, ["Fragment"] = true, ["Icejewel"] = true, ["Desperado"] = true, ["Heatwave"] = true, ["Overgrown"] = true, ["Restorator"] = true, ["King of Hearts"] = true, ["Manablast"] = true, ["Luto Aquarum"] = true, ["Waking Vigil"] = true, ["Predposledni"] = true, ["Frameshift"] = true, ["Plate Shock"] = true, ["Voidstone Recteps"] = true, ["Kal Hei"] = true, ["Calamaro's Staff"] = true, ["Ohonte Kerhite"] = true, ["Nest"] = true, ["Final Compulsion"] = true, ["Eidolon"] = true, ["Yellow Rose"] = true, ["Jungle Spirit"] = true, ["Clunderthap"] = true, ["Rumble"] = true, ["Serpent's Kiss"] = true, ["Putrid"] = true, ["Compiler"] = true, ["Lament"] = true, ["Gaia"] = true, ["Monster"] = true, ["Fatal"] = true, ["Singularity"] = true, ["Warp"] = true, ["Quetzalcoatl"] = true, ["Pure"] = true, ["Ancient Wand"] = true, ["Reticence"] = true, ["Effervescence"] = true, ["Detlas' Legacy"] = true, ["Red Candle"] = true, ["Blossom"] = true, ["Waves Raiser"] = true, ["Glare"] = true, ["Haqherphix"] = true, ["Sage"] = true, ["Bough of Fir"] = true, ["Solar Pillar"] = true, ["Diablo"] = true, ["Aerokinesis"] = true, ["Ohms' Wish"] = true, ["Ethereal"] = true, ["Afterimage"] = true, ["Prymari"] = true, ["Wrath"] = true, ["Empire Builder"] = true, ["Bismuthinite"] = true, ["Lazuli"] = true, ["Thanos Ironstaff"] = true, ["Faustian Contract"] = true, ["Lunar Spine"] = true, ["Nepta Floodbringer"] = true, ["Phoenix Wing"] = true, ["Morrowind"] = true, ["Cascade"] = true, ["Event Horizon"] = true, ["Bob's Mythic Wand"] = true, ["Olux's Prized Wand"] = true, ["Storyteller"] = true, ["Depth"] = true, ["Judas"] = true, ["Peaceful Rest"] = true, ["Bonder"] = true, ["The Nothing"] = true, ["Haros' Oar"] = true, ["Gert Whooshy Bonkpole"] = true, ["Gert Super Special Magic Ultistick"] = true, ["Sprout"] = true, ["Stave of the Legends"] = true, ["Tempo Ticker"] = true, ["Hymn of the Dead"] = true, ["Infused Hive Wand"] = true, ["Heat Death"] = true, ["Third Wish"] = true, ["Plague Staff"] = true}
local LIST_OF_DAGGERS = {["The Wool Trimmer"] = true, ["Spore Shortsword"] = true, ["Infinitesimal"] = true, ["Voodoo"] = true, ["Pin"] = true, ["Striker"] = true, ["Hot Spot"] = true, ["Tromsian Survival Knife"] = true, ["Watercolour"] = true, ["Butter Knife"] = true, ["Euthanasia"] = true, ["Spicy"] = true, ["White Ghost"] = true, ["Someone Else's Knife"] = true, ["Charon's Left Arm"] = true, ["Embers"] = true, ["Styx's Grab"] = true, ["Phantom Blade"] = true, ["Scalpel"] = true, ["Upgraded Scalpel"] = true, ["Cypress"] = true, ["Emerald Knife"] = true, ["Sandslasher"] = true, ["Stylist's Scissors"] = true, ["Vandalizer"] = true, ["Jaw Breaker"] = true, ["Jolt of Inspiration"] = true, ["Katana"] = true, ["Misericorde"] = true, ["Short Cutter"] = true, ["Calamaro's Sword"] = true, ["Splinter"] = true, ["Erhu"] = true, ["Dematerialized"] = true, ["Conifer"] = true, ["Spike"] = true, ["Hypercane"] = true, ["Vine Machete"] = true, ["Crowbeak"] = true, ["Cutthroat"] = true, ["Squid Dagger"] = true, ["Repulsion"] = true, ["Skien's Paranoia"] = true, ["Grave Digger"] = true, ["Raptor"] = true, ["Bull"] = true, ["Ouragan"] = true, ["World Splitter"] = true, ["Earth Relic Daggers"] = true, ["Thunder Relic Daggers"] = true, ["Water Relic Daggers"] = true, ["Fire Relic Daggers"] = true, ["Air Relic Daggers"] = true, ["Relic Daggers"] = true, ["Icicle"] = true, ["Leikkuri"] = true, ["Vorpal"] = true, ["Crossroad Killer"] = true, ["Enerxia"] = true, ["Regar"] = true, ["Ricin"] = true, ["Vandal's Touch"] = true, ["Sapling"] = true, ["Zawah Jed"] = true, ["Salticidae"] = true, ["Throatcut"] = true, ["Saltine"] = true, ["Roulette"] = true, ["Agitation"] = true, ["Rapier"] = true, ["Shale Edge"] = true, ["Countdown"] = true, ["Bygones"] = true, ["Sreggad"] = true, ["Evergreen"] = true, ["Mountain Spirit"] = true, ["Solar Sword"] = true, ["Thrice"] = true, ["Pyroclast"] = true, ["Darkweaver"] = true, ["Big Arm"] = true, ["Wybel Tooth Dagger"] = true, ["Desperation"] = true, ["Liquefied Sun"] = true, ["Gibyeong"] = true, ["Omega"] = true, ["Shard of Sky"] = true, ["Tsunasweep"] = true, ["Forest Aconite"] = true, ["Limbo"] = true, ["Voidstone Esbald"] = true, ["Silver"] = true, ["Fate's Shear"] = true, ["The Specialist"] = true, ["Arakadicus' Maw"] = true, ["Noble Phantasm"] = true, ["Blur"] = true, ["Lanternfly Leg"] = true, ["Archangel"] = true, ["Nullification"] = true, ["Cataclysm"] = true, ["Grimtrap"] = true, ["Weathered"] = true, ["Inferno"] = true, ["Nirvana"] = true, ["Oblivion"] = true, ["Dislocater"] = true, ["Iron Knuckle"] = true, ["Circuit Buster"] = true, ["Almuj's Daggers"] = true, ["Bulldozer"] = true, ["The Divide"] = true, ["Abolition"] = true, ["Blazing Ruin"] = true, ["Stabsand"] = true, ["Tempo Tanto"] = true, ["Darkiron Zweihander"] = true, ["Influence"] = true, ["Hashr Claw"] = true, ["Kilij"] = true, ["Nodguj Warrior Sword"] = true, ["Scorpion"] = true, ["Reaper of Soul"] = true, ["Impulse"] = true, ["Olux's Prized Dagger"] = true, ["Locrian"] = true, ["Sharpened Seaglass"] = true, ["Babylon's Scale"] = true, ["The Exile"] = true, ["Redbeard's Cutlass"] = true, ["Blade of Shade"] = true, ["Chakram"] = true, ["Wall Breaker"] = true, ["Arma Gauntlet"] = true, ["Amadeus"] = true, ["Bob's Mythic Daggers"] = true, ["Dodegar's Ultimate Weapon"] = true, ["Gert Swingpoke Cuttyrock"] = true, ["Rewind"] = true, ["Thanos Warsword"] = true, ["The Visionary's Vice"] = true, ["Fluffwind"] = true, ["Brass Brand"] = true, ["Alizarin"] = true, ["Manna"] = true, ["Sawtooth"] = true, ["Flameshot Hilt"] = true, ["Thrunda Ripsaw"] = true, ["Nona"] = true, ["Ivory"] = true, ["Black"] = true, ["Sitis"] = true, ["Slider"] = true, ["The Exploited"] = true, ["Infused Hive Dagger"] = true, ["Roiling Ruckus"] = true, ["Blossom Haze"] = true, ["Ysengrim"] = true}
local LIST_OF_SPEARS = {["Aloof"] = true, ["The Leech Spear"] = true, ["Fourchette"] = true, ["Hostage"] = true, ["Chandelle"] = true, ["Ragni's Spear"] = true, ["War Spear"] = true, ["Sledge"] = true, ["Isaz"] = true, ["Guard Spear"] = true, ["Stone Cutter"] = true, ["Bedrock Eater"] = true, ["The Skin Tearer"] = true, ["Chief"] = true, ["Hilt"] = true, ["Pursuit"] = true, ["Spear of Prosperity"] = true, ["Bison Tipper"] = true, ["Finchbone Spear"] = true, ["Grandfather"] = true, ["Broken Trident"] = true, ["Big Ol' Hammer"] = true, ["Hunter"] = true, ["The Fallen"] = true, ["Blade of Wisdom"] = true, ["Eel Spear"] = true, ["Kuiper"] = true, ["Barbed Spear"] = true, ["Cross"] = true, ["Enflame"] = true, ["Hook"] = true, ["The Head Ripper"] = true, ["Ocean Blade"] = true, ["Fluffy Spear"] = true, ["Vartija"] = true, ["Upgraded Vartija"] = true, ["Steel Buster"] = true, ["Upgraded Steel Buster"] = true, ["Wild Charge"] = true, ["Mixolydian"] = true, ["Dragon Fang"] = true, ["Nerium Old Spear"] = true, ["Meteorite"] = true, ["Ice Fishing Spear"] = true, ["Affrettando"] = true, ["Copper-Alloy Pike"] = true, ["Poison-Tipped Poleaxe"] = true, ["Sharp Terror"] = true, ["Current"] = true, ["Kolkhaar"] = true, ["Silver Short Spear"] = true, ["Syringe"] = true, ["Traitor"] = true, ["The Vampire Blade"] = true, ["Oxalate"] = true, ["Nesaak's Will"] = true, ["Gale Rider"] = true, ["Chest Breaker"] = true, ["Malfunction"] = true, ["Razor"] = true, ["Sandscar"] = true, ["Kenaz"] = true, ["Assurance"] = true, ["Thunderstruck"] = true, ["Xystus"] = true, ["Eil"] = true, ["Candy Cane"] = true, ["Dual"] = true, ["Floodgate"] = true, ["Vanilla Spade"] = true, ["Absorption"] = true, ["Spear of Vix"] = true, ["Carrot"] = true, ["Magma Rod"] = true, ["Nerium Long Spear"] = true, ["Griswold's Edge"] = true, ["Kerasot Spreader"] = true, ["Plasma Sabre"] = true, ["Glowstone Killer"] = true, ["Broken Cross"] = true, ["Chlorofury"] = true, ["Sphyken"] = true, ["Old Maple Spear"] = true, ["Sheathed Glaive"] = true, ["Tempest"] = true, ["Heatwind"] = true, ["Kekkai"] = true, ["Black Spear"] = true, ["Paladin's Hammer"] = true, ["Troms' Pride"] = true, ["Heart Piercer"] = true, ["Shokku"] = true, ["Diabloviento"] = true, ["Fluffster"] = true, ["Quasar"] = true, ["War Pike"] = true, ["Aldo"] = true, ["Snow Shovel"] = true, ["Chain Hook"] = true, ["Cloudbreaker"] = true, ["Overcharger"] = true, ["Shade of Night"] = true, ["Balloon's Bane"] = true, ["Dragon Slayer"] = true, ["Emerald Chopper"] = true, ["Krampus"] = true, ["Breath of the Vampire"] = true, ["Namazu"] = true, ["Tankard Basher"] = true, ["Drifting Spear"] = true, ["Bonethrasher"] = true, ["Deathbringer"] = true, ["Glitchtean"] = true, ["Unsheathed Glaive"] = true, ["Wood Hammer"] = true, ["Bizzles"] = true, ["Nerium Great Spear"] = true, ["Gear Grinder"] = true, ["Spark of Courage"] = true, ["Yamato Spear"] = true, ["Corkian War Pick"] = true, ["Nightstar"] = true, ["Sculptor"] = true, ["Spear of Sin"] = true, ["Hammer of the Forge"] = true, ["Siege Ram"] = true, ["Heartache"] = true, ["Behemoth"] = true, ["Hell's Scream"] = true, ["Feedback"] = true, ["Sekaisin"] = true, ["Reflect"] = true, ["Boiler"] = true, ["Earth Drift"] = true, ["Shield Buster"] = true, ["Spearmint"] = true, ["Frenzy"] = true, ["Sharpened Harpoon"] = true, ["Lustrous"] = true, ["Magnitude"] = true, ["Bylvis' Pitchfork"] = true, ["Diaminar"] = true, ["Sting"] = true, ["Corpse"] = true, ["Divergence"] = true, ["Pigman Battle Hammer"] = true, ["Bullseye"] = true, ["Javelin"] = true, ["Dern's Shadow"] = true, ["Charging Cable"] = true, ["Pike of Fury"] = true, ["Vellalar"] = true, ["Fern"] = true, ["Sloth"] = true, ["Blade of Instinct"] = true, ["Halbert"] = true, ["Cyclops' Spear"] = true, ["Mist Blade"] = true, ["Drywind"] = true, ["The Banhammer"] = true, ["Dern's Desolation"] = true, ["Hammer of the Blacksmith"] = true, ["Shadow Spear"] = true, ["Lust"] = true, ["Sandstorm"] = true, ["Archpriest"] = true, ["Upgraded Archpriest"] = true, ["Lydian"] = true, ["Fighting Spirit"] = true, ["Flaming War Spear"] = true, ["Hillich"] = true, ["Joker"] = true, ["The Nautilus"] = true, ["Sleigher"] = true, ["Coeur de Lion"] = true, ["Garnet"] = true, ["Turmoil"] = true, ["Warlord"] = true, ["Skien's Madness"] = true, ["Demon Seeker"] = true, ["Polaris"] = true, ["Earth Relic Spear"] = true, ["Thunder Relic Spear"] = true, ["Water Relic Spear"] = true, ["Fire Relic Spear"] = true, ["Air Relic Spear"] = true, ["Relic Spear"] = true, ["Captain's Razor"] = true, ["Drifter"] = true, ["Firewood"] = true, ["The Eviscerator"] = true, ["Azimuth"] = true, ["Ik-El-Van"] = true, ["Fission Blade"] = true, ["Rocher"] = true, ["Toaster"] = true, ["Morning Star"] = true, ["Virtue"] = true, ["Battery"] = true, ["Gungnir"] = true, ["Cursed Spike"] = true, ["Tower"] = true, ["Veantur"] = true, ["Mystical Lance"] = true, ["Brimstone"] = true, ["Sheet Ice"] = true, ["Bardiche"] = true, ["Cardinal Ruler"] = true, ["Infilak"] = true, ["Wybel Horn Spear"] = true, ["Bane of War"] = true, ["Cloud Nine"] = true, ["Cue Stick"] = true, ["Supernova"] = true, ["Charging Flame"] = true, ["Undying"] = true, ["Harbinger of Fate"] = true, ["Poison Ivy"] = true, ["Praesidium"] = true, ["Ace of Spades"] = true, ["The Parasite"] = true, ["Crack the Skies"] = true, ["Helminth"] = true, ["Double-Edge"] = true, ["Voidstone Arpes"] = true, ["Lost Soul"] = true, ["Fuunyet"] = true, ["Calamaro's Spear"] = true, ["Ghoul"] = true, ["Breakbore"] = true, ["Brace of the Ninth"] = true, ["Black Amaranth"] = true, ["Maul"] = true, ["Barbed"] = true, ["Sol"] = true, ["Algaa"] = true, ["Skull Breaker"] = true, ["Cathedral"] = true, ["Depressing Spear"] = true, ["Stone-Hewn Spear"] = true, ["Light Oak Wood Spear"] = true, ["Birch Wood Spear"] = true, ["Andesite-Hewn Spear"] = true, ["Light Birch Wood Spear"] = true, ["Spruce Wood Spear"] = true, ["Diorite-Hewn Spear"] = true, ["Light Spruce Wood Spear"] = true, ["Jungle Wood Spear"] = true, ["Granite-Hewn Spear"] = true, ["Light Jungle Wood Spear"] = true, ["Flawless Oak Spear"] = true, ["Flawless Stone Spear"] = true, ["Flawless Light Oak Spear"] = true, ["Flawless Birch Spear"] = true, ["Flawless Andesite Spear"] = true, ["Flawless Light Birch Spear"] = true, ["Flawless Spruce Spear"] = true, ["Flawless Diorite Spear"] = true, ["Flawless Light Spruce Spear"] = true, ["Flawless Jungle Spear"] = true, ["Flawless Granite Spear"] = true, ["Flawless Light Jungle Spear"] = true, ["Pure Oak Spear"] = true, ["Pure Stone Spear"] = true, ["Pure Light Oak Spear"] = true, ["Pure Birch Spear"] = true, ["Pure Andesite Spear"] = true, ["Pure Light Birch Spear"] = true, ["Pure Spruce Spear"] = true, ["Pure Diorite Spear"] = true, ["Pure Light Spruce Spear"] = true, ["Pure Jungle Spear"] = true, ["Pure Granite Spear"] = true, ["Pure Light Jungle Spear"] = true, ["Impeccable Oak Spear"] = true, ["Impeccable Stone Spear"] = true, ["Impeccable Light Oak Spear"] = true, ["Impeccable Birch Spear"] = true, ["Impeccable Andesite Spear"] = true, ["Impeccable Light Birch Spear"] = true, ["Impeccable Spruce Spear"] = true, ["Impeccable Diorite Spear"] = true, ["Impeccable Light Spruce Spear"] = true, ["Impeccable Jungle Spear"] = true, ["Impeccable Granite Spear"] = true, ["Impeccable Light Jungle Spear"] = true, ["Elemental Training Spear"] = true, ["Oak Wood Spear"] = true, ["Alkatraz"] = true, ["Idol"] = true, ["Thrundacrack"] = true, ["Convergence"] = true, ["Collapse"] = true, ["Guardian"] = true, ["Apocalypse"] = true, ["Hero"] = true, ["Maltic's Old Spear"] = true, ["Clash Hook"] = true, ["Deracine"] = true, ["The Berserk"] = true, ["Legendary Smasher"] = true, ["Psion Marker"] = true, ["Chaleur"] = true, ["Anchor Chain"] = true, ["Fierce Thunder"] = true, ["Pulsar"] = true, ["Rebellion"] = true, ["Fierte"] = true, ["Skyfall"] = true, ["Remikas' Righteousness"] = true, ["Heaven's Gate"] = true, ["Scythe"] = true, ["Dragon's Tongue"] = true, ["Blade of Purity"] = true, ["Thanos Warhammer"] = true, ["Rikter"] = true, ["Payment Day"] = true, ["Proxima"] = true, ["Tisaun's Proof"] = true, ["Bedruthan"] = true, ["Zephra Shredder"] = true, ["Ignition"] = true, ["Harwrol"] = true, ["Quinque"] = true, ["Tidebinder"] = true, ["Fissure"] = true, ["Dujgon Warrior Hammer"] = true, ["Bob's Mythic Spear"] = true, ["Olux's Prized Spear"] = true, ["Sanies"] = true, ["Karma"] = true, ["Kahontsi Ohstyen"] = true, ["Cicada"] = true, ["Helm Splitter"] = true, ["Demonio"] = true, ["Nightmare"] = true, ["Infidel"] = true, ["Wick"] = true, ["Braker"] = true, ["The Forsaken"] = true, ["Gert Rock Smashbanger"] = true, ["Tempo Trident"] = true, ["Infused Hive Spear"] = true, ["Veritas"] = true, ["Overreach"] = true, ["Rhythm of the Seasons"] = true}
local LIST_OF_BOWS = {["Bony Bow"] = true, ["Recursion"] = true, ["Galaxy Piercer"] = true, ["Dart Sling"] = true, ["Dread"] = true, ["Phrygian"] = true, ["Reinforced Composite Bow"] = true, ["Carvel's Sight"] = true, ["Savannah Wind"] = true, ["Slate Bow"] = true, ["Ionizer"] = true, ["Ancient Battle Crossbow"] = true, ["Meridian"] = true, ["Crossbolt"] = true, ["Life Extractor"] = true, ["Ultraviolet"] = true, ["Death's Reach"] = true, ["Ronco"] = true, ["Scorch Breath"] = true, ["Acidstream"] = true, ["Sylar"] = true, ["Cursed Bow"] = true, ["Upgraded Cursed Bow"] = true, ["Sandshooter"] = true, ["Cherufe"] = true, ["Miasma"] = true, ["Frozen Earth"] = true, ["Spirit"] = true, ["Calamaro's Bow"] = true, ["Cross-Aegis"] = true, ["Sleigh Bell"] = true, ["The Traveler"] = true, ["Snowstorm"] = true, ["Earth Relic Bow"] = true, ["Thunder Relic Bow"] = true, ["Water Relic Bow"] = true, ["Fire Relic Bow"] = true, ["Air Relic Bow"] = true, ["Relic Bow"] = true, ["Ozone"] = true, ["Meteoric Arch"] = true, ["Haze"] = true, ["Dorian"] = true, ["Krakem"] = true, ["Whirlwind"] = true, ["Plasma Ray"] = true, ["Electrolytic"] = true, ["Tonbo"] = true, ["Decay Burner"] = true, ["The Dreamer"] = true, ["Vile"] = true, ["Acrobat"] = true, ["Grounder"] = true, ["Polar Star"] = true, ["Jungle Artifact"] = true, ["Overclocker"] = true, ["Gwydion"] = true, ["Hellkite's Beak"] = true, ["Acevro"] = true, ["Toxotes"] = true, ["Ivory Bow"] = true, ["Olit Vaniek"] = true, ["Hellbow"] = true, ["Scytodidae"] = true, ["Caledonia"] = true, ["Fyrespit"] = true, ["Dragonspit"] = true, ["Aersectra"] = true, ["Crwth"] = true, ["Oktavist"] = true, ["Pine Bow"] = true, ["Sleet"] = true, ["Thunderlock"] = true, ["Tundra Strike"] = true, ["Pressure Blaster"] = true, ["Tracer"] = true, ["Djinni"] = true, ["Wybel Fluff Bow"] = true, ["Closure"] = true, ["Comrade"] = true, ["Thundering Wind"] = true, ["Packet"] = true, ["Prismatic Pendulum"] = true, ["Doubt"] = true, ["Petrified Horror"] = true, ["Arc Rifle"] = true, ["Stormcloud"] = true, ["Voidstone Lensing"] = true, ["Ensa's Resolve"] = true, ["Shajaea"] = true, ["The Rainmaker"] = true, ["Anthracite Ballista"] = true, ["Earthsky Equinox"] = true, ["Fog of Creation"] = true, ["Darkness's Dogma"] = true, ["Az"] = true, ["Freedom"] = true, ["Grandmother"] = true, ["Ignis"] = true, ["Divzer"] = true, ["Spring"] = true, ["Stratiformis"] = true, ["Epoch"] = true, ["Iron String"] = true, ["Crackshot"] = true, ["Witherhead's Bow"] = true, ["Relic"] = true, ["Skin Piercer"] = true, ["Molotov"] = true, ["Glacial Crest"] = true, ["Damnation"] = true, ["Nemract's Rage"] = true, ["Snakeroot Bow"] = true, ["Mesarock Arch"] = true, ["Tempo Trebuchet"] = true, ["Chaser"] = true, ["Thunderbolt"] = true, ["Eruption"] = true, ["Contamination"] = true, ["Evanescent"] = true, ["Infinity"] = true, ["Olux's Prized Bow"] = true, ["Soundwave"] = true, ["Clairvoyance"] = true, ["Mosquito"] = true, ["Redbeard's Hand Cannon"] = true, ["Spectral Slingshot"] = true, ["Maelstrom"] = true, ["Destructor"] = true, ["Corrupted Witherhead's Bow"] = true, ["Bob's Mythic Bow"] = true, ["Heracul"] = true, ["Firestorm Bellows"] = true, ["Gert Shootstick Tossflinger"] = true, ["Spiritshock"] = true, ["Sourscratch"] = true, ["Thanos Siege Bow"] = true, ["Torrential Tide"] = true, ["Zero"] = true, ["Plague"] = true, ["Return to Ether"] = true, ["Hellstrand"] = true, ["Alka Cometflinger"] = true, ["Gale's Force"] = true, ["Orange Lily"] = true, ["Cluster"] = true, ["Stinger"] = true, ["The Evolved"] = true, ["Infused Hive Bow"] = true, ["Deadeye"] = true, ["Hesperium"] = true, ["Air in a Can"] = true}
local LIST_OF_RELIKS = {["Dark Ambience"] = true, ["Crustacean"] = true, ["Hearts Club"] = true, ["The Naturalist"] = true, ["Stress"] = true, ["Presto"] = true, ["Prog"] = true, ["Hourglass"] = true, ["Technicolor Phase"] = true, ["Gestation"] = true, ["The Saltwater Rune"] = true, ["Grindcore"] = true, ["Boundary"] = true, ["Emotion"] = true, ["Breath of the Dragon"] = true, ["Ancient Waters"] = true, ["Conclave Crossfire"] = true, ["Tremolo"] = true, ["Ebb and Flow"] = true, ["Pangea"] = true, ["Flare Blitz"] = true, ["Upgraded Flare Blitz"] = true, ["Minus"] = true, ["Calamaro's Relik"] = true, ["Reciprocator"] = true, ["Earth Relic Relik"] = true, ["Thunder Relic Relik"] = true, ["Water Relic Relik"] = true, ["Fire Relic Relik"] = true, ["Air Relic Relik"] = true, ["Relic Relik"] = true, ["Permafrosted Saxifrage"] = true, ["Interference"] = true, ["Threshold"] = true, ["Bibliotek"] = true, ["Foreword"] = true, ["Saving Grace"] = true, ["Skyspiral"] = true, ["Sacrificial"] = true, ["Tidebreaker"] = true, ["Void Catalyst"] = true, ["Sinkhole"] = true, ["Ashes Anew"] = true, ["Azotar"] = true, ["Lycanthropy"] = true, ["Onyx Anchor"] = true, ["Poinsettia"] = true, ["Circuit Flights"] = true, ["Kilauea"] = true, ["Thousand Waves"] = true, ["Estuarine"] = true, ["Stone Crush"] = true, ["Flood Bath"] = true, ["Graviton Lance"] = true, ["Asphalt"] = true, ["Widow"] = true, ["Dying Light"] = true, ["Crook's March"] = true, ["Shine Lamp"] = true, ["Silent Night"] = true, ["Careless Whisper"] = true, ["Thermals"] = true, ["Sparkling Tones"] = true, ["Stormdrain"] = true, ["Wybel Carved Relik"] = true, ["Hardcore"] = true, ["Imperious"] = true, ["Nauticals"] = true, ["Shellcarve"] = true, ["One Thousand Voices"] = true, ["Voidstone Elrik"] = true, ["Hard Light"] = true, ["Misfit"] = true, ["Vagabond's Disgrace"] = true, ["Sigil of Resistance"] = true, ["Arkhalis"] = true, ["Timthriall"] = true, ["Silver Sound"] = true, ["Yol"] = true, ["Danse Macabre"] = true, ["Harsh Noise"] = true, ["Dusk Painter"] = true, ["Puppet Master"] = true, ["Helter Skelter"] = true, ["Cave In"] = true, ["Cruel Sun"] = true, ["Thriller"] = true, ["Fault Lines"] = true, ["Tempo Totem"] = true, ["Largo"] = true, ["Sonicboom"] = true, ["Cleansing Flame"] = true, ["Heavensent"] = true, ["Temporal Lantern"] = true, ["Discotek"] = true, ["Shine Suffocator"] = true, ["Wintergreen"] = true, ["Olux's Prized Relik"] = true, ["Mercury Bomb"] = true, ["Lightshow"] = true, ["Anthem"] = true, ["Night Rush"] = true, ["Rusted Root"] = true, ["October Fires"] = true, ["Paranoia"] = true, ["Cold Integrity"] = true, ["Ancient Runic Relik"] = true, ["Gert Bangswing Manypointystick"] = true, ["Lumina"] = true, ["Thanos Stonesinger"] = true, ["Island Chain"] = true, ["Cinnamon"] = true, ["Procrastination"] = true, ["Arbalest"] = true, ["Overdrive"] = true, ["Salpinx"] = true, ["Loaded Question"] = true, ["Crimson"] = true, ["Inferna Flamewreath"] = true, ["Conference Call"] = true, ["Royal Hydrangea"] = true, ["Cryoseism"] = true, ["Lower"] = true, ["The End"] = true, ["The Watched"] = true, ["Infused Hive Relik"] = true, ["Tachypsychia"] = true, ["Narcissist"] = true, ["Tremorcaller"] = true, ["Marionette"] = true, ["Panic Zealot"] = true, ["Beachside Conch"] = true, ["Fractal"] = true, ["Aftershock"] = true, ["Olympic"] = true, ["Hadal"] = true, ["Sunstar"] = true, ["Fantasia"] = true, ["Toxoplasmosis"] = true, ["Absolution"] = true, ["Immolation"] = true}
--tick event, called 20 times per second
function events.tick()
	local held_item = player:getHeldItem(false):getName()
	-- Check if the held weapon is shiny
	if string.find(held_item, "⬡ Shiny ") then
		shiny = true
		-- If it is, normalize it
		held_item = string.gsub(held_item, "⬡ Shiny ", "")
	else
		shiny = false
	end

	-- Wynntils changes the item name based on what you've done, prevent it from screwing up the code
	if string.find(held_item, "cast") and string.find(held_item, "spell") then
		held_item = prev_weapon
	end

	-- If you swapped what item you're holding, reset the spell
	if held_item ~= prev_weapon then
		spell = ""
		cast_window = 0
	end
	prev_weapon = held_item

	-- Determine what class you're playing based on what you're holding
	if LIST_OF_WANDS[held_item] ~= nil then
		class = "Mage"
		weapon = true
	elseif LIST_OF_DAGGERS[held_item] ~= nil then
		class = "Assassin"
		weapon = true
	elseif LIST_OF_SPEARS[held_item] ~= nil then
		class = "Warrior"
		weapon = true
	elseif LIST_OF_BOWS[held_item] ~= nil then
		class = "Archer"
		weapon = true
	elseif LIST_OF_RELIKS[held_item] ~= nil then
		class = "Shaman"
		weapon = true
	else
		weapon = false
	end

	-- Decrement the time between starting a spell, and it naturally clearing
	if cast_window > 0 then
		cast_window = cast_window - 1
	end
end

-- ====================
-- Getters
-- ====================
function wynnSpells.get_holding_shiny() return shiny end
function wynnSpells.get_shiny_weapon() return shiny end
function wynnSpells.get_holding_valid() return shiny end
function wynnSpells.get_valid_weapon() return weapon end
function wynnSpells.get_class() return class end



-- ====================
-- Dealing with Spells
-- ====================
local spell = ""
local prev_try_spell = ""

-- "reset_all", when another spell is cast, end the current spell animation, and play the new one
-- "reset_each", when the SAME spell is cast, restart it's animation. Different spells however will play their animations on top of one another
-- "play_all", when the SAME spell is cast, ignore it it's animation is currently playing. Different spells however will play their animations on top of one another
-- "play_one", when another spell is cast, ignore it if any other spell animation is currently playing
wynnSpells.anim_mode = "reset_all"

--- Returns the proper name of a spell combo
-- @param class string: The class name to pull the spell from
-- @param spell string: The spell combo to match
-- @return string: The spell name, or "?" if no match is found
local MAGE_SPELLS = {["RLR"] = "Heal", ["RRR"] = "Teleport", ["RLL"] = "Meteor", ["RRL"] = "IceSnake"}
local ASSASSIN_SPELLS = {["RLR"] = "SpinAttack", ["RRR"] = "Dash", ["RLL"] = "MultiHit", ["RRL"] = "SmokeBomb"}
local WARRIOR_SPELLS = {["RLR"] = "Bash", ["RRR"] = "Charge", ["RLL"] = "Uppercut", ["RRL"] = "WarScream"}
local ARCHER_SPELLS = {["LRL"] = "ArrowStorm", ["LLL"] = "Escape", ["LRR"] = "ArrowBomb", ["LLR"] = "ArrowShield"}
local SHAMAN_SPELLS = {["RLR"] = "Totem", ["RRR"] = "Haul", ["RLL"] = "Aura", ["RRL"] = "Uproot"}
function wynnSpells.spell_name(class, spell)
	local spell_name

	if class == "Mage" then spell_name = MAGE_SPELLS[spell]
	elseif class == "Assassin" then spell_name = ASSASSIN_SPELLS[spell]
	elseif class == "Warrior" then spell_name = WARRIOR_SPELLS[spell]
	elseif class == "Archer" then spell_name = ARCHER_SPELLS[spell]
	elseif class == "Shaman" then spell_name = SHAMAN_SPELLS[spell]
	end

	if spell_name == nil then
		return "?"
	else
		return spell_name
	end
end

--- Return the index of a spell combo
-- @param spell string: The spell combo to match
-- @return string: a textual number representing the spell, or "?" if no match is found
function wynnSpells.spell_index(spell)
	local SPELLS = {["RLR"] = "1", ["RRR"] = "2", ["RLL"] = "3", ["RRL"] = "4", ["LRL"] = "1", ["LLL"] = "2", ["LRR"] = "3", ["LLR"] = "4"}
	local spell_index = SPELLS[spell]
	if spell_index == nil then
		return "?"
	else
		return spell_index
	end
end

--- Attempt to play an animation based on the anim_mode
-- @param spell string: The spell combo to match
-- @return boolean: whether the animation was successfully matched or not
function wynnSpells.spell_animation(try_spell)
	-- Attempt to call an animation instead 
	if wynnSpells.anim_mode == "reset_each" then
		-- Attempt
		return pcall(loadstring("animations.model." .. class .. try_spell .. ":restart()"))
	elseif wynnSpells.anim_mode == "play_all" then
		-- Attempt
		return pcall(loadstring("animations.model." .. class .. try_spell .. ":play()"))
	elseif wynnSpells.anim_mode == "play_one" then 
		-- Check for 2 things:
		-- Does a previous spell exist
		-- If so, has it finished playing

		local func_exists, finished = pcall(loadstring("return animations.model." .. prev_try_spell .. ":isStopped()"))
		-- If the previous spell doesnt exist, or it has finished, start a new one
		if (func_exists == false) or finished then
			-- Attempt
			if pcall(loadstring("animations.model." .. try_spell .. ":play()")) == false then
				return false
			else 
				-- (Generic Succeeded)
				prev_try_spell = try_spell
				return true
			end
		else return func_exists -- Might be able to replace with "return false" but if it aint broke don't fix it
		end
	else -- if wynnSpells.anim_mode == "reset_all" then
		-- Attempt to play the animation
		if pcall(loadstring("animations.model." .. try_spell .. ":restart()")) == true and try_spell ~= prev_try_spell then
			-- If an animation was successfully played, forcefully stop the previously played animation
			pcall(loadstring("animations.model." .. prev_try_spell .. ":stop()"))
			-- log("worked")
			prev_try_spell = try_spell
			return true
		else
			-- log("didnt work1")
			return false
		end

	end
end

--- Quick helper function to just reverse the spell string for Archer
-- @param spell string: The spell to reverse
-- @return string: All Rs replaced with Ls and all Ls replaced with Rs
function wynnSpells.archer_equivalent(input)
	input = string.gsub(input, "R", "A")
	input = string.gsub(input, "L", "R")
	return string.gsub(input, "A", "L")
end

--- Logic behind buffering inputs and registering spells
-- @param raw integer: the raw input from the mouse, 0 for Attack, 1 for Use
-- @param invert boolean: an override for wynntils Quick Casting to ensure Archer spells are registered properly
-- @return nil
function wynnSpells.spell_casting(input, invert)
	if wynnSpells.get_valid_weapon() == false then return end
	if cast_window <= 0 then
		spell = ""
	end

	-- Stupid nonsense work around for wynntils quickcasting
	if class == "Archer" and invert then
		input = (input + 1)%2
	end

	-- Make sure a spell has a valid start
	if #spell == 0 and ((input == 1 and class == "Archer") or (input == 0 and class ~= "Archer")) then
		return
	end
	
	
	cast_window = 40
	local letter = {[0]="L", [1]="R"}-- idk any better way of doing this
	spell = spell .. letter[input]


	-- log(spell)

	
	-- Attempt to call a function by spell name (e.g. "ArrowBomb")
	if pcall(loadstring(wynnSpells.spell_name(class, spell) .. "()")) then
	-- Attempt to call a function by its class-specific generic name (e.g. MageSpell4)
	elseif pcall(loadstring(class .. "Spell" .. wynnSpells.spell_index(spell) .. "()")) then
	-- Attempt to call a function by its class-specific input combo (e.g. WarriorRRR)
	elseif pcall(loadstring(class .. spell .. "()")) then
	
	-- Attempt to play an animation by spell name (e.g. "ArrowBomb")
	elseif wynnSpells.spell_animation(wynnSpells.spell_name(class, spell)) then
	-- Attempt to play an animation by its class-specific generic name (e.g. MageSpell4)
	elseif wynnSpells.spell_animation(class .. "Spell" .. wynnSpells.spell_index(spell)) then
	-- Attempt to play an animation by its class-specific input combo (e.g. WarriorRRR)
	elseif wynnSpells.spell_animation(class .. spell) then

	-- Attempt to call a function by a generic name (e.g. Spell3)
	elseif pcall(loadstring("Spell" .. wynnSpells.spell_index(spell) .. "()")) then
	-- Attempt to call a function by a generic input combo (e.g. RLR)
	elseif pcall(loadstring(spell .. "()")) then
	elseif pcall(loadstring(wynnSpells.archer_equivalent(spell) .. "()")) then
	
	-- Attempt to play an animation by a generic name (e.g. MageSpell4)
	elseif wynnSpells.spell_animation("Spell" .. wynnSpells.spell_index(spell)) then
	-- Attempt to play an animation by a generic input combo (e.g. WarriorRRR)
	elseif wynnSpells.spell_animation(spell) then
	elseif wynnSpells.spell_animation(wynnSpells.archer_equivalent(spell)) then
	else
		-- log("didnt work")
	end

	if #spell == 3 then
		-- log("reset")
		cast_window = 0
		spell = ""
	end
end


return wynnSpells