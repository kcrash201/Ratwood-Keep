/datum/subclass/farmerdt
	name = "Farmer"
	tutorial = "As a Peasent, you are a skilled farmer, able to grow a variety of berrys and apples. \
	Join the local Soilsmen at their farm, or make your own little orchard."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/towner/farmerdt
	category_tags = list(CTAG_TOWNERDT)

/datum/outfit/job/roguetown/towner/farmerdt/pre_equip(mob/living/carbon/human/H)
	..()
	H.grant_language(/datum/language/zybantine)
	H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/labor/farming, 4, TRUE)
	H.mind.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	belt = /obj/item/storage/belt/rogue/leather/rope
	shirt = /obj/item/clothing/suit/roguetown/shirt/dress/thawb/random
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	backr = /obj/item/storage/backpack/rogue/satchel
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	backl = /obj/item/storage/backpack/rogue/satchel
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/open/random
	mouth = /obj/item/rogueweapon/huntingknife
	beltr = /obj/item/flint
	backr = /obj/item/rogueweapon/hoe
	if(H.gender == MALE)
		head = /obj/item/clothing/head/roguetown/turban/random
	else
		if(prob(50))
			mask = /obj/item/clothing/mask/rogue/exoticsilkmask
		else
			mask = null
			
	backpack_contents = list(/obj/item/seeds/wheat=1,/obj/item/seeds/apple=1,/obj/item/ash=1)
	H.change_stat("strength", 1)
	H.change_stat("endurance", 1)
	H.change_stat("intelligence", -2)
	H.change_stat("speed", -1)
	if(H.age == AGE_MIDDLEAGED)
		H.mind.adjust_skillrank(/datum/skill/labor/farming, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
	if(H.age == AGE_OLD)
		H.mind.adjust_skillrank(/datum/skill/labor/farming, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/cooking, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sewing, 2, TRUE)
