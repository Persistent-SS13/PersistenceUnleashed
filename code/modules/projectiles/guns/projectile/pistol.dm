/obj/item/gun/projectile/pistol
	name = "Hesco-2 pistol"
	icon = 'icons/obj/guns/pistol.dmi'
	desc = "The HexGuard Hesco V2 is a very common pistol mass produced in the Terran systems. Tier: <font color=#bebebe><font size=2>Common"
	load_method = MAGAZINE
	caliber = CALIBER_PISTOL
	magazine_type = /obj/item/ammo_magazine/bigpistol
	allowed_magazines = /obj/item/ammo_magazine/bigpistol
	accuracy_power = 7
	safety_icon = "safety"
	ammo_indicator = TRUE

/obj/item/gun/projectile/pistol/rubber
	magazine_type = /obj/item/ammo_magazine/pistol/rubber

/obj/item/gun/projectile/pistol/emp
	magazine_type = /obj/item/ammo_magazine/pistol/emp

/obj/item/gun/projectile/pistol/update_base_icon()
	var/base_state = get_world_inventory_state()
	if(!length(ammo_magazine?.stored_ammo) && check_state_in_icon("[base_state]-e", icon))
		icon_state = "[base_state]-e"
	else
		icon_state = base_state

/obj/item/gun/projectile/pistol/holdout/slay
	name = "P-3 Whisper (slay)"
	desc = "The HexGuard P3 Whisper. This one seems to be heavily modded with a pink grip and glitter to it. Tier: <font color=#a840b1><font size=2>Rare"
	icon = 'icons/obj/guns/holdout_pistol_slay.dmi'
	item_state = null
	ammo_indicator = FALSE
	w_class = ITEM_SIZE_SMALL
	caliber = CALIBER_PISTOL_SMALL
	silenced = 0
	fire_delay = 4
	origin_tech = "{'combat':2,'materials':2,'esoteric':8}"
	magazine_type = /obj/item/ammo_magazine/pistol/small
	allowed_magazines = /obj/item/ammo_magazine/pistol/small

/obj/item/gun/projectile/pistol/holdout
	name = "P-3 Whisper"
	desc = "The HexGuard P3 Whisper. A small, easily concealable gun. Tier: <font color=#bebebe><font size=2>Common"
	icon = 'icons/obj/guns/holdout_pistol.dmi'
	item_state = null
	ammo_indicator = FALSE
	w_class = ITEM_SIZE_SMALL
	caliber = CALIBER_PISTOL_SMALL
	silenced = 0
	fire_delay = 4
	origin_tech = "{'combat':2,'materials':2,'esoteric':8}"
	magazine_type = /obj/item/ammo_magazine/pistol/small
	allowed_magazines = /obj/item/ammo_magazine/pistol/small

/obj/item/gun/projectile/pistol/holdout/attack_hand(mob/user)
	if(silenced && user.is_holding_offhand(src))
		to_chat(user, SPAN_NOTICE("You unscrew \the [silenced] from \the [src]."))
		user.put_in_hands(silenced)
		silenced = initial(silenced)
		w_class = initial(w_class)
		update_icon()
		return
	..()

/obj/item/gun/projectile/pistol/holdout/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/silencer))
		if(src in user.get_held_items())	//if we're not in his hands
			to_chat(user, SPAN_WARNING("You'll need [src] in your hands to do that."))
			return TRUE
		if(user.unEquip(I, src))
			to_chat(user, SPAN_NOTICE("You screw [I] onto [src]."))
			silenced = I	//dodgy?
			w_class = ITEM_SIZE_NORMAL
			update_icon()
		return TRUE
	. = ..()

/obj/item/gun/projectile/pistol/holdout/update_base_icon()
	..()
	if(silenced)
		overlays += mutable_appearance(icon, "[get_world_inventory_state()]-silencer")

/obj/item/gun/projectile/pistol/holdout/get_on_belt_overlay()
	if(silenced && check_state_in_icon("on_belt_silenced", icon))
		return overlay_image(icon, "on_belt_silenced", color)
	return ..()

/obj/item/silencer
	name = "silencer"
	desc = "A silencer."
	icon = 'icons/obj/guns/holdout_pistol_silencer.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_SMALL
	material = /decl/material/solid/metal/steel

/obj/item/gun/projectile/pistol/ct45
	name = "CT-45"
	desc = "The CT-45 pistol. A handgun with a steel slide and wooden grip. Chambered in 10mm. Tier: <font color=green><font size=2>Uncommon"
	icon = 'mods/persistence/icons/obj/guns/tier1/ct45.dmi'
	item_state = null
	ammo_indicator = FALSE
	w_class = ITEM_SIZE_SMALL
	caliber = CALIBER_PISTOL
	fire_delay = 4
	origin_tech = "{'combat':2,'materials':2,'esoteric':8}"
	magazine_type = /obj/item/ammo_magazine/bigpistol
	allowed_magazines = /obj/item/ammo_magazine/bigpistol

/obj/item/gun/projectile/pistol/ct45/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "world"
	else
		icon_state = "world-empty"


/obj/item/gun/projectile/pistol/smartgun
	name = "Mercury smart pistol"
	desc = "The Mercury SmartInc pistol. A handgun with a advanced microchip algorithm point system or (MAPS) for short, allows the user to land accurate hits on the target without aiming much. Can be chambered in a bunch of calibers due to it's automatic conversion kit built in. Tier: <font color=#a840b1><font size=2>Rare"
	icon = 'mods/persistence/icons/obj/guns/tier1/smartpistol.dmi'
	item_state = null
	ammo_indicator = FALSE
	w_class = ITEM_SIZE_SMALL
	caliber = CALIBER_PISTOL
	fire_delay = 1
	accuracy = 15
	accuracy_power = 16
	origin_tech = "{'combat':2,'materials':2,'esoteric':8}"
	magazine_type = /obj/item/ammo_magazine/bigpistol
	allowed_magazines = /obj/item/ammo_magazine/bigpistol
	firemodes = list(
		list(mode_name="semi auto",      burst=1,    fire_delay=2, use_launcher=null, one_hand_penalty=8,  burst_accuracy=null,            dispersion=null),
		list(mode_name="burst",      burst=2,    fire_delay=1,    burst_delay=1,     use_launcher=null,   one_hand_penalty=7,             burst_accuracy = list(0,-1,-1), dispersion=list(0.0, 0.6, 1.0))
	)

/obj/item/gun/projectile/pistol/smartgun/on_update_icon()
	..()
	if(ammo_magazine)
		icon_state = "world"
	else
		icon_state = "world-empty"