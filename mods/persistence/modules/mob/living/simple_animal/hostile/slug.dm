/*VOX SLUG
Small, little HP, poisonous.
*/

/mob/living/simple_animal/hostile/glutslug
	name = "glutslug"
	desc = "A vicious, terrible parasite, it has a mouth of too many teeth and a penchant for blood."
	icon = 'icons/mob/simple_animal/slug.dmi'
	response_harm = "stomps on"
	destroy_surroundings = 1
	health = 5
	maxHealth = 5
	speed = 0
	move_to_delay = 0
	minbodytemp = 0
	density = 1
	min_gas = null
	max_gas = null
	mob_size = MOB_SIZE_MINISCULE
	can_escape = TRUE
	pass_flags = PASS_FLAG_TABLE
	natural_weapon = /obj/item/natural_weapon/bite/weak
	holder_type = /obj/item/holder/glutslug
	faction = "Hostile Fauna"
	unrelenting = 1
	natural_weapon_terrain = /obj/item/natural_weapon/bite/strong
	break_stuff_probability = 85


/mob/living/simple_animal/hostile/glutslug/Process_Spacemove()
	return 1

/mob/living/simple_animal/hostile/glutslug/proc/check_friendly_species(var/mob/living/M)
	return istype(M) && M.faction == faction

/mob/living/simple_animal/hostile/glutslug/ListTargets(var/dist = 7)
	. = ..()
	for(var/mob/living/M in .)
		if(M.faction == faction)
			. -= M

/mob/living/simple_animal/hostile/glutslug/Move(NewLoc, Dir)
	. = ..()
	pixel_x = rand(-2,2)
	pixel_y = rand(-2,2)

/mob/living/simple_animal/hostile/glutslug/get_scooped(var/mob/living/carbon/target, var/mob/living/initiator)
	if(target == initiator || (istype(initiator) && initiator.faction == faction))
		return ..()
	to_chat(initiator, SPAN_WARNING("\The [src] wriggles out of your hands before you can pick it up!"))

/mob/living/simple_animal/hostile/glutslug/proc/attach(var/mob/living/carbon/human/H)
	var/obj/item/clothing/suit/space/S = H.get_covering_equipped_item_by_zone(BP_CHEST)
	if(istype(S) && !length(S.breaches))
		S.create_breaches(BRUTE, 20)
		if(!length(S.breaches)) //unable to make a hole
			return
	var/obj/item/organ/external/chest = GET_EXTERNAL_ORGAN(H, BP_CHEST)
	var/obj/item/holder/glutslug/holder = new(get_turf(src))
	src.forceMove(holder)
	chest.embed(holder,0,"\The [src] burrows itself into \the [H]!")
	holder.sync(src)

/mob/living/simple_animal/hostile/glutslug/AttackingTarget()
	. = ..()
	if(istype(., /mob/living/carbon/human))
		var/mob/living/carbon/human/H = .
		if(prob(H.getBruteLoss()/2))
			attach(H)

/mob/living/simple_animal/hostile/glutslug/Life()
	. = ..()
	if(. && istype(src.loc, /obj/item/holder) && isliving(src.loc.loc)) //We in somebody
		var/mob/living/L = src.loc.loc
		if(src.loc in L.get_visible_implants(0))
			if(prob(1))
				to_chat(L, "<span class='warning'>You feel strange as \the [src] pulses...</span>")
			var/datum/reagents/R = L.reagents
			R.add_reagent(/decl/material/liquid/presyncopics, 0.5)

/obj/item/holder/glutslug/attack(var/mob/target, var/mob/user)
	var/mob/living/simple_animal/hostile/glutslug/V = contents[1]
	if(!V.stat && istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = target
		if(!do_mob(user, H, 30))
			return
		V.attach(H)
		qdel(src)
		return
	..()


/obj/item/glutslugegg
	name = "glutslug egg"
	desc = "A pulsing, disgusting door to new life."
	force = 1
	throwforce = 6
	icon = 'mods/species/vox/icons/gear/slugegg.dmi'
	icon_state = "slugegg"
	material = /decl/material/solid/skin/insect
	var/break_on_impact = 1 //There are two modes to the eggs.
							//One breaks the egg on hit,

/obj/item/glutslugegg/throw_impact(atom/hit_atom)
	if(break_on_impact)
		squish()
	else
		movable_flags |= MOVABLE_FLAG_PROXMOVE //Dont want it active during the throw... loooots of unneeded checking.
	return ..()

/obj/item/glutslugegg/attack_self(var/mob/user)
	squish()

/obj/item/glutslugegg/HasProximity(var/atom/movable/AM)
	. = ..()
	if(. && isliving(AM))
		squish()

/obj/item/glutslugegg/proc/squish()
	src.visible_message("<span class='warning'>\The [src] bursts open!</span>")
	new /mob/living/simple_animal/hostile/glutslug(get_turf(src))
	playsound(src.loc,'sound/effects/attackblob.ogg',100, 1)
	qdel(src)

