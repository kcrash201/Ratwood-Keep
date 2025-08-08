/datum/subclass/cheesemakerdt
	name = "Cheese maker"
	tutorial = "As a cheesemaker you work alongside the local farm, purchasing milk to make batches of your infamous cheeses and cheese-full recipes. Beware of rouses."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/towner/cheesemakerdt
	category_tags = list(CTAG_TOWNERDT)

/datum/outfit/job/roguetown/towner/cheesemakerdt/pre_equip(mob/living/carbon/human/H)
	..()
	H.grant_language(/datum/language/zybantine)
	H.mind.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/labor/farming, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/craft/cooking, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/craft/masonry, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/labor/fishing, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	belt = /obj/item/storage/belt/rogue/leather/cloth/sash/random
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	backl = /obj/item/storage/backpack/rogue/backpack
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid
	beltr = /obj/item/flint
	beltl = /obj/item/rogueweapon/huntingknife
	backpack_contents = list(/obj/item/cooking/pan = 1, /obj/item/reagent_containers/food/snacks/rogue/cheddar = 1, /obj/item/reagent_containers/glass/bottle/rogue/milk = 3, /obj/item/natural/cloth = 1, /obj/item/reagent_containers/powder/salt = 4)
	if(H.gender == MALE)
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/thawb/random
		head = /obj/item/clothing/head/roguetown/turban/random
	else
		if(prob(25))
			shirt = /obj/item/clothing/suit/roguetown/shirt/exoticsilkbra
			if(prob(50))
				pants = /obj/item/clothing/under/roguetown/sirwal/plainrandom
			else
				pants = /obj/item/clothing/under/roguetown/skirt/random
		if(prob(25))
			shirt = /obj/item/clothing/suit/roguetown/shirt/exoticsilkbra/green
			if(prob(50))
				pants = /obj/item/clothing/under/roguetown/sirwal/plainrandom
			else
				pants = /obj/item/clothing/under/roguetown/skirt/random
		else
			shirt = /obj/item/clothing/suit/roguetown/shirt/dress/thawb/random

	H.change_stat("strength", 2)
	H.change_stat("constitution", 2)
	H.change_stat("endurance", 1)
	H.change_stat("intelligence", 2)
	H.change_stat("perception", -1)
	H.change_stat("speed", -2)
	if(H.age == AGE_MIDDLEAGED)
		H.mind.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/masonry, 1, TRUE)
	if(H.age == AGE_OLD)
		H.mind.adjust_skillrank(/datum/skill/craft/cooking, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/masonry, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)            
