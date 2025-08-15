#define COLLAR_TRAIT "collar_master"
#define EMOTE_MESSAGE "emote_message"
#define EMOTE_SOURCE "emote_source"
#define ANTAGONIST_PREVIEW_ICON_SIZE 96
#define COMSIG_LIVING_SURRENDER "living_surrender"
#define COLLAR_SURRENDER_TIME 10 SECONDS
#define COMSIG_MOB_CLICK_SHIFT "mob_click_shift"
#define COMPONENT_INTERRUPT_CLICK "interrupt_click"
#define HEARING_MESSAGE_MODE "message_mode"
#define MODE_SAY "say"

GLOBAL_LIST_EMPTY(collar_masters)

/datum/status_effect/surrender/collar
    id = "collar_surrender"
    duration = COLLAR_SURRENDER_TIME
    alert_type = /atom/movable/screen/alert/status_effect/collar_surrender

/atom/movable/screen/alert/status_effect/collar_surrender
    name = "Forced Surrender"
    desc = "Your collar forces you to submit!"
    icon_state = "surrender"

/datum/component/collar_master
	var/datum/mind/mindparent
	var/list/my_slaves = list()
	var/list/my_special_slaves = list() ///Used to determine if a slave is eligible for more intrusive actions
	var/list/temp_selected_slaves = list()
	var/listening = FALSE
	var/deny_orgasm = FALSE
	var/dominating = FALSE
	var/silenced = FALSE
	var/scrying = FALSE
	var/last_command_time = 0
	var/command_cooldown = 2 SECONDS
	var/static/list/slave_sounds = list(
		"*lets out a soft whimper",
		"*whines quietly",
		"*makes a needy sound",
		"*lets out a submissive mewl",
		"*makes a pathetic noise",
		"*whimpers needily",
		"*mewls submissively",
		"*pants heavily",
		"*lets out a desperate whine",
		"*makes a pleading sound"
	)
	var/list/registered_slaves = list()
	var/speech_altered = FALSE
	var/mob/living/carbon/human/original_slave_body
	var/mob/living/carbon/human/original_master_body
	var/mob/living/carbon/human/listening_slave

/datum/component/collar_master/Initialize(...)
	. = ..()
	mindparent = parent
	GLOB.collar_masters += mindparent

/datum/component/collar_master/Destroy(force, silent)
	. = ..()
	for(var/slave in my_slaves)
		cleanup_slave(slave)
	GLOB.collar_masters -= mindparent

/datum/component/collar_master/proc/add_slave(mob/living/carbon/human/slave)
    if(!slave || (slave in my_slaves))
        return FALSE

    // Add to lists
    my_slaves += slave
    registered_slaves += slave

    // Register all signals including attack signals
    RegisterSignal(slave, COMSIG_MOB_SAY, PROC_REF(on_slave_say))
    RegisterSignal(slave, COMSIG_MOB_DEATH, PROC_REF(on_slave_death))
    RegisterSignal(slave, COMSIG_HUMAN_MELEE_UNARMED_ATTACK, PROC_REF(on_slave_attack))
    RegisterSignal(slave, COMSIG_MOB_ATTACK_HAND, PROC_REF(on_slave_attack))
    RegisterSignal(slave, COMSIG_ITEM_ATTACK, PROC_REF(on_slave_attack))
    RegisterSignal(slave, COMSIG_LIVING_ATTACKED_BY, PROC_REF(on_slave_attack))

    register_slave(slave)

    // Get the collar and ensure it's properly set up
    var/obj/item/clothing/neck/roguetown/cursed_collar/collar = slave.get_item_by_slot(SLOT_NECK)
    if(istype(collar))
        // Set master before sending signal
        collar.collar_master = mindparent?.current
        if(!collar.collar_master)
            return FALSE

        if(collar.restricted_collar)
            my_special_slaves += slave
        
        // Send signal first
        SEND_SIGNAL(slave, COMSIG_CARBON_GAIN_COLLAR, collar)

        // Wait a tick before giving feedback to allow signal to process
        addtimer(CALLBACK(src, PROC_REF(give_collar_feedback), slave), 0.1 SECONDS)

        // Verify signal was received and processed
        addtimer(CALLBACK(src, PROC_REF(verify_collar_binding), slave, collar), 0.2 SECONDS)

    return TRUE

/datum/component/collar_master/proc/give_collar_feedback(mob/living/carbon/human/slave)
    if(!slave || !(slave in my_slaves))
        return
    to_chat(slave, span_notice("The collar tightens as it recognizes its master!"))
    to_chat(parent, span_notice("You feel the collar bind to [slave]'s will."))

/datum/component/collar_master/proc/verify_collar_binding(mob/living/carbon/human/slave, obj/item/clothing/neck/roguetown/cursed_collar/collar)
	if(!slave || !collar || !collar.collar_master)
		return

	// Prevent self-collaring
	if(slave == collar.collar_master)
		to_chat(slave, span_warning("The collar refuses to clasp shut."))
		slave.dropItemToGround(collar, force = TRUE)
		return FALSE

	to_chat(slave, span_notice("Your collar pulses, reinforcing your master's control..."))
	SEND_SIGNAL(slave, COMSIG_CARBON_GAIN_COLLAR, collar)
	addtimer(CALLBACK(src, PROC_REF(final_verify_binding), slave, collar), 0.2 SECONDS)

/datum/component/collar_master/proc/final_verify_binding(mob/living/carbon/human/slave, obj/item/clothing/neck/roguetown/cursed_collar/collar)
    if(!slave || !collar || !collar.collar_master)
        return

    SEND_SIGNAL(slave, COMSIG_CARBON_GAIN_COLLAR, collar)

/datum/component/collar_master/proc/on_slave_say(datum/source, list/speech_args)
    SIGNAL_HANDLER
    var/mob/living/carbon/human/slave = source
    if(!slave || !(slave in my_slaves))
        return

    if(speech_altered)
        speech_args[SPEECH_MESSAGE] = ""  // Clear the speech message
        var/emote_text = pick(slave_sounds)
        emote_text = replacetext(emote_text, "*", "") // Remove asterisk
        slave.visible_message(span_emote("<b>[slave]</b> [emote_text]"))
        return COMPONENT_CANCEL_SAY

/datum/component/collar_master/proc/do_slave_emote(mob/living/carbon/human/slave)
    if(!slave || !(slave in my_slaves))
        return
    slave.emote("me", EMOTE_VISIBLE, pick(slave_sounds))

/datum/component/collar_master/proc/on_slave_death(datum/source)
    SIGNAL_HANDLER
    var/mob/living/carbon/human/slave = source
    if(!slave || !(slave in my_slaves))
        return
    addtimer(CALLBACK(src, PROC_REF(cleanup_slave), slave), 0.1 SECONDS)

/datum/component/collar_master/proc/remove_slave(mob/living/carbon/human/slave)
    if(!slave || !(slave in registered_slaves))
        return FALSE

    UnregisterSignal(slave, list(
        COMSIG_MOB_SAY,
        COMSIG_MOB_DEATH,
        COMSIG_HUMAN_MELEE_UNARMED_ATTACK,
        COMSIG_MOB_ATTACK_HAND,
        COMSIG_ITEM_ATTACK,
        COMSIG_LIVING_ATTACKED_BY
    ))

    registered_slaves -= slave
    cleanup_slave(slave)
    return TRUE

/datum/component/collar_master/proc/on_slave_attack(datum/source, atom/target)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/slave = source
	if(!slave || !(slave in my_slaves))
		return COMPONENT_CANCEL_ATTACK

	// Block attacks against the master only if on harm intent
	if(target == mindparent?.current && slave.used_intent.type == INTENT_HARM)
		to_chat(slave, span_warning("Your collar shocks you as you try to attack your master!"))
		INVOKE_ASYNC(src, PROC_REF(shock_slave), slave, 10)
		return COMPONENT_CANCEL_ATTACK

	return COMPONENT_CANCEL_ATTACK

/datum/component/collar_master/proc/shock_slave(mob/living/carbon/human/slave, intensity = 10)
    if(!slave || !(slave in my_slaves))
        return FALSE

    // Calculate damage based on intensity
    var/damage = intensity * 0.5

    // Apply damage and effects
    slave.adjustFireLoss(damage)
    slave.staminaloss += intensity*2
    slave.Knockdown(intensity * 0.2 SECONDS)
    slave.do_jitter_animation(intensity)

    // Visual effects
    slave.visible_message(span_danger("[slave]'s collar crackles with electricity!"), \
                       span_userdanger("Your collar sends searing pain through your body!"))

    var/turf/T = get_turf(slave)
    if(T)
        new /obj/effect/temp_visual/cult/sparks(T)
        playsound(T, list('sound/items/stunmace_hit (1).ogg','sound/items/stunmace_hit (2).ogg'), 50, TRUE)
        do_sparks(2, FALSE, slave)

    // Add a temporary overlay effect
    slave.flash_fullscreen("redflash3")
    addtimer(CALLBACK(slave, TYPE_PROC_REF(/mob/living, clear_fullscreen), "pain"), 2 SECONDS)

    return TRUE

/datum/component/collar_master/proc/select_slaves(mob/user, action_name = "", allow_multiple = FALSE)
    var/list/valid_slaves = list()
    for(var/mob/living/carbon/human/slave in my_slaves)
        if(!slave || !slave.mind || !slave.client)
            continue
        valid_slaves += slave

    if(!length(valid_slaves))
        return list()

    if(allow_multiple)
        var/list/selected = input(user, "Choose slaves to [action_name]:", "slave Selection") as null|anything in valid_slaves
        return selected ? selected : list()
    else
        var/mob/living/carbon/human/selected = input(user, "Choose a slave to [action_name]:", "slave Selection") as null|anything in valid_slaves
        return selected ? list(selected) : list()

/datum/component/collar_master/proc/toggle_listening(mob/living/carbon/human/slave)
    if(!slave || !(slave in my_slaves))
        return FALSE

    listening = !listening
    listening_slave = listening ? slave : null

    if(listening)
        // Add master to slave's message viewers
        RegisterSignal(slave, COMSIG_MOVABLE_HEAR, PROC_REF(relay_heard))
        RegisterSignal(slave, COMSIG_MOB_EMOTE, PROC_REF(relay_emote))
        to_chat(mindparent.current, span_notice("You start listening through [slave]'s collar."))
        to_chat(slave, span_warning("Your collar tingles as your master listens through your ears!"))
    else
        // Remove master from slave's message viewers
        UnregisterSignal(slave, list(COMSIG_MOVABLE_HEAR, COMSIG_MOB_EMOTE))
        listening_slave = null
        to_chat(mindparent.current, span_notice("You stop listening through [slave]'s collar."))
        to_chat(slave, span_notice("Your collar relaxes as your master stops listening."))

    return TRUE

/datum/component/collar_master/proc/relay_heard(datum/source, list/hearing_args)
    SIGNAL_HANDLER
    var/mob/living/carbon/human/slave = source
    if(!slave || !(slave in my_slaves) || !listening || slave != listening_slave)
        return

    var/message = hearing_args[HEARING_MESSAGE]
    if(message)
        to_chat(mindparent.current, span_notice("<i>Through [slave]'s collar: [message]</i>"))

/datum/component/collar_master/proc/relay_emote(datum/source, emote_key, emote_message)
    SIGNAL_HANDLER
    var/mob/living/carbon/human/slave = source
    if(!slave || !(slave in my_slaves) || !listening || slave != listening_slave)
        return

    if(emote_message)
        to_chat(mindparent.current, span_notice("<i>Through [slave]'s collar: [slave] [emote_message]</i>"))

/datum/component/collar_master/proc/force_strip(mob/living/carbon/human/slave)
    if(!slave || !(slave in my_slaves))
        return FALSE

    slave.drop_all_held_items()
    // Additional stripping logic can be added here
    return TRUE

/datum/component/collar_master/proc/toggle_hallucinations(mob/living/carbon/human/slave)
    if(!slave || !(slave in my_slaves))
        return FALSE

    if(slave.has_trauma_type(/datum/brain_trauma/mild/hallucinations))
        slave.cure_trauma_type(/datum/brain_trauma/mild/hallucinations, TRAUMA_RESILIENCE_BASIC)
        to_chat(slave, span_notice("Your collar pulses and the world becomes clearer."))
    else
        slave.gain_trauma(/datum/brain_trauma/mild/hallucinations, TRAUMA_RESILIENCE_BASIC)
        to_chat(slave, span_warning("Your collar pulses and the world begins to shift and warp!"))
        slave.do_jitter_animation(20)
    playsound(slave, 'sound/misc/vampirespell.ogg', 50, TRUE)
    return TRUE

/datum/component/collar_master/proc/create_illusion(mob/living/carbon/human/slave, message)
    if(!slave || !(slave in my_slaves))
        return FALSE

    to_chat(slave, span_warning("<b>Collar Illusion:</b> [message]"))
    slave.do_jitter_animation(20)
    playsound(slave, 'sound/misc/vampirespell.ogg', 50, TRUE)
    return TRUE

/datum/component/collar_master/proc/force_emote(mob/living/carbon/human/slave, emote_text)
    if(!slave || !(slave in my_slaves))
        return FALSE

    slave.emote("me", EMOTE_VISIBLE, emote_text)
    return TRUE

/datum/component/collar_master/proc/share_damage(mob/living/carbon/human/slave, mob/living/carbon/human/master)
    if(!slave || !(slave in my_slaves) || !master)
        return FALSE

    var/total_damage = master.getBruteLoss() + master.getFireLoss() + master.getOxyLoss()
    if(total_damage <= 0)
        return FALSE

    var/damage_share = total_damage * 0.5
    slave.adjustBruteLoss(damage_share)
    master.adjustBruteLoss(-damage_share)

    // Share blood if applicable
    if(master.blood_volume && slave.blood_volume)
        var/blood_diff = BLOOD_VOLUME_NORMAL - master.blood_volume
        if(blood_diff > 0)
            var/blood_share = min(blood_diff * 0.5, slave.blood_volume - BLOOD_VOLUME_SAFE)
            if(blood_share > 0)
                slave.blood_volume -= blood_share
                master.blood_volume += blood_share

    return TRUE

/datum/component/collar_master/proc/force_surrender(mob/living/carbon/human/slave)
    if(!slave || !(slave in my_slaves))
        return FALSE

    if(slave.stat >= UNCONSCIOUS)
        return FALSE

    if(slave.surrendering)
        return FALSE

    slave.surrendering = TRUE
    slave.toggle_cmode()
    slave.changeNext_move(CLICK_CD_EXHAUSTED)

    // Create and attach the surrender flag visual
    var/obj/effect/temp_visual/surrender/flaggy = new(slave)
    slave.vis_contents += flaggy

    // Apply stun and status effects
    slave.Stun(300)
    slave.Knockdown(300)
    slave.apply_status_effect(/datum/status_effect/debuff/breedable)
    slave.apply_status_effect(/datum/status_effect/debuff/submissive)

    // Visual and sound effects
    slave.visible_message(span_warning("[slave] is forced to surrender by their collar!"), \
                       span_userdanger("Your collar forces you to submit!"))
    playsound(slave, 'sound/misc/surrender.ogg', 100, FALSE, -1, ignore_walls=TRUE)

    slave.update_vision_cone()
    addtimer(CALLBACK(slave, TYPE_PROC_REF(/mob/living, end_submit)), 600)

    return TRUE

/datum/component/collar_master/proc/toggle_arousal(mob/living/carbon/human/slave)
    if(!slave || !(slave in my_slaves))
        return FALSE

    var/loop_id = "force_arousal_[REF(slave)]"

    // Check if arousal is already being forced
    if(slave.active_timers?.Find(loop_id))
        deltimer(slave.active_timers[loop_id])
        slave.clear_fullscreen("love")
        to_chat(slave, span_notice("The waves of arousal from your collar subside..."))
        return TRUE

    // Start arousal loop
    var/amount_per_tick = 5
    arousal_tick(slave, amount_per_tick, loop_id)
    slave.flash_fullscreen("love", /atom/movable/screen/fullscreen/love)

    // Visual feedback
    to_chat(slave, span_userdanger("Your collar sends waves of arousal through your body!"))
    slave.do_jitter_animation(20)
    playsound(slave, 'sound/misc/vampirespell.ogg', 50, TRUE)

    return TRUE

/datum/component/collar_master/proc/arousal_tick(mob/living/carbon/human/slave, amount_per_tick, loop_id)
    if(!slave?.sexcon)
        slave.sexcon = new /datum/sex_controller(slave)

    slave.sexcon.adjust_arousal(amount_per_tick)
    slave.flash_fullscreen("love", /atom/movable/screen/fullscreen/love)

    // Visual feedback each tick
    var/list/arousal_messages = list(
        "Your collar tingles as pleasure courses through you...",
        "Waves of heat spread from your collar...",
        "Your body quivers with building arousal...",
        "The collar's influence makes you shudder with need..."
    )

    to_chat(slave, span_love(pick(arousal_messages)))
    slave.do_jitter_animation(10)

    // Sound effects based on arousal level
    if(prob(10))  // 10% chance each tick to make a sound
        var/current_arousal = slave.sexcon.arousal
        if(current_arousal > 60)
            playsound(slave, pick('sound/vo/female/gen/se/sex (1).ogg',
                              'sound/vo/female/gen/se/sex (2).ogg',
                              'sound/vo/female/gen/se/sex (3).ogg',
                              'sound/vo/female/gen/se/sex (4).ogg',
                              'sound/vo/female/gen/se/sex (5).ogg',
                              'sound/vo/female/gen/se/sex (6).ogg',
                              'sound/vo/female/gen/se/sex (7).ogg'), 50, TRUE)
            slave.emote("moan")
        else if(current_arousal > 10)
            playsound(slave, pick('sound/vo/female/gen/se/sexlight (1).ogg',
                              'sound/vo/female/gen/se/sexlight (2).ogg',
                              'sound/vo/female/gen/se/sexlight (3).ogg',
                              'sound/vo/female/gen/se/sexlight (4).ogg',
                              'sound/vo/female/gen/se/sexlight (5).ogg',
                              'sound/vo/female/gen/se/sexlight (6).ogg',
                              'sound/vo/female/gen/se/sexlight (7).ogg'), 50, TRUE)
            slave.emote("whimper")

    // Continue loop
    slave.active_timers[loop_id] = addtimer(CALLBACK(src, PROC_REF(arousal_tick), slave, amount_per_tick, loop_id), 1 SECONDS, TIMER_STOPPABLE)

/datum/component/collar_master/proc/force_love(mob/living/carbon/human/slave)
    if(!slave || !(slave in my_slaves))
        return FALSE

    // Apply love effects
    slave.emote("blush")
    to_chat(slave, span_love("Your collar fills you with overwhelming affection!"))
    playsound(slave, 'sound/misc/vampirespell.ogg', 50, TRUE)
    return TRUE

/datum/component/collar_master/proc/permit_clothing(mob/living/carbon/human/slave, permitted = TRUE)
    if(!slave || !(slave in my_slaves))
        return FALSE

    if(permitted)
        REMOVE_TRAIT(slave, TRAIT_NUDIST, COLLAR_TRAIT)
        to_chat(slave, span_notice("Your collar allows you to wear clothing again."))
    else
        ADD_TRAIT(slave, TRAIT_NUDIST, COLLAR_TRAIT)
        to_chat(slave, span_warning("Your collar prevents you from wearing clothing!"))
    playsound(slave, 'sound/misc/vampirespell.ogg', 50, TRUE)
    return TRUE

/datum/component/collar_master/proc/check_slave_status(mob/living/carbon/human/slave)
    if(!slave || !(slave in my_slaves))
        return FALSE

    var/status_text = "<span class='notice'><b>[slave.real_name] Status:</b>\n"
    status_text += "Health: [slave.health]/[slave.maxHealth]\n"
    status_text += "Location: [get_area(slave)]\n"
    status_text += "Mental State: [slave.stat >= UNCONSCIOUS ? "Unconscious" : "Conscious"]\n"
    status_text += "Active Traits: "

    var/list/active_traits = list()
    if(speech_altered)
        active_traits += "Speech Altered"

    status_text += active_traits.len ? english_list(active_traits) : "None"
    status_text += "</span>"

    return status_text

/datum/component/collar_master/proc/mass_command(command_type, list/targets, ...)
    if(!length(targets))
        return FALSE

    var/success_count = 0
    for(var/mob/living/carbon/human/slave in targets)
        if(!slave || !(slave in my_slaves
))
            continue

        switch(command_type)
            if("shock")
                var/intensity = args[1]
                if(shock_slave(slave, intensity))
                    success_count++
            if("surrender")
                if(force_surrender(slave))
                    success_count++
            if("strip")
                if(force_strip(slave))
                    success_count++
            if("arousal")
                if(toggle_arousal(slave))
                    success_count++
            if("love")
                if(force_love(slave))
                    success_count++
            if("hallucinate")
                if(toggle_hallucinations(slave))
                    success_count++

    return success_count

/datum/component/collar_master/proc/on_slave_examine(mob/living/carbon/human/slave, mob/user)
    if(!slave || !(slave in my_slaves))
        return

    if(user == mindparent?.current)
        to_chat(user, span_notice("\n[check_slave_status(slave)]"))
    else if(user != slave)
        to_chat(user, span_warning("\nThey wear a strange collar around their neck."))

/datum/component/collar_master/proc/cleanup_slave(mob/living/carbon/human/slave)
	if(!slave || !(slave in my_slaves))
		return FALSE

	// Remove all collar-related traits
	REMOVE_TRAIT(slave, TRAIT_NUDIST, COLLAR_TRAIT)

	// Remove from lists
	my_slaves -= slave
	registered_slaves -= slave
	my_special_slaves -= slave

	// Handle collar removal and trigger uncollared signal
	var/obj/item/clothing/neck/roguetown/cursed_collar/collar = slave.get_item_by_slot(SLOT_NECK)
	if(istype(collar))
		SEND_SIGNAL(slave, COMSIG_CARBON_LOSE_COLLAR)
		slave.dropItemToGround(collar, force = TRUE)
		REMOVE_TRAIT(collar, TRAIT_NODROP, CURSED_ITEM_TRAIT)

	// Feedback
	to_chat(slave, span_notice("Your mind clears as the collar's control fades!"))
	if(mindparent.current)
		to_chat(mindparent.current, span_warning("[slave] is no longer under your control!"))

	return TRUE

/datum/component/collar_master/_JoinParent()
    . = ..()
    if(mindparent?.current)
        mindparent.current.verbs += list(
            /mob/proc/collar_master_control_menu,
            /mob/proc/collar_master_help,
			/mob/proc/collar_master_releaseall
        )

/datum/component/collar_master/_RemoveFromParent()
    if(mindparent?.current)
        mindparent.current.verbs -= list(
            /mob/proc/collar_master_control_menu,
            /mob/proc/collar_master_help,
			/mob/proc/collar_master_releaseall
        )
    . = ..()

/datum/component/collar_master/proc/pass_wounds(mob/living/carbon/human/slave)
    if(!slave || !(slave in my_slaves))
        return FALSE

    var/mob/living/carbon/human/master = mindparent?.current
    if(!master)
        return FALSE

    // Pass all damage types
    slave.adjustBruteLoss(master.getBruteLoss() * 0.5)
    slave.adjustFireLoss(master.getFireLoss() * 0.5)
    slave.adjustOxyLoss(master.getOxyLoss() * 0.5)

    // Pass blood level if it exists
    if(slave.blood_volume && master.blood_volume)
        slave.blood_volume = max(BLOOD_VOLUME_SAFE, slave.blood_volume - (BLOOD_VOLUME_NORMAL - master.blood_volume) * 0.5)

    // Pass organ damage
    for(var/obj/item/organ/organ in master.internal_organs)
        var/obj/item/organ/matching_organ = slave.getorganslot(organ.slot)
        if(matching_organ && organ.damage > 0)
            matching_organ.applyOrganDamage(organ.damage * 0.5)

    slave.updatehealth()
    playsound(slave, 'sound/misc/vampirespell.ogg', 50, TRUE)
    to_chat(slave, span_userdanger("Your collar burns as your master's suffering flows into you!"))
    slave.visible_message(span_warning("[slave] shudders as [master]'s wounds manifest on their body!"))
    slave.do_jitter_animation(20)

    // Heal the master slightly
    master.adjustBruteLoss(-10)
    master.adjustFireLoss(-10)
    master.adjustOxyLoss(-10)

    return TRUE

/datum/component/collar_master/proc/toggle_speech(mob/living/carbon/human/slave)
    if(!slave || !(slave in my_slaves))
        return FALSE

    speech_altered = !speech_altered

    if(speech_altered)
        RegisterSignal(slave, COMSIG_MOB_SAY, PROC_REF(on_slave_say))
        to_chat(mindparent.current, span_notice("You alter [slave]'s speech to animal sounds."))
        to_chat(slave, span_warning("Your collar tingles - you find yourself only able to make animal noises!"))
    else
        UnregisterSignal(slave, COMSIG_MOB_SAY)
        to_chat(mindparent.current, span_notice("You return [slave]'s speech to normal."))
        to_chat(slave, span_notice("Your collar relaxes - you can speak normally again."))

    playsound(slave, 'sound/misc/vampirespell.ogg', 50, TRUE)
    return TRUE

/datum/component/collar_master/proc/register_slave(mob/living/carbon/human/slave)
    if(!slave || (slave in my_slaves))
        return FALSE

    // Use existing signals from the dominated component
    RegisterSignal(slave, list(
        COMSIG_MOB_ATTACK_HAND,
        COMSIG_HUMAN_MELEE_UNARMED_ATTACK,
        COMSIG_ITEM_ATTACK,
        COMSIG_LIVING_ATTACKED_BY
    ), PROC_REF(on_slave_attack))

    return TRUE

/datum/component/collar_master/proc/toggle_denial(mob/living/carbon/human/slave)
    if(!slave || !(slave in my_slaves))
        return FALSE

    if(deny_orgasm)
        // Start a loop to monitor and cap arousal
        var/loop_id = "deny_orgasm_[REF(slave)]"
        slave.active_timers[loop_id] = addtimer(CALLBACK(src, PROC_REF(cap_arousal), slave, loop_id), 1 SECONDS, TIMER_STOPPABLE | TIMER_LOOP)
        to_chat(slave, span_warning("Your collar tightens - you feel like you won't be able to finish!"))
    else
        // Stop the denial loop
        var/loop_id = "deny_orgasm_[REF(slave)]"
        if(slave.active_timers?.Find(loop_id))
            deltimer(slave.active_timers[loop_id])
        to_chat(slave, span_notice("Your collar loosens - you feel like you can finish again!"))
    return TRUE

/datum/component/collar_master/proc/cap_arousal(mob/living/carbon/human/slave, loop_id)
    if(!slave?.sexcon || !deny_orgasm)
        return

    if(slave.sexcon.arousal > 90)
        slave.sexcon.arousal = 90
        to_chat(slave, span_warning("Your collar prevents you from reaching climax!"))
