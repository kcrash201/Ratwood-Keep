/datum/job/roguetown/nightmandt
	title = "Nightmaster"
	f_title = "Nightmatron"
	flag = NIGHTMASTER
	department_flag = PEASANTS
	faction = "Station"
	total_positions = 1
	spawn_positions = 1

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_SHUNNED_UP
	allowed_ages = ALL_AGES_LIST

	tutorial = "Owner of the Whitevein Lounge, you watch over the workers under your care, spread word of the services your lounge offers, and strive to turn a handsome profit."

	allowed_ages = ALL_AGES_LIST
	outfit = /datum/outfit/job/roguetown/nightmandt
	display_order = JDO_NIGHTMASTER
	give_bank_account = 69 //Teehee
	min_pq = 5
	max_pq = null
	allowed_maps = list("Desert Town")
	
/datum/outfit/job/roguetown/nightmandt/pre_equip(mob/living/carbon/human/H)
	..()
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	if(H.gender == MALE)
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
		pants = /obj/item/clothing/under/roguetown/sirwal/black
	else
		if(prob(50))
			shirt = /obj/item/clothing/suit/roguetown/shirt/dress/amiradress
		else
			pants = /obj/item/clothing/under/roguetown/sirwal/black
			shirt = /obj/item/clothing/suit/roguetown/shirt/exoticsilkbra/red
			mask = /obj/item/clothing/mask/rogue/exoticsilkmask/red

	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	beltr = /obj/item/storage/keyring/nightman
	belt = /obj/item/storage/belt/rogue/leather/cloth/sash/random
	beltl = /obj/item/ammo_holder/quiver/bolts
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	backpack_contents = list(/obj/item/rogueweapon/huntingknife/idagger = 1)
	if(H.mind)
		H.grant_language(/datum/language/zybantine)
		H.mind.AddSpell(new SPELL_CONVERT_ROLE_PROSTITUTE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/crossbows, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sneaking, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/stealing, 5, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/music, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/whipsflails, 2, TRUE) //How did they NOT already have this?
		H.change_stat("strength", 1)
		H.change_stat("intelligence", -1)
		H.change_stat("endurance", 2) //So they can lay pipe like the hoes do
		ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_GOODLOVER, TRAIT_GENERIC)
	if(H.dna?.species)
		if(H.gender == MALE)
			H.dna.species.soundpack_m = new /datum/voicepack/male/zeth()
		if(iself(H) || ishalfelf(H))
			armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor
		else if(isdwarf(H))
			armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor

/obj/effect/proc_holder/spell/self/convertrole/prostitute
	name = "Hire Prostitute"
	new_role = "Nightswain"
	overlay_state = "recruit_servant"
	recruitment_faction = "Prostitute"
	recruitment_message = "Work for me, %RECRUIT."
	accept_message = "I will."
	refuse_message = "I refuse."
