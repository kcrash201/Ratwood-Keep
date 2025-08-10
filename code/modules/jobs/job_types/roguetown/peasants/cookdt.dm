/datum/job/roguetown/cookdt
	title = "Cook"
	flag = COOK
	department_flag = PEASANTS
	faction = "Station"
	total_positions = 1
	spawn_positions = 1

	allowed_races = RACES_VERY_SHUNNED_UP
	tutorial = "Working closely with the barkeep who owns Skull Crack Inn, the cook should focus on cooking food for all the hungry mouths of Roguetown."

	outfit = /datum/outfit/job/roguetown/cookdt
	display_order = JDO_COOK
	give_bank_account = 8
	min_pq = -10
	max_pq = null
	allowed_maps = list("Desert Town")
	
/datum/outfit/job/roguetown/cookdt/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.grant_language(/datum/language/zybantine)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/cooking, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/hunting, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/labor/farming, 1, TRUE) 
		if(H.age == AGE_OLD)
			H.mind.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
			H.mind.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltl = /obj/item/key/tavern
	beltr = /obj/item/rogueweapon/huntingknife
	backl = /obj/item/storage/backpack/rogue/satchel
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
	backpack_contents = list(/obj/item/flint,/obj/item/natural/cloth/,/obj/item/key/nightman)
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
	H.change_stat("constitution", 2)
