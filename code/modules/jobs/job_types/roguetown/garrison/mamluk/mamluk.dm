/datum/job/roguetown/mamluk
	title = "Mamluk"
//	map_specific_title = list("Mamluk", "Mamluk") //0 = rockhill, 1 = zybantium, 2 = etc.

	flag = MANATARMS
	department_flag = GARRISON
	faction = "Station"
	total_positions = 11
	spawn_positions = 11

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_TOLERATED_UP
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	tutorial = "Having proven yourself loyal and capable, you are entrusted to defend the Royal Family and their Court, \
				trained regularly in combat and siege warfare you stand a small chance of surviving the Sultan's reign. \
				It's an honor to die as part of His Highness' retinue, the Marshal reminds you every night."
	display_order = JDO_CASTLEGUARD
	whitelist_req = TRUE

	outfit = /datum/outfit/job/roguetown/mamluk
	give_bank_account = 22
	min_pq = 6
	max_pq = null
	subclass_cat_rolls = list(CTAG_MAM = 4)
	allowed_maps = list("Desert Town")

	cmode_music = 'sound/music/combat_guard2.ogg'

/datum/job/roguetown/mamluk/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(istype(H.cloak, /obj/item/clothing/cloak/stabard/surcoat/guard))
			var/obj/item/clothing/S = H.cloak
			var/index = findtext(H.real_name, " ")
			if(index)
				index = copytext(H.real_name, 1,index)
			if(!index)
				index = H.real_name
			S.name = "man-at-arms jupon ([index])"
		H.advsetup = 1
		H.invisibility = INVISIBILITY_MAXIMUM
		H.become_blind("advsetup")

/datum/outfit/job/roguetown/mamluk/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/mamalukehelm
	pants = /obj/item/clothing/under/roguetown/chainlegs
	gloves = /obj/item/clothing/gloves/roguetown/chain
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	armor = /obj/item/clothing/suit/roguetown/armor/mamaluke
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	shoes = /obj/item/clothing/shoes/roguetown/armor
	belt = /obj/item/storage/belt/rogue/leather/noblesash
	backr = /obj/item/storage/backpack/rogue/satchel/black
	ADD_TRAIT(H, TRAIT_BOGVULNERABLE, TRAIT_GENERIC)	//applies debuff of -2end -2 spd when in the bog
