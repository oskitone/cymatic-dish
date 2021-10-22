include <enclosure.scad>;
include <petri_dish.scad>;

module cymatic_dish(
    petri_dish_clearance = 1,
    tolerance = 0,
    quick_preview = false,
    debug = true
) {
    PERIPHERAL_HEIGHT = 50; // TODO: replace
    petri_dish_z = ENCLOSURE_FLOOR_CEILING + PERIPHERAL_HEIGHT;

    enclosure_inner_height = get_enclosure_inner_height(
        petri_dish_z,
        petri_dish_clearance
    );
    enclosure_height = get_enclosure_height(
        petri_dish_z,
        petri_dish_clearance
    );

    difference() {
        group() {
            enclosure(
                inner_height = enclosure_inner_height,
                height = enclosure_height,
                tolerance = tolerance,
                petri_dish_z = petri_dish_z,
                petri_dish_clearance = petri_dish_clearance,
                quick_preview = quick_preview
            );

            translate([0, 0, petri_dish_z]) {
                % petri_dish();
            }
        }

        if (debug) {
            translate([0, -100, -1]) {
                cube([100, 100 * 2, 200]);
            }
        }
    }
}

cymatic_dish(
    tolerance = .1,
    quick_preview = 1
);
