

/datum/job/roguetown/Sultan
	title = "Sultan"
	f_title = "Sultana"
	flag = RULER
	department_flag = NOBLEMEN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	selection_color = JCOLOR_NOBLE
	allowed_races = RACES_TOLERATED_UP
	allowed_sexes = list(MALE, FEMALE)
	allowed_maps = list("Desert Town")
	can_leave_round = FALSE
	allowed_patrons = list(\
	/datum/patron/divine/astrata,\
	/datum/patron/divine/noc,\
	/datum/patron/divine/dendor,\
	/datum/patron/divine/abyssor,\
	/datum/patron/divine/ravox,\
	/datum/patron/divine/necra,\
	/datum/patron/divine/xylix,\
	/datum/patron/divine/pestra,\
	/datum/patron/divine/malum,\
	/datum/patron/divine/eora,\
	/datum/patron/zizo,\
	/datum/patron/inhumen/matthios,\
	/datum/patron/inhumen/baotha,\
	/datum/patron/inhumen/graggar\
) //combining defines into a list like this didn't work for some raisin so...

	spells = list(
		SPELL_GRANT_TITLE,
		SPELL_GRANT_NOBILITY,
		SPELL_CONVERT_ROLE_SERVANT,
		SPELL_CONVERT_ROLE_GUARD,
		SPELL_CONVERT_ROLE_BOG,
	)
	outfit = /datum/outfit/job/roguetown/sultan
	visuals_only_outfit = /datum/outfit/job/roguetown/sultan/visuals

	display_order = JDO_LORD
	tutorial = "Elevated upon your throne through a web of intrigue and political upheaval, you are the absolute authority of these lands and at the center of every plot within it. Every man, woman and child is envious of your position and would replace you in less than a heartbeat: Show them the error in their ways."
	whitelist_req = FALSE
	min_pq = 10
	max_pq = null
	give_bank_account = 1000
	required = TRUE

/datum/job/roguetown/exlord //just used to change the lords title
	title = "Sultan Emeritus"
	f_title = "Sultana Emeritus"
	flag = RULER
	department_flag = NOBLEMEN
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	display_order = JDO_LADY
	give_bank_account = TRUE


/datum/job/roguetown/sultan/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(L)
		var/list/chopped_name = splittext(L.real_name, " ")
		if(length(chopped_name) > 1)
			chopped_name -= chopped_name[1]
			GLOB.lordsurname = jointext(chopped_name, " ")
		else
			GLOB.lordsurname = "of [L.real_name]"
		SSticker.rulermob = L
		if(L.gender != FEMALE)
			to_chat(world, "<b><span class='notice'><span class='big'>[L.real_name] is Sultan of Rockhill.</span></span></b>")
			addtimer(CALLBACK(L, TYPE_PROC_REF(/mob, lord_color_choice)), 50)
		else
			to_chat(world, "<b><span class='notice'><span class='big'>[L.real_name] is Sultana of Rockhill.</span></span></b>")
			addtimer(CALLBACK(L, TYPE_PROC_REF(/mob, lord_color_choice)), 50)
		var/mob/living/carbon/human/H = L
		var/index = findtext(H.real_name, " ")
		if(index)
			index = copytext(H.real_name, 1,index)
		if(!index)
			index = H.real_name
		var/prev_real_name = H.real_name
		var/prev_name = H.name
		var/honorary = "Sultan"
		if(H.gender == FEMALE)
			honorary = "Sultana"
		H.real_name = "[honorary] [prev_real_name]"
		H.name = "[honorary] [prev_name]"
/datum/outfit/job/roguetown/sultan/pre_equip(mob/living/carbon/human/H)
	..()

	if(H.gender == MALE)
		head = /obj/item/clothing/head/roguetown/sultan
		mask = /obj/item/clothing/head/roguetown/crown/serpcrown
		l_hand = /obj/item/rogueweapon/lordscepter
		belt = /obj/item/storage/belt/rogue/leather/sultbelt
		beltr = /obj/item/gun/ballistic/firearm/arquebus_pistol
		beltl = /obj/item/ammo_holder/bullet/lead
		neck = /obj/item/storage/belt/rogue/pouch/coins/rich
		backpack_contents = list(/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1, /obj/item/powderflask = 1, /obj/item/storage/keyring/royal = 1)
		id = /obj/item/clothing/ring/active/nomag	
		pants = /obj/item/clothing/under/roguetown/tights/black
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
		armor = /obj/item/clothing/suit/roguetown/shirt/sultan
		shoes = /obj/item/clothing/shoes/roguetown/armor
		
		if(H.mind)
			H.grant_language(/datum/language/zybantine)
			H.mind.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
			H.mind.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
			H.mind.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)
			H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
			H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
			H.mind.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
			H.mind.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
			H.mind.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
			H.mind.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
			H.mind.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
			H.mind.adjust_skillrank(/datum/skill/misc/reading, 4, TRUE)
			H.mind.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
			H.mind.adjust_skillrank(/datum/skill/combat/firearms, 4, TRUE)
			if(H.age == AGE_OLD)
				H.mind.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
			H.change_stat("strength", 1)
			H.change_stat("intelligence", 3)
			H.change_stat("endurance", 3)
			H.change_stat("speed", 1)
			H.change_stat("perception", 2)
			H.change_stat("fortune", 5)

			H.dna.species.soundpack_m = new /datum/voicepack/male/evil()

		if(H.wear_mask)
			if(istype(H.wear_mask, /obj/item/clothing/mask/rogue/eyepatch))
				qdel(H.wear_mask)
				mask = /obj/item/clothing/mask/rogue/lordmask
			if(istype(H.wear_mask, /obj/item/clothing/mask/rogue/eyepatch/left))
				qdel(H.wear_mask)
				mask = /obj/item/clothing/mask/rogue/lordmask/l


		ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_NOSEGRAB, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)

	else
		head = /obj/item/clothing/head/roguetown/sultana
		mask = /obj/item/clothing/head/roguetown/crown/serpcrown
		l_hand = /obj/item/rogueweapon/lordscepter
		beltl = /obj/item/storage/keyring/royal
		neck = /obj/item/storage/belt/rogue/pouch/coins/rich
		belt = /obj/item/storage/belt/rogue/leather/cloth/lady
		gloves = /obj/item/clothing/gloves/roguetown/leather/black
		armor = /obj/item/clothing/suit/roguetown/shirt/sultana

		id = /obj/item/clothing/ring/active/nomag
		shoes = /obj/item/clothing/shoes/roguetown/shortboots
		pants = /obj/item/clothing/under/roguetown/tights/stockings/silk/white
		if(H.mind)
			H.grant_language(/datum/language/zybantine)
			H.mind.adjust_skillrank(/datum/skill/misc/stealing, 4, TRUE)
			H.mind.adjust_skillrank(/datum/skill/misc/sneaking, 3, TRUE)
			H.mind.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
			H.mind.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
			H.mind.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
			H.mind.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
			H.mind.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
			H.mind.adjust_skillrank(/datum/skill/misc/reading, 4, TRUE)
			H.mind.adjust_skillrank(/datum/skill/misc/medicine, 2, TRUE)
			H.change_stat("intelligence", 3)
			H.change_stat("endurance", 3)
			H.change_stat("speed", 2)
			H.change_stat("perception", 2)
			H.change_stat("fortune", 5)

		ADD_TRAIT(H, TRAIT_SEEPRICES, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_NUTCRACKER, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_GOODLOVER, TRAIT_GENERIC)

//	SSticker.rulermob = H

/datum/outfit/job/roguetown/sultan/visuals/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/crown/fakecrown //Prevents the crown of woe from happening again.

/datum/outfit/job/roguetown/sultan/post_equip(mob/living/carbon/human/H)
	..()
	H.virginity = FALSE
