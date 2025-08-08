/datum/subclass/mamluk/footman
	name = "Mamluk Footman"
	tutorial = "You are a member of the Ducal Retinue. Ensure the safety of the Duchy and their people, defend the powers that be from the horrors of the outside world, and keep the Duchy of Rockhill alive."
	outfit = /datum/outfit/job/roguetown/mamluk/footman
	category_tags = list(CTAG_MAM)

/datum/outfit/job/roguetown/mamluk/footman/pre_equip(mob/living/carbon/human/H)
	..()
	if(prob(50))
		beltl = /obj/item/rogueweapon/sword/long/rider
	else
		beltl = /obj/item/rogueweapon/stoneaxe/woodcut/steel
	backl = /obj/item/rogueweapon/shield/wood
	backpack_contents = list(/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1, /obj/item/storage/keyring/town_watch, /obj/item/rope/chain = 1, /obj/item/storage/keyring/man_at_arms = 1, /obj/item/natural/cloth = 1)
	if(H.mind)
		H.grant_language(/datum/language/zybantine)
		H.mind.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/axes, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/whipsflails, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sneaking, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		H.change_stat("strength", 2)
		H.change_stat("constitution", 3)
		H.change_stat("endurance", 2)
	H.verbs |= /mob/proc/haltyell
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
