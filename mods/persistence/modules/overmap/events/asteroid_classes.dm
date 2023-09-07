/decl/asteroid_class/
	var/name = "Space Rock"
	var/desc = "A standard, boring space rock."
	var/weight = 50
	var/list/outer_types
	var/list/inner_types
	var/list/possible_stratas
	var/list/mob_types
	var/list/object_types
	var/objs_inside_only = FALSE
	var/max_mobs = 5
	var/comet = 0

/decl/asteroid_class/asteroid/ironlow
	name = "Low Density Orbital Asteroid"
	outer_types = list(/turf/exterior/wall/asteroid)
	inner_types = list(/turf/exterior/wall/random/asteroid)
	mob_types = list(/mob/living/simple_animal/hostile/glutslug, /mob/living/simple_animal/hostile/greed)
	possible_stratas = list(
		/decl/strata/asteroid/ironlow
	)
	max_mobs = 2

/decl/asteroid_class/asteroid/ironcarbon
	name = "Low Density Asteroid"
	outer_types = list(/turf/exterior/wall/asteroid, /turf/space)
	inner_types = list(/turf/exterior/wall/random/asteroid)
	mob_types = list(/mob/living/simple_animal/hostile/glutslug, /mob/living/simple_animal/hostile/greed)
	possible_stratas = list(
		/decl/strata/asteroid/iron,
		/decl/strata/asteroid/carbon,
	)

/decl/asteroid_class/asteroid/copperdense
	name = "Nedium Density Asteroid"
	outer_types = list(/turf/exterior/wall/asteroid, /turf/simulated/floor/asteroid)
	inner_types = list(/turf/exterior/wall/random/asteroid)
	mob_types = list(/mob/living/simple_animal/hostile/glutslug, /mob/living/simple_animal/hostile/greed)
	possible_stratas = list(
		/decl/strata/asteroid/copper,
		/decl/strata/asteroid/dense,
	)

/decl/asteroid_class/asteroid/shimmeringdense
	name = "High Density Asteroid"
	outer_types = list(/turf/exterior/wall/asteroid, /turf/space)
	inner_types = list(/turf/exterior/wall/random/asteroid)
	mob_types = list(/mob/living/simple_animal/hostile/glutslug, /mob/living/simple_animal/hostile/greed)
	possible_stratas = list(
		/decl/strata/asteroid/dense,
		/decl/strata/asteroid/shimmering
	)

/decl/asteroid_class/asteroid/phoron_low
	name = "Low Phoron Asteroid"
	outer_types = list(/turf/exterior/wall/asteroid, /turf/space)
	inner_types = list(/turf/exterior/wall/random/asteroid)
	mob_types = list(/mob/living/simple_animal/hostile/glutslug, /mob/living/simple_animal/hostile/greed)
	max_mobs
	possible_stratas = list(
		/decl/strata/asteroid/shimmering,
		/decl/strata/asteroid/phoron_low
	)

/decl/asteroid_class/asteroid/phoron_high
	name = "Medium Phoron Asteroid"
	outer_types = list(/turf/exterior/wall/asteroid, /turf/space)
	inner_types = list(/turf/exterior/wall/random/asteroid)
	mob_types = list(/mob/living/simple_animal/hostile/glutslug, /mob/living/simple_animal/hostile/greed)
	max_mobs
	possible_stratas = list(
		/decl/strata/asteroid/phoron_high,
		/decl/strata/asteroid/phoron_low
	)

/decl/asteroid_class/asteroid
	name = "Asteroid"
	desc = "A silicate dense remnant of a would-be planet. Rich in metals and other materials of industrial use."
	outer_types = list(/turf/exterior/wall/asteroid, /turf/space)
	inner_types = list(/turf/exterior/wall/random/asteroid)
	mob_types = list(/mob/living/simple_animal/hostile/slug)
	possible_stratas = list(
		/decl/strata/asteroid/iron,
		/decl/strata/asteroid/carbon,
		/decl/strata/asteroid/copper,
		/decl/strata/asteroid/dense,
		/decl/strata/asteroid/shimmering
	)

/decl/asteroid_class/rare
	name = "Mineral Rich Asteroid"
	desc = "A silicate dense remnant of a would-be planet. This one is particularly rich in rare metals."
	outer_types = list(/turf/exterior/wall/asteroid)
	inner_types = list(/turf/exterior/wall/random/asteroid)
	mob_types = list(/mob/living/simple_animal/hostile/glutslug, /mob/living/simple_animal/hostile/greed)
	possible_stratas = list(
		/decl/strata/asteroid/rich
	)
	max_mobs = 10

/decl/asteroid_class/comet
	name = "Comet"
	desc = "An icy ball of dust formed from beyond the system's frostline. Often contains rare volatiles and unusual chemicals trapped within its ice."
	outer_types = list(/turf/exterior/wall/asteroid)
	inner_types = list(/turf/exterior/wall/random/asteroid)
	possible_stratas = list(
		/decl/strata/comet/liquid,
		/decl/strata/comet/gas
	)
	comet = 1

/decl/asteroid_class/comet/liquid
	possible_stratas = list(
		/decl/strata/comet/liquid
	)


/decl/asteroid_class/comet/gas
	possible_stratas = list(
		/decl/strata/comet/gas
	)