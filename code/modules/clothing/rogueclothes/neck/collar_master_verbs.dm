/mob/proc/collar_master_control_menu()
	set name = "Collar Control"
	set category = "Collar Tab"
	var unrestricted = FALSE

	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM)
		return

	var/list/valid_slaves = list()
	for(var/mob/living/carbon/human/slave in CM.my_slaves)
		if(!slave || !slave.mind || !slave.client)
			continue
		valid_slaves[slave.real_name] = slave
		var/obj/item/clothing/neck/roguetown/cursed_collar/collar = slave.get_item_by_slot(SLOT_NECK)

	if(!length(valid_slaves))
		to_chat(src, span_warning("No valid slaves available!"))
		return

	if(length(my_special_slaves))
		unrestricted = TRUE

	var/list/selected = input(src, "Select slaves to command:", "slave Selection") as null|anything in valid_slaves
	if(!selected || !CM)
		return

	CM.temp_selected_slaves = list(valid_slaves[selected])

	var/list/options = list(
		"Select slaves" = /mob/proc/collar_master_select_slaves,
		"Listen to slaves" = /mob/proc/collar_master_listen,
		"Shock slaves" = /mob/proc/collar_master_shock,
		"Send Message" = /mob/proc/collar_master_send_message,
		"Toggle slave Speech" = /mob/proc/collar_master_toggle_speech,
		"Free slave" = /mob/proc/collar_master_release_slave,
	)

	var/list/extra_options = list(
		"Force Surrender" = /mob/proc/collar_master_force_surrender,
		"Force Strip" = /mob/proc/collar_master_force_strip,
		"Forbid/permit Clothing" = /mob/proc/collar_master_clothing,
		"Force Action" = /mob/proc/collar_master_force_action,
		"Force Love" = /mob/proc/collar_master_force_love,
		"Toggle Arousal" = /mob/proc/collar_master_force_arousal,
		"Toggle Orgasm Denial" = /mob/proc/collar_master_toggle_denial,
		"Toggle slave Hallucinations" = /mob/proc/collar_master_toggle_hallucinate,
		"Impose Will" = /mob/proc/collar_master_illusion,
	)

	if(unrestricted)
		options += extra_options
	
	var/choice = input(src, "Choose a command:", "Collar Control") as null|anything in options
	if(!choice || !CM || !length(CM.temp_selected_slaves))
		return

	var/proc_path = options[choice]
	call(src, proc_path)()

/mob/proc/collar_master_listen()
	set name = "Listen to slaves"
	set category = "Collar Tab"

	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_slaves))
		return

	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("The collar is still cooling down!"))
		return

	var/mob/living/carbon/human/slave = CM.temp_selected_slaves[1]  // Use first selected slave
	if(!slave || !slave.mind || !slave.client || !(slave in CM.my_slaves))
		to_chat(src, span_warning("Invalid slave selected!"))
		return

	if(slave.stat >= UNCONSCIOUS)
		to_chat(src, span_warning("[slave] must be conscious to establish a listening link!"))
		return

	to_chat(src, span_notice("You establish a listening link through [slave]'s collar..."))
	to_chat(slave, span_warning("Your collar tingles as your master listens through your ears!"))

	CM.toggle_listening(slave)
	CM.last_command_time = world.time

/mob/proc/collar_master_shock()
	set name = "Shock slave"
	set category = "Collar Tab"

	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_slaves))
		return

	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("The collar's power cell is still recharging!"))
		return

	var/intensity = 15  // Fixed intensity like the scepter
	CM.last_command_time = world.time
	var/shocked_count = 0

	for(var/mob/living/carbon/human/slave in CM.temp_selected_slaves)
		if(!slave || !slave.mind || !slave.client || !(slave in CM.my_slaves))
			continue

		if(slave.stat >= UNCONSCIOUS)
			to_chat(src, span_warning("[slave] must be conscious to be disciplined!"))
			continue

		if(CM.shock_slave(slave, intensity))
			shocked_count++

	if(shocked_count > 0)
		to_chat(src, span_notice("You discipline [shocked_count > 1 ? "[shocked_count] slaves" : "your slave"] with a shock."))
	else
		to_chat(src, span_warning("Failed to discipline any slaves!"))

/mob/proc/collar_master_send_message()
	set name = "Send Message"
	set category = "Collar Tab"

	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_slaves))
		return

	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("The collar's neural link is still recharging!"))
		return

	var/message = input(src, "What message should echo in your slave's mind?", "Mental Command") as text|null
	if(!message)
		return

	CM.last_command_time = world.time
	var/message_count = 0

	for(var/mob/living/carbon/human/slave in CM.temp_selected_slaves)
		if(!slave || !slave.mind || !slave.client || !(slave in CM.my_slaves))
			continue

		to_chat(slave, span_userdanger("<i>Your collar resonates with your master's voice:</i> [message]"))
		playsound(slave, 'sound/misc/vampirespell.ogg', 50, TRUE)
		slave.do_jitter_animation(15)
		message_count++

	if(message_count > 0)
		to_chat(src, span_notice("You project your will into [message_count > 1 ? "[message_count] slaves" : "your slave's"] mind."))
	else
		to_chat(src, span_warning("Failed to reach any slaves!"))

/mob/proc/collar_master_force_surrender()
	set name = "Force Surrender"
	set category = "Collar Tab"

	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_slaves))
		return

	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("The collar is still cooling down!"))
		return

	CM.last_command_time = world.time
	var/surrendered_count = 0

	for(var/mob/living/carbon/human/slave in CM.temp_selected_slaves)
		if((!slave || !slave.mind || !slave.client || !(slave in CM.my_slaves)) || !(slave in CM.my_special_slaves))
			continue

		if(slave.stat >= UNCONSCIOUS)
			to_chat(src, span_warning("[slave] must be conscious to force surrender!"))
			continue

		if(CM.force_surrender(slave))
			surrendered_count++

	to_chat(src, span_notice("Forced [surrendered_count] slaves to surrender."))

/mob/proc/collar_master_force_strip()
	set name = "Force Strip"
	set category = "Collar Tab"

	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_slaves))
		return

	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("The collar's command circuits are still cooling down!"))
		return

	CM.last_command_time = world.time
	var/stripped_count = 0

	for(var/mob/living/carbon/human/slave in CM.temp_selected_slaves)
		if(!slave || !slave.mind || !slave.client || !(slave in CM.my_slaves)  || !(slave in CM.my_special_slaves))
			continue

		// Drop held items
		slave.drop_all_held_items()

		// Remove all clothing except collar
		for(var/obj/item/I in slave.get_equipped_items())
			if(!(I.slot_flags & ITEM_SLOT_NECK))  // Don't remove collar
				slave.dropItemToGround(I, TRUE)

		to_chat(slave, span_userdanger("Your collar tingles as it forces you to remove your clothing!"))
		slave.visible_message(span_warning("[slave]'s collar pulses with light as they frantically strip their clothing!"))
		playsound(slave, 'sound/misc/vampirespell.ogg', 50, TRUE)
		stripped_count++

	if(stripped_count > 0)
		to_chat(src, span_notice("You command [stripped_count > 1 ? "[stripped_count] slaves" : "your slave"] to strip."))
	else
		to_chat(src, span_warning("Failed to make any slaves strip!"))

/mob/proc/collar_master_clothing()
	set name = "Clothing Permission"
	set category = "Collar Tab"

	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_slaves))
		return

	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("The collar's behavioral circuits need time to recalibrate!"))
		return

	CM.last_command_time = world.time

	for(var/mob/living/carbon/human/slave in CM.temp_selected_slaves)
		if(!slave || !slave.mind || !slave.client || !(slave in CM.my_slaves) || !(slave in CM.my_special_slaves))
			continue

		if(HAS_TRAIT_FROM(slave, TRAIT_NUDIST, COLLAR_TRAIT))
			REMOVE_TRAIT(slave, TRAIT_NUDIST, COLLAR_TRAIT)
			to_chat(slave, span_notice("Your collar hums softly as your master grants you permission to wear clothing."))
			slave.visible_message(span_notice("[slave]'s collar glows briefly as they are permitted to dress."))
			playsound(slave, 'sound/misc/vampirespell.ogg', 50, TRUE)
			to_chat(src, span_notice("You grant [slave.real_name] permission to wear clothing."))
		else
			ADD_TRAIT(slave, TRAIT_NUDIST, COLLAR_TRAIT)
			to_chat(slave, span_notice("Your collar hums softly as your master denies you permission to put clothing on."))
			slave.visible_message(span_notice("[slave]'s collar glows briefly as they are forbidden to dress."))
			playsound(slave, 'sound/misc/vampirespell.ogg', 50, TRUE)
			to_chat(src, span_notice("You deny [slave.real_name] permission to wear clothing."))

/mob/proc/collar_master_toggle_speech()
	set name = "Toggle Speech"
	set category = "Collar Tab"

	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_slaves))
		return

	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("The collar's vocal inhibitors need time to cycle!"))
		return

	CM.last_command_time = world.time
	var/toggled_count = 0

	for(var/mob/living/carbon/human/slave in CM.temp_selected_slaves)
		if(!slave || !slave.mind || !slave.client || !(slave in CM.my_slaves))
			continue

		if(CM.toggle_speech(slave))
			toggled_count++

	to_chat(src, span_notice("Toggled speech for [toggled_count] slaves."))

/mob/proc/collar_master_force_action()
	set name = "Force Action"
	set category = "Collar Tab"

	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_slaves))
		return

	var/message = input(src, "What action should your slaves perform?", "Command Performance") as text|null
	if(!message || !CM || !length(CM.temp_selected_slaves))
		return

	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("The collar's control matrix is still recharging!"))
		return

	CM.last_command_time = world.time
	var/action_count = 0

	for(var/mob/living/carbon/human/slave in CM.temp_selected_slaves)
		if(!slave || !slave.mind || !slave.client || !(slave in CM.my_slaves) || !(slave in CM.my_special_slaves))
			continue

		to_chat(slave, span_userdanger("Your collar compels you to perform an action!"))
		slave.visible_message(span_warning("[slave]'s collar pulses as they are forced to act!"))
		slave.say(message) // The game will automatically handle * for emotes
		slave.do_jitter_animation(15)
		playsound(slave, 'sound/misc/vampirespell.ogg', 50, TRUE)
		action_count++

	if(action_count > 0)
		to_chat(src, span_notice("You compel [action_count > 1 ? "[action_count] slaves" : "your slave"] to perform your commanded action."))
	else
		to_chat(src, span_warning("Failed to make any slaves perform the action!"))

/mob/proc/collar_master_force_love()
	set name = "Force Love"
	set category = "Collar Tab"

	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_slaves))
		return

	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("The collar is still cooling down!"))
		return

	CM.last_command_time = world.time

	for(var/mob/living/carbon/human/slave in CM.temp_selected_slaves)
		if(!slave || !slave.mind || !slave.client || !(slave in CM.my_slaves) || !(slave in CM.my_special_slaves))
			continue

		// Toggle love status
		if(slave.has_status_effect(/datum/status_effect/in_love))
			slave.remove_status_effect(/datum/status_effect/in_love)
			REMOVE_TRAIT(slave, TRAIT_LOVESTRUCK, COLLAR_TRAIT)
			to_chat(slave, span_notice("The overwhelming attraction fades away..."))
		else
			slave.apply_status_effect(/datum/status_effect/in_love, src)
			ADD_TRAIT(slave, TRAIT_LOVESTRUCK, COLLAR_TRAIT)
			to_chat(slave, span_love("You feel an overwhelming attraction to [src]!"))
		playsound(slave, 'sound/misc/vampirespell.ogg', 50, TRUE)

	to_chat(src, span_notice("You toggle love status for [length(CM.temp_selected_slaves)] slaves."))

/mob/proc/collar_master_force_arousal()
	set name = "Toggle Arousal"
	set category = "Collar Tab"

	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_slaves))
		return

	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("The collar is still cooling down!"))
		return

	CM.last_command_time = world.time
	var/affected_slaves = 0

	for(var/mob/living/carbon/human/slave in CM.temp_selected_slaves)
		if(!slave || !slave.mind || !slave.client || !(slave in CM.my_slaves) || !(slave in CM.my_special_slaves))
			continue

		if(CM.toggle_arousal(slave))
			affected_slaves++

	to_chat(src, span_notice("Toggled arousal for [affected_slaves] slaves."))

/mob/proc/collar_master_toggle_denial()
	set name = "Toggle Orgasm Denial"
	set category = "Collar Tab"

	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_slaves))
		return

	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("The collar is still cooling down!"))
		return

	CM.last_command_time = world.time
	CM.deny_orgasm = !CM.deny_orgasm
	var/toggle_count = 0

	for(var/mob/living/carbon/human/slave in CM.temp_selected_slaves)
		if(!slave || !slave.mind || !slave.client || !(slave in CM.my_slaves) || !(slave in CM.my_special_slaves))
			continue

		if(CM.toggle_denial(slave))
			toggle_count++

	to_chat(src, span_notice("Toggled orgasm restriction for [toggle_count] slaves."))

/mob/proc/collar_master_toggle_hallucinate()
	set name = "Toggle slave Hallucinations"
	set category = "Collar Tab"

	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_slaves))
		return

	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("The collar is still cooling down!"))
		return

	CM.last_command_time = world.time

	for(var/mob/living/carbon/human/slave in CM.temp_selected_slaves)
		if(!slave || !slave.mind || !slave.client || !(slave in CM.my_slaves) || !(slave in CM.my_special_slaves))
			continue

		if(slave.has_trauma_type(/datum/brain_trauma/mild/hallucinations))
			slave.cure_trauma_type(/datum/brain_trauma/mild/hallucinations, TRAUMA_RESILIENCE_BASIC)
			to_chat(slave, span_notice("Your collar pulses and the world becomes clearer."))
		else
			slave.gain_trauma(/datum/brain_trauma/mild/hallucinations, TRAUMA_RESILIENCE_BASIC)
			to_chat(slave, span_warning("Your collar pulses and the world begins to shift and warp!"))
		playsound(slave, 'sound/misc/vampirespell.ogg', 50, TRUE)

	to_chat(src, span_notice("You toggle hallucinations for [length(CM.temp_selected_slaves)] slaves."))

/mob/proc/collar_master_illusion()
	set name = "Create Illusion"
	set category = "Collar Tab"

	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_slaves))
		return

	var/message = input(src, "What should your slave, see, or feel?", "Impose will") as message|null
	if(!message || !CM || !length(CM.temp_selected_slaves))
		return

	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("The collar is still cooling down!"))
		return

	CM.last_command_time = world.time

	for(var/mob/living/carbon/human/slave in CM.temp_selected_slaves)
		if(!slave || !slave.mind || !slave.client || !(slave in CM.my_slaves) || !(slave in CM.my_special_slaves))
			continue

		// Send message directly to slave's chat
		to_chat(slave, message)
		playsound(slave, 'sound/misc/vampirespell.ogg', 50, TRUE)

	to_chat(src, span_notice("You create an illusion for [length(CM.temp_selected_slaves)] slaves."))

/mob/proc/collar_master_select_slaves()
	set name = "Select slaves"
	set category = "Collar Tab"

	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM)
		return

	if(!length(CM.my_slaves))
		to_chat(src, span_warning("You have no slaves to select!"))
		return

	var/list/slave_options = list()
	for(var/mob/living/carbon/human/slave in CM.my_slaves)
		if(!slave || slave.stat == DEAD)
			continue
		slave_options[slave.name] = slave

	if(!length(slave_options))
		to_chat(src, span_warning("No valid slaves available!"))
		return

	var/list/selected = input(src, "Select slaves to command:", "slave Selection") as null|anything in slave_options
	if(!selected)
		return

	CM.temp_selected_slaves.Cut()
	if(islist(selected))
		for(var/name in selected)
			CM.temp_selected_slaves += slave_options[name]
	else
		CM.temp_selected_slaves += slave_options[selected]

	to_chat(src, span_notice("Selected [length(CM.temp_selected_slaves)] slaves."))

/mob/proc/collar_master_toggle_orgasm()
	set name = "Toggle Orgasm Denial"
	set category = "Collar Tab"

	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_slaves))
		return

	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("The collar is still cooling down!"))
		return

	CM.last_command_time = world.time
	CM.deny_orgasm = !CM.deny_orgasm
	var/toggle_count = 0

	for(var/mob/living/carbon/human/slave in CM.temp_selected_slaves)
		if(!slave || !slave.mind || !slave.client || !(slave in CM.my_slaves))
			continue

		if(CM.toggle_denial(slave))
			toggle_count++

	to_chat(src, span_notice("Toggled orgasm restriction for [toggle_count] slaves."))

/mob/proc/collar_master_release_slave()
	set name = "Release slave"
	set category = "Collar Tab"

	var/datum/component/collar_master/CM = mind.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_slaves))
		return

	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("The collar is still cooling down!"))
		return

	var/confirm = alert("Are you sure you want to release the selected slaves?", "Release Confirmation", "Yes", "No")
	if(confirm != "Yes")
		return

	CM.last_command_time = world.time
	var/released_count = 0

	for(var/mob/living/carbon/human/slave in CM.temp_selected_slaves)
		if(!slave || !slave.mind || !(slave in CM.my_slaves))
			continue

		// Handle collar removal properly
		var/obj/item/clothing/neck/roguetown/cursed_collar/collar = slave.get_item_by_slot(SLOT_NECK)
		if(istype(collar))
			REMOVE_TRAIT(collar, TRAIT_NODROP, CURSED_ITEM_TRAIT)
			slave.dropItemToGround(collar, force = TRUE)

		// Let cleanup_slave handle trait removal and slavebourne stats
		CM.cleanup_slave(slave)
		CM.temp_selected_slaves -= slave

		to_chat(slave, span_notice("You have been released from your collar's control!"))
		released_count++

	if(released_count > 0)
		to_chat(src, span_notice("Released [released_count] slaves from your control."))
	else
		to_chat(src, span_warning("Failed to release any slaves!"))

/mob/proc/collar_master_help()
	set name = "Collar Help"
	set category = "Collar Tab"

	var/datum/component/collar_master/CM = mind.GetComponent(/datum/component/collar_master)
	if(!CM)
		return

	var/help_text = {"<span class='notice'><b>Collar Master Commands:</b>
	- Select slaves: Choose which slaves to affect with commands
	- Send Message: Send a message through the collar
	- Force Surrender: Force slaves to submit
	- Shock slave: Punish slaves with varying intensity
	- Release slave: Free slaves from your control
	- Listen to slave: Hear what your slave hears
	- Force Strip: Strip your slave and forbid them from wearing clothes
	- Forbid/permit Clothing: Make your slave unable to dress themselves
	- Toggle slave Speech: Shuts the slave up, they can only make animal noises
	- Force Action: They are forced to say or emote what you type
	- Force Love: They are forced to love you
	- Toggle Arousal: Toggles their arousal
	- Toggle Orgasm Denial: Deny orgasms
	- Toggle slave Hallucinations: They will hear things that are not there
	- Impose Will: Send an unfiltered message to your slave, this could be something they see, feel, etc
	- Free slave: Collar will fall to the ground

	Note: Most commands have a [CM.command_cooldown/10] second cooldown.
	Currently controlling [length(CM.my_slaves)] slaves with [length(CM.temp_selected_slaves)] selected.</span>"}

	to_chat(src, help_text)


/mob/proc/collar_master_releaseall()
	set name = "Release All slaves"
	set category = "Collar Tab"

	var/datum/component/collar_master/CM = mind.GetComponent(/datum/component/collar_master)
	if(!CM)
		return
	qdel(CM)
