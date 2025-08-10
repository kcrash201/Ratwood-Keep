/// The original hierarchy for barrels and buckets is kind of messy, and I didn't want to refactor it all to have sane subtypes.


/obj/structure/fermenting_barrel/sandpot
	name = "sand pot"
	desc = ""
	icon = 'icons/desert_town/pots.dmi'
	icon_state = "sandpot1"

/obj/structure/fermenting_barrel/fancypot
	name = "fancy pot"
	desc = ""
	icon = 'icons/desert_town/pots.dmi'
	icon_state = "fancypot1"


/obj/item/reagent_containers/glass/bucket/wooden/tinypot
	name = "tiny pot"
	icon = 'icons/desert_town/pots.dmi'
	icon_state = "tinypot1"



/obj/structure/fermenting_barrel/sandpot/Initialize()
	. = ..()
	icon_state = "sandpot[rand(1, 4)]"
	
/obj/structure/fermenting_barrel/fancypot/Initialize()
	. = ..()
	icon_state = "fancypot[rand(1, 4)]"
	

// Subtypes for sandpots
/obj/structure/fermenting_barrel/sandpot/random/water/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/water, rand(0,900))

/obj/structure/fermenting_barrel/sandpot/random/beer/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/consumable/ethanol/beer, rand(0,900))

/obj/structure/fermenting_barrel/sandpot/random/wine/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/consumable/ethanol/wine, rand(0,900))

/obj/structure/fermenting_barrel/sandpot/water/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/water,900)

/obj/structure/fermenting_barrel/sandpot/beer/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/consumable/ethanol/beer,900)

/obj/structure/fermenting_barrel/sandpot/wine/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/consumable/ethanol/wine,900)	


// Subtypes for fancypots
/obj/structure/fermenting_barrel/fancypot/random/water/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/water, rand(0,900))

/obj/structure/fermenting_barrel/fancypot/random/beer/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/consumable/ethanol/beer, rand(0,900))

/obj/structure/fermenting_barrel/fancypot/random/wine/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/consumable/ethanol/wine, rand(0,900))

/obj/structure/fermenting_barrel/fancypot/water/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/water,900)

/obj/structure/fermenting_barrel/fancypot/beer/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/consumable/ethanol/beer,900)

/obj/structure/fermenting_barrel/fancypot/wine/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/consumable/ethanol/wine,900)	
