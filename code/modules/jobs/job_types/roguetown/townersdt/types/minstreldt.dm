/datum/subclass/minstreldt
	name = "Minstrel"
	tutorial = "The people love music, they crave entertainment as much as they crave food and luckily for them \
	you have always been there to provide such songs to soothe sore ears."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/townerdt/minstreldt

	category_tags = list(CTAG_TOWNERDT)

/datum/outfit/job/roguetown/townerdt/minstreldt/pre_equip(mob/living/carbon/human/H)
	..()
	H.grant_language(/datum/language/zybantine)
	H.mind.adjust_skillrank(/datum/skill/misc/music, 5, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/reading, 4, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/sewing, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/craft/carpentry, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/craft/cooking, 2, TRUE)
	pants = /obj/item/clothing/under/roguetown/sirwal/fancy/random
	gloves = /obj/item/clothing/gloves/roguetown/fingerless
	belt = /obj/item/storage/belt/rogue/leather/cloth/sash/random
	backl = /obj/item/storage/backpack/rogue/satchel
	//beltl = /obj/item/ammo_holder/bomb/smokebombs
	beltr = /obj/item/rogueweapon/huntingknife/idagger
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	if(H.gender == MALE)
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
		armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/open/random
		head = /obj/item/clothing/head/roguetown/turban/fancypurple
	else
		if(prob(33))
			shirt = /obj/item/clothing/suit/roguetown/shirt/exoticsilkbra
			mask = /obj/item/clothing/mask/rogue/exoticsilkmask
		if(prob(33))
			shirt = /obj/item/clothing/suit/roguetown/shirt/exoticsilkbra/green
			mask = /obj/item/clothing/mask/rogue/exoticsilkmask/green
		else
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
			armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/open/random
			mask = /obj/item/clothing/mask/rogue/exoticsilkmask/red

	backpack_contents = list(/obj/item/natural/feather = 1, /obj/item/paper/scroll = 1)
	var/instrument = pick(0,1,2,3,4,5)
	switch(instrument)
		if(0)
			backr = /obj/item/rogue/instrument/harp
		if(1)
			backr = /obj/item/rogue/instrument/lute
		if(2)
			backr = /obj/item/rogue/instrument/accord
		if(3)
			backr = /obj/item/rogue/instrument/guitar
		if(4)
			backr = /obj/item/rogue/instrument/flute
		if(5)
			backr = /obj/item/rogue/instrument/drum

	// gives you the most random choices but could double up...
	// Does a check, if you somehow land on the same instrument
	// you at least get a different one.
	var/second_instrument = pick(0,1,2,3,4,5)
	if(second_instrument == instrument)
		second_instrument -= 1
		if(second_instrument < 0)
			second_instrument = 5

	switch(second_instrument)
		if(0)
			beltl = /obj/item/rogue/instrument/harp
		if(1)
			beltl = /obj/item/rogue/instrument/lute
		if(2)
			beltl = /obj/item/rogue/instrument/accord
		if(3)
			beltl = /obj/item/rogue/instrument/guitar
		if(4)
			beltl = /obj/item/rogue/instrument/flute
		if(5)
			beltl = /obj/item/rogue/instrument/drum

	H.change_stat("intelligence", 2)
	H.change_stat("perception", 2)
	H.change_stat("speed", 2)
	ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_GOODLOVER, TRAIT_GENERIC)
