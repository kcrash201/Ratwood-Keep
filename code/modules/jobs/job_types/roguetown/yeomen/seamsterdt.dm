/datum/job/roguetown/seamsterdt
	title = "Seamster"
	f_title = "Seamstress"
	flag = SEAMSTER
	department_flag = YEOMEN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_races = RACES_NEARLY_ALL_PLUS_SEELIE
	tutorial = "You are the Seamster. Be it repairing a brigand's leather armour, a Lord's cape, the garnments of common folk and clergy alike, you have done it all. \
				Through many sleepless nights and by the sweat of your brow you have now managed to purchase your own workshop. \
				What you do now is up to you, a needle, and a thread..."
	outfit = /datum/outfit/job/roguetown/seamsterdt
	display_order = JDO_SEAMSTER
	selection_color = JCOLOR_MERCENARY
	give_bank_account = 2
	max_pq = null
	allowed_maps = list("Desert Town")
	
/datum/outfit/job/roguetown/seamsterdt/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather/cloth/sash/random
	beltr = /obj/item/rogueweapon/huntingknife/scissors
	beltl = /obj/item/key/seamster
	backpack_contents = list(/obj/item/natural/cloth = 2, /obj/item/recipe_book/sewing = 1, /obj/item/natural/bundle/fibers/full = 1, /obj/item/needle = 1)
	if(H.gender == MALE) // We're givign males male specific clothes so they don't walk around in a dress
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/thawb/gold
		armor = /obj/item/clothing/suit/roguetown/shirt/robe/bisht/purple
		head = /obj/item/clothing/head/roguetown/turban/fancypurple
	else
		if(prob(33))
			shirt = /obj/item/clothing/suit/roguetown/shirt/exoticsilkbra
			mask = /obj/item/clothing/mask/rogue/exoticsilkmask
			pants = /obj/item/clothing/under/roguetown/skirt/random
		if(prob(33))
			shirt = /obj/item/clothing/suit/roguetown/shirt/exoticsilkbra/red
			mask = /obj/item/clothing/mask/rogue/exoticsilkmask/red
			pants = /obj/item/clothing/under/roguetown/skirt/random
		else
			shirt = /obj/item/clothing/suit/roguetown/shirt/exoticsilkbra/green
			mask = /obj/item/clothing/mask/rogue/exoticsilkmask/green
			pants = /obj/item/clothing/under/roguetown/skirt/random
	if(H.mind)
		H.grant_language(/datum/language/zybantine)
		H.mind.adjust_skillrank(/datum/skill/misc/sewing, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/medicine, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/carpentry, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/stealing, 1, TRUE)
		H.change_stat("intelligence", 2)
		H.change_stat("speed", 2)
		H.change_stat("perception", 1)
		H.change_stat("strength", -1)
		if(isseelie(H))
			H.mind.AddSpell(new SPELL_SUMMON_BERRY)
