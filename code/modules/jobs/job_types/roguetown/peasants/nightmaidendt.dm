/datum/job/roguetown/nightmaidendt
	//Let's try to be a LITTLE less on-the-nose, huh?
	//Also it's what the job is called in code let's do it
	title = "Nightswain"
	f_title = "Nightmaiden"
	flag = WENCH
	department_flag = PEASANTS
	faction = "Station"
	total_positions = 5
	spawn_positions = 5

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_VERY_SHUNNED_UP
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED)
	subclass_cat_rolls = list(CTAG_WENCHDT = 3)

	tutorial = "Selling your body like a piece of meat in a butcher's shop, stripped of dignity and treated as a commodity, you trade in empty pleasure and lies whispered between sheets. Your value to the Nightmaster is as stock, a good to be sold, but at least it's more than nothing."

	outfit = /datum/outfit/job/roguetown/nightmaidendt
	display_order = JDO_WENCH
	give_bank_account = TRUE
	can_random = FALSE
	min_pq = 2
	max_pq = null
	allowed_maps = list("Desert Town")
	
/datum/job/roguetown/nightmaidendt/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(L)
		var/mob/living/carbon/human/H = L
		H.advsetup = 1
		H.invisibility = INVISIBILITY_MAXIMUM
		H.become_blind("advsetup")

//Standard fancy silks
/datum/subclass/nightmaidendt/dancer
	name = "Belly Dancer"
	tutorial = "In the darkness of night, illuminated by orange fire, you are an artist. Clad in fine, flowing silks you dance for the amusement of a gathered audience. Yet it is not for the skill of your work they watch, but for your body. Like spiced meat at a market, you're appraised for the carnal pleasure that might be gleamed out from your naked form."
	outfit = /datum/outfit/job/roguetown/nightmaidendt/dancer
	category_tags = list(CTAG_WENCHDT)
	maximum_possible_slots = 5
	torch = FALSE

/datum/outfit/job/roguetown/nightmaidendt/dancer/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	r_hand = /obj/item/soap/bath
	pants = /obj/item/clothing/under/roguetown/thong

	if(H.gender == MALE)
		if(prob(33))
			mask = /obj/item/clothing/mask/rogue/exoticsilkmask
			shoes = /obj/item/clothing/shoes/roguetown/anklets
			belt = /obj/item/storage/belt/rogue/leather/exoticsilkbelt
		if(prob(33))
			mask = /obj/item/clothing/mask/rogue/exoticsilkmask/green
			belt = /obj/item/storage/belt/rogue/leather/exoticsilkbelt/skirtgreen
			shoes = /obj/item/clothing/shoes/roguetown/sandals
		else
			mask = /obj/item/clothing/mask/rogue/exoticsilkmask/red
			belt = /obj/item/storage/belt/rogue/leather/exoticsilkbelt/skirtred
			shoes = /obj/item/clothing/shoes/roguetown/sandals

	else
		if(prob(33))
			shirt = /obj/item/clothing/suit/roguetown/shirt/exoticsilkbra
			mask = /obj/item/clothing/mask/rogue/exoticsilkmask
			shoes = /obj/item/clothing/shoes/roguetown/anklets
			belt = /obj/item/storage/belt/rogue/leather/exoticsilkbelt
		if(prob(33))
			shirt = /obj/item/clothing/suit/roguetown/shirt/exoticsilkbra/green
			mask = /obj/item/clothing/mask/rogue/exoticsilkmask/green
			belt = /obj/item/storage/belt/rogue/leather/exoticsilkbelt/skirtgreen
			shoes = /obj/item/clothing/shoes/roguetown/sandals
		else
			shirt = /obj/item/clothing/suit/roguetown/shirt/exoticsilkbra/red
			mask = /obj/item/clothing/mask/rogue/exoticsilkmask/red
			belt = /obj/item/storage/belt/rogue/leather/exoticsilkbelt/skirtred
			shoes = /obj/item/clothing/shoes/roguetown/sandals


	beltr = /obj/item/storage/keyring/nightman
	if(H.mind)
		H.grant_language(/datum/language/zybantine)
		H.mind.adjust_skillrank(/datum/skill/misc/sneaking, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/stealing, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/music, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/medicine, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/lockpicking, 2, TRUE) // Don't go picking any COCKS around here or we're going to have a real problem.
		H.change_stat("speed", 1)
		H.change_stat("endurance", 2)
	ADD_TRAIT(H, TRAIT_NUTCRACKER, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_GOODLOVER, TRAIT_GENERIC)


//High class prostitute
/datum/subclass/nightmaidendt/escort
	name = "Concubine"
	tutorial = "Once you belonged in a prince's harem. No more, not after they got bored of you, bored of your pleasures. Discarded like cheap wine unfit for finer palettes, now you eek out survival as yet another whore servicing lowborn and dirty peasants."
	outfit = /datum/outfit/job/roguetown/nightmaidendt/escort
	category_tags = list(CTAG_WENCHDT)
	maximum_possible_slots = 5
	torch = FALSE

/datum/outfit/job/roguetown/nightmaidendt/escort/pre_equip(mob/living/carbon/human/H)
	..()
	shoes = /obj/item/clothing/shoes/roguetown/anklets
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	r_hand = /obj/item/soap/bath
	l_hand = /obj/item/rogue/instrument/harp
	pants = /obj/item/clothing/under/roguetown/sirwal/fancy/random
	belt = /obj/item/storage/belt/rogue/leather/cloth/bandit
	if(H.gender == MALE)
		belt = /obj/item/storage/belt/rogue/leather/cloth/sash/random
		if(prob(33))
			mask = /obj/item/clothing/mask/rogue/exoticsilkmask
		if(prob(33))
			mask = /obj/item/clothing/mask/rogue/exoticsilkmask/green
		else
			mask = /obj/item/clothing/mask/rogue/exoticsilkmask/red
	else
		if(prob(33))
			shirt = /obj/item/clothing/suit/roguetown/shirt/exoticsilkbra
			mask = /obj/item/clothing/mask/rogue/exoticsilkmask
		if(prob(33))
			shirt = /obj/item/clothing/suit/roguetown/shirt/exoticsilkbra/green
			mask = /obj/item/clothing/mask/rogue/exoticsilkmask/green
		else
			shirt = /obj/item/clothing/suit/roguetown/shirt/exoticsilkbra/red
			mask = /obj/item/clothing/mask/rogue/exoticsilkmask/red

	beltr = /obj/item/storage/keyring/nightman
	if(H.mind)
		H.grant_language(/datum/language/zybantine)
		H.mind.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/stealing, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/music, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/medicine, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/cooking, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
		H.change_stat("intelligence", 1)
		H.change_stat("endurance", 2)
	ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_GOODLOVER, TRAIT_GENERIC)


// Washing Implements

/obj/item/soap/bath
	name = "herbal soap"
	desc = "A soap made from various herbs"
	uses = 10

/obj/item/soap/bath/attack(mob/target, mob/user)
	var/turf/bathspot = get_turf(target)
	if(!istype(bathspot, /turf/open/water/bath))
		to_chat(user, span_warning("They must be in the bath water!"))
		return
	if(istype(target, /mob/living/carbon/human))
		visible_message(span_info("[user] begins scrubbing [target] with the [src]."))
		if(do_after(user, 50))
			if(HAS_TRAIT(user, TRAIT_GOODLOVER))
				visible_message(span_info("[user] expertly scrubs and soothes [target] with the [src]."))
				to_chat(target, span_love("I feel so relaxed and clean!"))
				SEND_SIGNAL(target, COMSIG_ADD_MOOD_EVENT, "bathcleaned", /datum/mood_event/bathcleaned)
			else
				visible_message(span_info("[user] tries their best to scrub [target] with the [src]."))
				to_chat(target, span_warning("Ouch! That hurts!"))
			uses -= 1
			if(uses == 0)
				qdel(src)
