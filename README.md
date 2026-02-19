# wynnSpells
A very barebones script to register wynn spells to be used by Figura.
It ain't perfect, but it's good enough for me

## How to use:
There's not much to it, simply download wynnSpells.lua, put it in your model folder, dont forget to include ``local wynnSpells = require("wynnSpells")`` in your ``script.lua``, and it works right out of the box.

When a partial, or complete spell is cast, the script will call any associated functions or animations
The order in which things are called is as follows:
1. Function by Spell name ``e.g. "ArrowBomb()" or "Uproot()``
2. Function by Class-specific spell number ``e.g. "MageSpell2()" or "WarriorSpell4()"``
3. Function by Class-specific spell combo ``e.g. "AssassinR()" or "ShamanRLL"``

4. Animation by Spell name ``e.g. "animations.model.ArrowBomb:play()"``
5. Animation by Class-specific spell number ``e.g. "animations.model.MageSpell2:play()``
6. Animation by Class-specific spell combo ``e.g. "animations.model.AssassinR:play()``

7. Function by unspecified spell number ``e.g. "Spell2()" or "Spell4()"`
8. Function by unspecified spell combo ``e.g. "R()" or "RLL()"``
- This will additionally try the reverse aswell ``e.g. "L()" or "LRR()"``, so the generics *should* work for all 5 classes

10. Animation by Class-specific spell number ``e.g. "animations.model.Spell2:play()``
11. Animation by Class-specific spell combo ``e.g. "animations.model.R:play()``
- This will additionally try the reverse aswell ``e.g. "animations.model.L:play()"``, so the generics *should* work for all 5 classes

``"Spell name" as refered to by 1 and 4, are just the in-game-name, with spaces removed. (e.g. "ArrowBomb", "SmokeBomb", "Charge")``

## wynnSpells.anim_mode
an optional variable to dictate how animations are played
- ``wynnSpells.anim_mode = "reset_all"``, when another spell is cast, end the current spell animation, and play the new one
- ``wynnSpells.anim_mode = "reset_each"``, when the SAME spell is cast, restart it's animation. Different spells however will play their animations on top of one another
- ``wynnSpells.anim_mode = "play_all"``, when the SAME spell is cast, ignore it it's animation is currently playing. Different spells however will play their animations on top of one another
- ``wynnSpells.anim_mode = "play_one"``, when another spell is cast, ignore it if any other spell animation is currently playing

## Known limitations
- If an input is sent by the client, but interrupted for whatever reason by the server (Opening a bank, clicking an NPC, etc), the spell tracking will desync. (It will fix itself after a short while)
- I don't think it works with Wynntils' "invert spell controls"

## Log:
##### 2026-02-18: Uploaded it to github
