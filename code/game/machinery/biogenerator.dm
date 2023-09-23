#define BG_READY 0
#define BG_PROCESSING 1
#define BG_NO_BEAKER 2
#define BG_COMPLETE 3
#define BG_EMPTY 4

/obj/machinery/biogenerator
	name = "biogenerator"
	desc = ""
	icon = 'icons/obj/biogenerator.dmi'
	icon_state = "biogen-stand"
	density = 1
	anchored = 1
	idle_power_usage = 40
	base_type = /obj/machinery/biogenerator
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0
	var/processing = 0
	var/obj/item/chems/glass/beaker = null
	var/points = 0
	var/state = BG_READY
	var/build_eff = 1
	var/eat_eff = 1
	var/ingredients = 0 //How many processable ingredients are stored inside.
	var/capacity = 10   //How many ingredients can we store?
	var/list/products = list(
		"Food" = list(
			/obj/item/chems/drinks/milk/smallcarton = 50,
			/obj/item/chems/drinks/milk = 100,
			/obj/item/chems/food/meat/syntiflesh = 100,                     // this can only be used for cutlets
			/obj/item/chems/food/egg = 50,                                  // sometimes yall, we only need 1 egg
			/obj/item/storage/fancy/egg_box = 400),
		"Nutrients" = list(                                                 // this needs names really bad. you cant tell what's what until you get it.
			/obj/item/chems/glass/bottle/eznutrient = 60,
			/obj/item/chems/glass/bottle/left4zed = 100,
			/obj/item/chems/glass/bottle/robustharvest = 120),
		"Botanical Supplies" = list( 										// leather -> textiles to support tailoring
			/obj/item/clothing/gloves/thick/botany = 250,                   // these are necessary for some plants so arent required via tailoring
			/obj/item/storage/plants = 300,                                 // i would put this in tailoring but botany is hell without it
			/obj/item/chems/spray/plantbgone = 250,                         // no chem reaction for this. needs to be. but keep this in here even if there is.
			/obj/item/grenade/chem_grenade/antiweed = 1000),                // let them have fun, i say!
		"Textiles" = list( 													// leather -> textiles to support tailoring
			/obj/item/stack/material/bolt/mapped/cloth = 150,               // welcome to clothing, my friend
			/obj/item/stack/material/bolt/mapped/cloth/ten = 1500,
//			/obj/item/stack/material/bolt/mapped/lace = 200,                // welcome to delicacy, my friend
//			/obj/item/stack/material/bolt/mapped/lace/ten = 2000,
//			/obj/item/stack/material/bolt/mapped/silk = 300,                // welcome to royalty, my friend
//			/obj/item/stack/material/bolt/mapped/silk/ten = 3000,
//			/obj/item/stack/material/skin/mapped/leather/ten = 3000,
//			/obj/item/stack/material/skin/mapped/synthleather =300,         // this isnt even used anywhere else. left in-case.
			/obj/item/stack/material/skin/mapped/leather = 300,             // welcome to the workplace, my friend
			/obj/item/stack/material/skin/mapped/leather/ten = 300),
		"Livestock" = list(													// until someone wants to code lifecycles, we need this.
			/obj/item/chems/food/monkeycube = 1000,
			/obj/item/storage/box/monkeycubes = 5000,
			/obj/item/bee_pack = 5000,                                      // one-time use to produce a bee queen and her hive in an apiary frame
			/obj/item/honey_frame = 1000,                                   // just in-case you dont have wood!
			/obj/item/bee_smoker = 3000,                                    // unlimited uses, needs to be toned down with a durability meter, then price dipped.
			/obj/item/chems/food/monkeycube/chick = 2500,                   // pricier cause these can actually reproduce with the eggs they lay
			/obj/item/chems/food/monkeycube/bovine = 1500,
			/obj/item/chems/food/monkeycube/goat = 1500))


/obj/machinery/biogenerator/Initialize()
	create_reagents(1000)
	beaker = new /obj/item/chems/glass/bottle(src)
	. = ..()

/obj/machinery/biogenerator/on_reagent_change()			//When the reagents change, change the icon as well.
	update_icon()

/obj/machinery/biogenerator/on_update_icon()
	if(state == BG_NO_BEAKER)
		icon_state = "biogen-empty"
	else if(state == BG_READY || state == BG_COMPLETE)
		icon_state = "biogen-stand"
	else
		icon_state = "biogen-work"
	return

/obj/machinery/biogenerator/components_are_accessible(path)
	return !processing && ..()

/obj/machinery/biogenerator/cannot_transition_to(state_path)
	if(processing)
		return SPAN_NOTICE("You must turn \the [src] off first.")
	return ..()

/obj/machinery/biogenerator/attackby(var/obj/item/O, var/mob/user)
	if((. = component_attackby(O, user)))
		return
	if(processing)
		to_chat(user, "<span class='notice'>\The [src] is currently processing.</span>")
	if(istype(O, /obj/item/chems/glass))
		if(beaker)
			to_chat(user, "<span class='notice'>]The [src] is already loaded.</span>")
			return TRUE
		else if(user.unEquip(O, src))
			beaker = O
			state = BG_READY
			updateUsrDialog()
			return TRUE

	if(ingredients >= capacity)
		to_chat(user, "<span class='notice'>\The [src] is already full! Activate it.</span>")
	else if(istype(O, /obj/item/storage/plants))
		var/obj/item/storage/plants/P = O
		var/hadPlants = 0
		for(var/obj/item/chems/food/grown/G in P.contents)
			hadPlants = 1
			P.remove_from_storage(G, src, 1) //No UI updates until we are all done.
			ingredients++
			if(ingredients >= capacity)
				to_chat(user, "<span class='notice'>You fill \the [src] to its capacity.</span>")
				break
		P.finish_bulk_removal() //Now do the UI stuff once.
		if(!hadPlants)
			to_chat(user, "<span class='notice'>\The [P] has no produce inside.</span>")
		else if(ingredients < capacity)
			to_chat(user, "<span class='notice'>You empty \the [P] into \the [src].</span>")


	else if(!istype(O, /obj/item/chems/food/grown))
		to_chat(user, "<span class='notice'>You cannot put this in \the [src].</span>")
	else if(user.unEquip(O, src))
		ingredients++
		to_chat(user, "<span class='notice'>You put \the [O] in \the [src]</span>")
	update_icon()

/**
 *  Display the NanoUI window for the vending machine.
 *
 *  See NanoUI documentation for details.
 */
/obj/machinery/biogenerator/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)
	var/list/data = list()
	data["state"] = state
	var/name
	var/cost
	var/type_name
	var/path
	if (state == BG_READY)
		data["points"] = points
		var/list/listed_types = list()
		for(var/c_type =1 to products.len)
			type_name = products[c_type]
			var/list/current_content = products[type_name]
			var/list/listed_products = list()
			for(var/c_product =1 to current_content.len)
				path = current_content[c_product]
				var/atom/A = path
				name = initial(A.name)
				cost = current_content[path]
				listed_products.Add(list(list(
					"product_index" = c_product,
					"name" = name,
					"cost" = cost)))
			listed_types.Add(list(list(
				"type_name" = type_name,
				"products" = listed_products)))
		data["types"] = listed_types
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "biogenerator.tmpl", "Biogenerator", 440, 600)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/biogenerator/OnTopic(user, href_list)
	switch (href_list["action"])
		if("activate")
			activate()
		if("detach")
			if(beaker)
				beaker.dropInto(src.loc)
				beaker = null
				state = BG_NO_BEAKER
				update_icon()
		if("create")
			if (state == BG_PROCESSING)
				return TOPIC_REFRESH
			var/type = href_list["type"]
			var/product_index = text2num(href_list["product_index"])
			if (isnull(products[type]))
				return TOPIC_REFRESH
			var/list/sub_products = products[type]
			if (product_index < 1 || product_index > sub_products.len)
				return TOPIC_REFRESH
			create_product(type, sub_products[product_index])
		if("return")
			state = BG_READY
	return TOPIC_REFRESH

/obj/machinery/biogenerator/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/biogenerator/proc/activate()
	if (usr.stat)
		return
	if (stat) //NOPOWER etc
		return

	var/S = 0
	for(var/obj/item/chems/food/grown/I in contents)
		S += 5
		ingredients--
		var/amt = REAGENT_VOLUME(I.reagents, /decl/material/liquid/nutriment)
		if(amt < 0.1)
			points += 1
		else
			points += amt * 10 * eat_eff
		qdel(I)
	if(S)
		state = BG_PROCESSING
		SSnano.update_uis(src)
		update_icon()
		playsound(src.loc, 'sound/machines/blender.ogg', 50, 1)
		use_power_oneoff(S * 30)
		sleep((S + 15) / eat_eff)
		state = BG_READY
		update_icon()
	else
		state = BG_EMPTY
	return

/obj/machinery/biogenerator/proc/create_product(var/type, var/path)
	state = BG_PROCESSING
	var/cost = products[type][path]
	cost = round(cost/build_eff)
	points -= cost
	SSnano.update_uis(src)
	update_icon()
	sleep(30)
	var/atom/movable/result = new path
	result.dropInto(loc)
	state = BG_COMPLETE
	update_icon()
	return 1


/obj/machinery/biogenerator/RefreshParts()
	..()
	build_eff = clamp(total_component_rating_of_type(/obj/item/stock_parts/manipulator), 1, 10)
	eat_eff = clamp(total_component_rating_of_type(/obj/item/stock_parts/matter_bin), 1, 10)
