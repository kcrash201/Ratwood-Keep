/datum/job/roguetown/shophanddt
	title = "Shophand"
	flag = SHOPHAND
	department_flag = YOUNGFOLK
	faction = "Station"
	total_positions = 1
	spawn_positions = 1

	allowed_races = RACES_SHUNNED_UP
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_ADULT)
	
	tutorial = "The Merchant has taken you under his wing to learn the arcane arts of mercantilism, numeracy, literacy, and the joy of organizing the shelves. \
	It is mind numbing and repetitive, but at least you have a roof over your head and comfortable surroundings. Given time, perhaps you will run the town's barter."

	outfit = /datum/outfit/job/roguetown/shophanddt
	display_order = JDO_SHOPHAND
	give_bank_account = TRUE
	min_pq = -10
	max_pq = null
	allowed_maps = list("Desert Town")
	
	cmode_music = 'sound/music/combat_giza.ogg'

/datum/outfit/job/roguetown/shophanddt/pre_equip(mob/living/carbon/human/H)
	..()
	ADD_TRAIT(H, TRAIT_SEEPRICES, "[type]")
	pants = /obj/item/clothing/under/roguetown/sirwal/fancy/random
	belt = /obj/item/storage/belt/rogue/leather/cloth/sash/random
	backl = /obj/item/storage/backpack/rogue/satchel
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/open/random
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltl = /obj/item/storage/keyring/shophand
	if(H.gender == MALE)
		head = /obj/item/clothing/head/roguetown/turban/random
	else
		if(prob(33))
			mask = /obj/item/clothing/mask/rogue/exoticsilkmask
		if(prob(33))
			mask = /obj/item/clothing/mask/rogue/exoticsilkmask/green
		else
			mask = /obj/item/clothing/mask/rogue/exoticsilkmask/red

	if(H.mind)
		//basically orphan+ skills
		H.grant_language(/datum/language/zybantine)
		H.mind.adjust_skillrank(/datum/skill/misc/stealing, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sneaking, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.change_stat("strength", -2)
		H.change_stat("intelligence", 1)
		H.change_stat("perception", 1)
		H.change_stat("fortune", 2)
