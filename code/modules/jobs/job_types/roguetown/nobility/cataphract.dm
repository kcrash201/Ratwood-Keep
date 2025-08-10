/datum/job/roguetown/cataphract
	title = "Cataphract"
	flag = KNIGHT
	department_flag = NOBLEMEN
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	allowed_races = RACES_TOLERATED_UP
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED)
	allowed_patrons = ALL_NON_INHUMEN_PATRONS
	subclass_cat_rolls = list(CTAG_KNIGHT = 3)
	tutorial = "A Cataphract with expert training; \
	Born into petty nobility and raised as a squire from a young age, now you guard the royal family, answer to their commands, and act as a last beacon of chivalry in these dark times. \
	You're wholly dedicated to the standing Regent and their safety. Do not fail."
	display_order = JDO_KNIGHT
	whitelist_req = TRUE
	outfit = /datum/outfit/job/roguetown/cataphract
	give_bank_account = 22
	min_pq = 10
	max_pq = null
	allowed_maps = list("Desert Town")
	
	cmode_music = 'sound/music/combat_guard2.ogg'

/datum/job/roguetown/cataphract/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		H.advsetup = 1
		H.invisibility = INVISIBILITY_MAXIMUM
		H.become_blind("advsetup")
		if(istype(H.cloak, /obj/item/clothing/cloak/tabard/knight/guard))
			var/obj/item/clothing/S = H.cloak
			var/index = findtext(H.real_name, " ")
			if(index)
				index = copytext(H.real_name, 1,index)
			if(!index)
				index = H.real_name
			S.name = "knight tabard ([index])"
		var/prev_real_name = H.real_name
		var/prev_name = H.name
		var/honorary = "Ser"
		if(H.gender == FEMALE)
			honorary = "Dame"
		H.real_name = "[honorary] [prev_real_name]"
		H.name = "[honorary] [prev_name]"

/datum/outfit/job/roguetown/cataphract/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/heavy/cataphract
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cataphract
	gloves = /obj/item/clothing/gloves/roguetown/plate
	cloak = /obj/item/clothing/cloak/catcloak
	pants = /obj/item/clothing/under/roguetown/platelegs
	shoes = /obj/item/clothing/shoes/roguetown/armor/steel
	belt = /obj/item/storage/belt/rogue/leather/black
	backr = /obj/item/storage/backpack/rogue/satchel/black
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	
/datum/subclass/cataphract/sentinel
	name = "Sentinel"
	tutorial = "Proud defender of your ducal house. You are a master of the spear, and prefer to don yourself in the heaviest of armors."
	outfit = /datum/outfit/job/roguetown/knight/sentinel
	category_tags = list(CTAG_KNIGHT)
	maximum_possible_slots = 2

/datum/outfit/job/roguetown/cataphract/sentinel/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	beltl = /obj/item/storage/keyring/knight
	backl = /obj/item/gwstrap
	backpack_contents = list(/obj/item/rope/chain = 1, /obj/item/natural/feather = 1)
	if(H.mind)
		H.grant_language(/datum/language/zybantine)
		H.mind.adjust_skillrank(/datum/skill/combat/polearms, 5, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/crossbows, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/bows, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/riding, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/hunting, 1, TRUE)
		H.change_stat("strength", 4)
		H.change_stat("perception", 1)
		H.change_stat("intelligence", 2)
		H.change_stat("constitution", 3)
		H.change_stat("endurance", 2)
		H.change_stat("speed", -1)

	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()

	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOSEGRAB, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)

	var/weapons = list("Lucerne", "Royal Glaive")
	var/weapon_choice = input("Choose your weapon.", "TAKE UP ARMS") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Lucerne")
			r_hand = /obj/item/rogueweapon/eaglebeak/lucerne

		if("Royal Glaive")
			r_hand = /obj/item/rogueweapon/royalglaive

	var/sidearms = list("Arming Sword", "Rondel Dagger")
	var/sidearm_choice = input("Choose your sidearm.", "TAKE UP ARMS") as anything in sidearms
	switch(sidearm_choice)
		if("Arming Sword")
			beltr = /obj/item/rogueweapon/sword/short

		if("Rondel Dagger")
			beltr = /obj/item/rogueweapon/huntingknife/idagger/steel/rondel
			H.mind.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)

/datum/subclass/cataphract/champion
	name = "Champion"
	tutorial = "Noble hero and protector. You are practiced in the art of the sword, and prefer lighter armor as to be more nimble."
	outfit = /datum/outfit/job/roguetown/cataphract/champion
	category_tags = list(CTAG_KNIGHT)
	maximum_possible_slots = 2

/datum/outfit/job/roguetown/cataphract/champion/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/roguetown/bervor
	beltl = /obj/item/storage/keyring/knight
	backpack_contents = list(/obj/item/rope/chain = 1, /obj/item/natural/feather = 1)
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	backl = /obj/item/gwstrap
	if(H.mind)
		H.grant_language(/datum/language/zybantine)
		H.mind.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 5, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/maces, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/crossbows, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/bows, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/riding, 5, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/hunting, 1, TRUE)
		H.change_stat("strength", 4)
		H.change_stat("perception", 1)
		H.change_stat("intelligence", 2)
		H.change_stat("constitution", 2)
		H.change_stat("endurance", 2)
		H.change_stat("speed", 0)

	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()

	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOSEGRAB, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)

	var/weapons = list("Executioners Blade", "Estoc")
	var/weapon_choice = input("Choose your weapon.", "TAKE UP ARMS") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Executioners Blade")
			r_hand = /obj/item/rogueweapon/sword/long/exe

		if("Estoc")
			r_hand = /obj/item/rogueweapon/estoc

	var/sidearms = list("Sabre", "Rondel Dagger")
	var/sidearm_choice = input("Choose your sidearm.", "TAKE UP ARMS") as anything in sidearms
	switch(sidearm_choice)
		if("Sabre")
			beltr = /obj/item/rogueweapon/sword/sabre

		if("Rondel Dagger")
			beltr = /obj/item/rogueweapon/huntingknife/idagger/steel/rondel
			H.mind.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)

/datum/subclass/cataphract/juggernaut
	name = "Juggernaut"
	tutorial = "Indomitable. You are hidden beneath so many layers of steel you find it hard to see properly, and have taken up non-traditional weapons in turn."
	outfit = /datum/outfit/job/roguetown/cataphract/juggernaut
	category_tags = list(CTAG_KNIGHT)
	maximum_possible_slots = 1

/datum/outfit/job/roguetown/cataphract/juggernaut/pre_equip(mob/living/carbon/human/H)
	..()
	backpack_contents = list(/obj/item/rope/chain = 1, /obj/item/natural/cloth = 1, /obj/item/storage/keyring/knight = 1)
	beltl = /obj/item/rogueweapon/flail/sflail
	if(H.mind)
		H.grant_language(/datum/language/zybantine)
		H.mind.adjust_skillrank(/datum/skill/combat/whipsflails, 5, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/maces, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/crossbows, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/bows, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/riding, 5, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/hunting, 1, TRUE)
		H.change_stat("strength", 4)
		H.change_stat("perception", 1)
		H.change_stat("intelligence", 2)
		H.change_stat("constitution", 5)
		H.change_stat("endurance", 3)
		H.change_stat("speed", -3)

	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()

	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOSEGRAB, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)

	var/weapons = list("Tower Shield and Iron Mace", "Buckler and Steel Mace")
	var/weapon_choice = input("Choose your weapon.", "TAKE UP ARMS") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Tower Shield and Iron Mace")
			l_hand = /obj/item/rogueweapon/shield/tower/zybantine
			beltr = /obj/item/rogueweapon/mace

		if("Buckler and Steel Mace")
			l_hand = /obj/item/rogueweapon/shield/buckler
			beltr = /obj/item/rogueweapon/mace/steel

