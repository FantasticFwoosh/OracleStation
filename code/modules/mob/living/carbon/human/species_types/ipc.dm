/datum/species/ipc
	name = "IPC"
	id = "ipc"
	say_mod = "states"
	heatmod = 3 // Went cheap with Aircooling
	coldmod = 1.5 // Don't put your computer in the freezer.
	burnmod = 2 // Wiring doesn't hold up to fire well.
	brutemod = 1.6 // Thin metal, cheap materials.
	toxmod = 0
	siemens_coeff = 1.5 // Overload!
	species_traits = list(NOBREATH,NOBLOOD,RADIMMUNE,VIRUSIMMUNE,NOZOMBIE,EASYDISMEMBER,EASYLIMBATTACHMENT,NOPAIN,NO_BONES,NOTRANSSTING,MUTCOLORS,REVIVESBYHEALING,NOSCAN,SYNTHETICSPECIES)
	mutant_bodyparts = list("ipc_screen", "ipc_antenna", "ipc_chassis")
	default_features = list("mcolor" = "#7D7D7D", "ipc_screen" = "Static", "ipc_antenna" = "None", "ipc_chassis" = "Morpheus Cyberkinetics(Greyscale)")
	meat = /obj/item/stack/sheet/plasteel{amount = 5}
	skinned_type = /obj/item/stack/sheet/metal{amount = 10}
	male_scream_sound = 'sound/effects/mob_effects/goonstation/robot_scream.ogg'
	female_scream_sound = 'sound/effects/mob_effects/goonstation/robot_scream.ogg'
	male_cough_sound = 'sound/effects/mob_effects/machine_cough.ogg'
	female_cough_sound = 'sound/effects/mob_effects/machine_cough.ogg'
	male_sneeze_sound = 'sound/effects/mob_effects/machine_sneeze.ogg'
	female_sneeze_sound = 'sound/effects/mob_effects/machine_sneeze.ogg'
	toxic_food = ALL
	mutanteyes = /obj/item/organ/eyes/robotic
	mutanttongue = /obj/item/organ/tongue/robot
	mutantliver = /obj/item/organ/liver/cybernetic/upgraded/ipc
	mutantstomach = /obj/item/organ/stomach/cell
	mutantears = /obj/item/organ/ears/robot
	mutant_brain = /obj/item/organ/brain/mmi_holder/posibrain
	examine_text = "an IPC"
	species_text_color = "#2e2e2e"
	reagent_tag = PROCESS_SYNTHETIC
	species_gibs = "robotic"
	attack_sound = 'sound/items/trayhit1.ogg'

/datum/species/ipc/random_name(unique)
	var/ipc_name = "[pick(GLOB.posibrain_names)]-[rand(100, 999)]"
	return ipc_name

/datum/species/ipc/on_species_gain(mob/living/carbon/C) // I am so sorry for this.
	. = ..()
	var/obj/item/organ/appendix/appendix = C.getorganslot("appendix") // Easiest way to remove it.
	appendix.Remove(C)
	QDEL_NULL(appendix)
	for(var/X in C.bodyparts)
		var/obj/item/bodypart/O = X
		O.change_bodypart_status(BODYPART_ROBOTIC) // Makes all Bodyparts robotic.
		O.render_like_organic = TRUE
		var/chassis = C.dna.features["ipc_chassis"]
		if(chassis == "Morpheus Cyberkinetics(Greyscale)") // If it's a greyscale chassis, we use MUTCOLOR.
			C.dna.species.species_traits += MUTCOLORS
		else
			C.dna.species.species_traits -= MUTCOLORS // If it's not, we remove it
		switch(chassis) // And then we hard swap the icons based on the feature
			if("Morpheus Cyberkinetics(Greyscale)")
				C.dna.species.limbs_id = "mcgipc"
			if("Morpheus Cyberkinetics(Black)")
				C.dna.species.limbs_id = "mcbipc"
			if("Bishop Cyberkinetics")
				C.dna.species.limbs_id = "bshipc"
			if("Bishop Cyberkinetics 2.0")
				C.dna.species.limbs_id = "bs2ipc"
			if("Hephaestus Industries")
				C.dna.species.limbs_id = "hsiipc"
			if("Hephaestus Industries 2.0")
				C.dna.species.limbs_id = "hi2ipc"
			if("Shellguard Munitions")
				C.dna.species.limbs_id = "sgmipc"
			if("Ward-Takahashi Manufacturing")
				C.dna.species.limbs_id = "wtmipc"
			if("Xion Manufacturing Group")
				C.dna.species.limbs_id = "xmgipc"
			if("Xion Manufacturing Group 2.0")
				C.dna.species.limbs_id = "xm2ipc"
			if("Zeng-Hu Pharmaceuticals")
				C.dna.species.limbs_id = "zhpipc"

/datum/species/ipc/after_equip_job(datum/job/J, mob/living/carbon/human/H)
	H.grant_language(/datum/language/machine)

/datum/species/ipc/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(chem.id in list("plasma", "stable_plasma")) // IPCs have plasma batteries
		H.nutrition += 5
		if(H.nutrition > NUTRITION_LEVEL_FULL)
			H.nutrition = NUTRITION_LEVEL_FULL
		H.reagents.remove_reagent(chem.id, REAGENTS_METABOLISM)
		return 1

/datum/species/ipc/spec_attacked_by(obj/item/I, mob/living/user, obj/item/bodypart/affecting, intent, mob/living/carbon/human/H)
	..()
	if(I.force && I.damtype != STAMINA) // IPCs spark when hit, but only when it does real damage. Much like borgs!
		var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread
		spark_system.set_up(1, 0, H)
		spark_system.attach(H)
		spark_system.start()