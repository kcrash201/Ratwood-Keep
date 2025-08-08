/datum/subclass/seamstressdt
	name = "Seamster"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/towner/seamstressdt
	category_tags = list(CTAG_TOWNERDT)

/datum/outfit/job/roguetown/towner/seamstressdt/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	beltr = /obj/item/rogueweapon/huntingknife/scissors/steel
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather/cloth/sash/random
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
		H.mind.adjust_skillrank(/datum/skill/misc/sewing, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/medicine, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/stealing, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		H.change_stat("intelligence", 1)
		H.change_stat("speed", 3)  
		H.change_stat("strength", 2)
		if(H.age == AGE_MIDDLEAGED)
			H.mind.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
			H.mind.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
		if(H.age == AGE_OLD)
			H.mind.adjust_skillrank(/datum/skill/misc/sewing, 2, TRUE)
			H.mind.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
