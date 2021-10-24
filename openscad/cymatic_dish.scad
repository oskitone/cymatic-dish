include <control_panel.scad>;
include <enclosure.scad>;
include <petri_dish.scad>;

module cymatic_dish(
    petri_dish_clearance = 1,
    tolerance = 0,
    quick_preview = false,
    debug = false
) {
    e = .04281;

    PERIPHERAL_HEIGHT = 70; // TODO: replace
    petri_dish_z = ENCLOSURE_FLOOR_CEILING + PERIPHERAL_HEIGHT;

    enclosure_inner_height = get_enclosure_inner_height(
        petri_dish_z,
        petri_dish_clearance
    );
    enclosure_height = get_enclosure_height(
        petri_dish_z,
        petri_dish_clearance
    );

    enclosure_inner_diameter = get_enclosure_inner_diameter(
        tolerance,
        petri_dish_clearance
    );
    enclosure_diameter = get_enclosure_diameter(tolerance, petri_dish_clearance);

    control_panel_inset = KNOB_DEFAULT_HEIGHT;
    control_panel_z = enclosure_height / 2;
    control_panel_depth = 2;

    module _control_panel() {
        translate([
            0,
            enclosure_diameter / -2 + control_panel_inset - e,
            control_panel_z
        ]) {
            rotate([90, 0, 0]) {
                control_panel(
                    engraving_depth = ENCLOSURE_ENGRAVING_DEPTH,
                    depth = control_panel_depth,
                    tolerance = tolerance,
                    show_knobs = true,
                    show_labels = true
                );
            }
        }
    }

    difference() {
        group() {
            enclosure(
                inner_diameter = enclosure_inner_diameter,
                diameter = enclosure_diameter,
                inner_height = enclosure_inner_height,
                height = enclosure_height,
                control_panel_z = control_panel_z,
                control_panel_depth = control_panel_depth,
                control_panel_inset = control_panel_inset,
                tolerance = tolerance,
                petri_dish_z = petri_dish_z,
                petri_dish_clearance = petri_dish_clearance,
                quick_preview = quick_preview
            );

            translate([0, 0, petri_dish_z]) {
                % petri_dish();
            }

            _control_panel();
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
    quick_preview = false,
    debug = false
);
