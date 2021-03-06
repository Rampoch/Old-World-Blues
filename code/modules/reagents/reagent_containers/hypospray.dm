////////////////////////////////////////////////////////////////////////////////
/// HYPOSPRAY
////////////////////////////////////////////////////////////////////////////////

/obj/item/weapon/reagent_containers/hypospray
	name = "hypospray"
	desc = "The DeForest Medical Corporation hypospray is a sterile, air-needle autoinjector for rapid administration of drugs to patients."
	icon = 'icons/obj/syringe.dmi'
	item_state = "hypo"
	icon_state = "hypo"
	amount_per_transfer_from_this = 5
	unacidable = 1
	volume = 30
	possible_transfer_amounts = null
	flags = OPENCONTAINER
	slot_flags = SLOT_BELT
	center_of_mass = list("x"=16, "y"=7)


/obj/item/weapon/reagent_containers/hypospray/do_surgery(mob/living/carbon/M, mob/living/user)
	if(user.a_intent != I_HELP) //in case it is ever used as a surgery tool
		return ..()
	attack(M, user)
	return 1

/obj/item/weapon/reagent_containers/hypospray/attack(mob/living/M as mob, mob/user as mob)
	if(!reagents.total_volume)
		user << "<span class='warning'>[src] is empty.</span>"
		return
	if (!istype(M))
		return
	if(!M.can_inject(user, 1))
		return

	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	user << SPAN_NOTE("You inject [M] with [src].")
	M << SPAN_NOTE("You feel a tiny prick!")

	if(M.reagents)
		var/contained = reagentlist()
		var/trans = reagents.trans_to_mob(M, amount_per_transfer_from_this, CHEM_BLOOD)
		admin_inject_log(user, M, src, contained, trans)
		user << SPAN_NOTE("[trans] units injected. [reagents.total_volume] units remaining in \the [src].")

	return

/obj/item/weapon/reagent_containers/hypospray/autoinjector
	name = "autoinjector"
	desc = "A rapid and safe way to administer small amounts of drugs by untrained or trained personnel."
	icon_state = "autoinjector"
	item_state = "autoinjector"
	amount_per_transfer_from_this = 5
	volume = 5
	w_class = ITEM_SIZE_TINY
	center_of_mass = list("x"=16, "y"=16)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/New()
	..()
	reagents.add_reagent("inaprovaline", 5)
	update_icon()
	return

/obj/item/weapon/reagent_containers/hypospray/autoinjector/attack(mob/M as mob, mob/user as mob)
	..()
	if(reagents.total_volume <= 0) //Prevents autoinjectors to be refilled.
		flags &= ~OPENCONTAINER
	update_icon()
	return

/obj/item/weapon/reagent_containers/hypospray/autoinjector/update_icon()
	if(reagents.total_volume > 0)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]_empty"

/obj/item/weapon/reagent_containers/hypospray/autoinjector/examine(mob/user)
	.=..()
	if(reagents && reagents.reagent_list.len)
		user << SPAN_NOTE("It is currently loaded.")
	else
		user << SPAN_NOTE("It is spent.")

/obj/item/weapon/reagent_containers/hypospray/autoinjector/combat
	amount_per_transfer_from_this = 10
	volume = 10
	name = "autoinjector (combat)"
	desc = "Contains stimulants."
	New()
		..()
		reagents.add_reagent("tramadol", 5)
		reagents.add_reagent("hyperzine",  5)
		update_icon()