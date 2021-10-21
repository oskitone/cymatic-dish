include <enclosure.scad>;
include <petri_dish.scad>;

module cymatic_dish(
    tolerance = 0,
    quick_preview = false,
    debug = true
) {
    PERIPHERAL_HEIGHT = 50; // TODO: replace
    petri_dish_z = ENCLOSURE_FLOOR_CEILING + PERIPHERAL_HEIGHT;

    difference() {
        group() {
            enclosure(
                tolerance = tolerance,
                petri_dish_z = petri_dish_z,
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
    tolerance = .1
);
