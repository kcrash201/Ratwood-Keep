/datum/job/roguetown/butlerdt
	title = "Task Master"
	f_title = "Task Mistress"
	flag = BUTLER
	department_flag = COURTIERS
	selection_color = JCOLOR_COURTIER
	faction = "Station"
	total_positions = 1
	spawn_positions = 1

	allowed_races = RACES_SHUNNED_UP
	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD)

	tutorial = "You're a farmer, so to speak. You put livestock to work and put such fear into them that disobedience is a distant, half-remembered concept. Your cattle are sapient, living people, however - the many dozens of starved slaves needed to run your Sultan's palace. Armed with a whip and ruthless resolve, it is a job you take quiet satisfaction in."

	outfit = /datum/outfit/job/roguetown/butlerdt
	display_order = JDO_BUTLER
	give_bank_account = 30
	min_pq = 0
	max_pq = null
	allowed_maps = list("Desert Town")


/datum/outfit/job/roguetown/butlerdt/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.grant_language(/datum/language/zybantine)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/cooking, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/medicine, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sewing, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sneaking, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/stealing, 3, TRUE)
		H.change_stat("strength", -1)
		H.change_stat("constitution", -1)
		H.change_stat("intelligence", 2)
		H.change_stat("perception", 2)
	pants = /obj/item/clothing/under/roguetown/sirwal/plainrandom
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	belt = /obj/item/storage/belt/rogue/leather/cloth/sash/random
	beltr = /obj/item/storage/keyring/servant
	beltl = /obj/item/rogueweapon/whip/antique
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/bisht/bluegrey
	if(H.gender == MALE)
		head = /obj/item/clothing/head/roguetown/turban/dark
