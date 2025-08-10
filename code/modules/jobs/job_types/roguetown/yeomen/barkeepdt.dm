/datum/job/roguetown/barkeepdt
	title = "Barkeep"
	flag = BARKEEP
	department_flag = YEOMEN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1

	allowed_races = RACES_SHUNNED_UP

	tutorial = "Liquor Lodging and Lavish Baths, youre the life of the party and a rich bastard because of it. Well before that pesky merchant came around and convinced people to take up the bottle instead of the tankred, you were the reason the hardworking men and women of this town could rest."

	outfit = /datum/outfit/job/roguetown/barkeepdt
	display_order = JDO_BARKEEP
	give_bank_account = 80
	min_pq = -4
	max_pq = null
	allowed_maps = list("Desert Town")

/datum/outfit/job/roguetown/barkeepdt/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.grant_language(/datum/language/zybantine)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/cooking, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(/obj/item/natural/cloth/)
	H.change_stat("strength", 1)
	H.change_stat("constitution", 2)
	H.change_stat("endurance", 2)
	ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_CICERONE, TRAIT_GENERIC)
	if(H.gender == MALE)
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/thawb
		belt = /obj/item/storage/belt/rogue/leather/cloth/sash/random
		beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
		neck = /obj/item/storage/keyring/innkeep
		armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/open/random
		head = /obj/item/clothing/head/roguetown/turban/fancypurple
	else
		pants = /obj/item/clothing/under/roguetown/skirt/random
		shirt = /obj/item/clothing/suit/roguetown/shirt/exoticsilkbra/green
		neck = /obj/item/storage/belt/rogue/pouch/coins/mid
		belt = /obj/item/storage/belt/rogue/leather/rope
		beltl = /obj/item/storage/keyring/innkeep
