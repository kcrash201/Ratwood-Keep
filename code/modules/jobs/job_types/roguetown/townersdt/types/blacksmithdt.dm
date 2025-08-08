/datum/subclass/blacksmithdt
	name = "Blacksmith"
	tutorial = "A skilled blacksmith, able to forge useful equipment and items out of metal, \
	only after building or finding a forge."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/townerdt/blacksmithdt

	category_tags = list(CTAG_TOWNERDT)

/datum/outfit/job/roguetown/townerdt/blacksmithdt/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	gloves = /obj/item/clothing/gloves/roguetown/leather
	cloak = /obj/item/clothing/cloak/apron/blacksmith
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/hammer/iron
	beltl = /obj/item/rogueweapon/tongs
	backl = /obj/item/storage/backpack/rogue/satchel
	pants = /obj/item/clothing/under/roguetown/sirwal/plainrandom
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	backpack_contents = list(/obj/item/flint = 1, /obj/item/recipe_book/blacksmithing = 1, /obj/item/rogueore/coal=1, /obj/item/rogueore/iron=1, /obj/item/rogueweapon/huntingknife = 1)
	if(H.gender == MALE)
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
		armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/open/random
		head = /obj/item/clothing/head/roguetown/turban/random
	else
		if(prob(50))
			shirt = /obj/item/clothing/suit/roguetown/shirt/exoticsilkbra
		else
			shirt = /obj/item/clothing/suit/roguetown/shirt/exoticsilkbra/green
	

	if(H.mind)
		H.grant_language(/datum/language/zybantine)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/axes, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/engineering, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/blacksmithing, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
		H.change_stat("strength", 2)
		H.change_stat("endurance", 1)
		H.change_stat("intelligence", 2)
		H.change_stat("constitution", 1)
		H.change_stat("speed", -1)
		H.change_stat("fortune", 1)
		ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
		if(H.age == AGE_MIDDLEAGED)
			H.mind.adjust_skillrank(/datum/skill/craft/blacksmithing, 1, TRUE)
		if(H.age == AGE_OLD)
			H.mind.adjust_skillrank(/datum/skill/craft/blacksmithing, 2, TRUE)
