use <../../poly555/openscad/lib/basic_shapes.scad>;

include <control_panel.scad>;
include <petri_dish.scad>;

ENCLOSURE_WALL = 2.4;
ENCLOSURE_FLOOR_CEILING = 1.8;
ENCLOSURE_INNER_WALL = 1.2;
ENCLOSURE_FILLET = 2;
ENCLOSURE_ENGRAVING_DEPTH = 1.2;

function get_enclosure_inner_height(
    petri_dish_z,
    petri_dish_clearance
) = (
    (petri_dish_z - ENCLOSURE_FLOOR_CEILING)
    + PETRI_DISH_HEIGHT + petri_dish_clearance
);

function get_enclosure_height(
    petri_dish_z,
    petri_dish_clearance
) = (
    get_enclosure_inner_height(
        petri_dish_z,
        petri_dish_clearance
    )
    + ENCLOSURE_FLOOR_CEILING * 2
);

function get_enclosure_inner_diameter(
    tolerance,
    petri_dish_clearance
) = (
    PETRI_DISH_DIAMETER
    + tolerance * 2 + petri_dish_clearance * 2
);

function get_enclosure_diameter(
    tolerance,
    petri_dish_clearance
) = (
    get_enclosure_inner_diameter(tolerance, petri_dish_clearance)
    + ENCLOSURE_WALL * 2
);

module enclosure(
    inner_diameter,
    diameter,

    inner_height,
    height,

    wall = 2,
    brim = 6,

    fillet = ENCLOSURE_FILLET,

    control_panel_labels = [],
    control_panel_z = 0,
    control_panel_outset = 0,
    control_panel_outset_brim = ENCLOSURE_FILLET,
    control_panel_inset = 0,

    tolerance = 0,

    petri_dish_z,
    petri_dish_clearance,

    color = undef,
    cavity_color = undef,

    quick_preview = true
) {
    e = .0824;

    window_diameter = diameter - brim * 2;

    control_panel_width = get_control_panel_width(len(control_panel_labels));
    control_panel_height = get_control_panel_length();

    module _control_panel_inset_cavity(bleed = 0) {
        translate([
            control_panel_width / -2 - bleed,
            diameter / -2 - control_panel_outset,
            control_panel_z - control_panel_height / 2 - bleed
        ]) {
            cube([
                control_panel_width + bleed * 2,
                control_panel_inset + bleed,
                control_panel_height + bleed * 2
            ]);
        }
    }

    module _outer() {
        module _end() {
            render() donut(
                diameter = diameter,
                thickness = fillet * 2,
                segments = 36
            );
        }

        hull() {
            if (quick_preview) {
                cylinder(
                    d = diameter,
                    h = height
                );
            } else {
                for (z = [fillet, height - fillet]) {
                    translate([0, 0, z]) {
                        _end();
                    }
                }
            }

            if (control_panel_outset > 0) {
                translate([
                    control_panel_width / -2 - control_panel_outset_brim,
                    diameter / -2 + control_panel_inset - control_panel_outset,
                    control_panel_z - control_panel_height / 2
                        - control_panel_outset_brim
                ]) {
                    cube([
                        control_panel_width + control_panel_outset_brim * 2,
                        e,
                        control_panel_height + control_panel_outset_brim * 2
                    ]);
                }
            }
        }
    }

    module _control_panel_backing() {
        intersection() {
            difference() {
                _control_panel_inset_cavity(wall);
                translate([0, -e, 0]) _control_panel_inset_cavity(e);
            }

            translate([0, 0, e]) {
                cylinder(
                    d = diameter - e * 2,
                    h = height - e * 2,
                    $fn = 36
                );
            }
        }
    }

    module _control_panel_labels() {
        y = diameter / -2 + control_panel_inset - control_panel_outset;

        translate([0, y, control_panel_z]) {
            rotate([90, 0, 0]) {
                control_panel(
                    labels = control_panel_labels,
                    label_height = CONTROL_PANEL_DEFAULT_LABEL_HEIGHT + e,
                    engraving_depth = ENCLOSURE_ENGRAVING_DEPTH,
                    tolerance = tolerance,
                    show_labels = true
                );
            }
        }
    }

    group() {
        difference() {
            color(color) {
                _outer();
            }

            color(cavity_color) {
                translate([0, 0, ENCLOSURE_FLOOR_CEILING]) {
                    cylinder(
                        d = inner_diameter,
                        h = inner_height
                    );
                }

                translate([0, 0, height - ENCLOSURE_FLOOR_CEILING - e]) {
                    cylinder(
                        d = window_diameter,
                        h = ENCLOSURE_FLOOR_CEILING + e * 2
                    );
                }

                if (control_panel_inset > 0) {
                    _control_panel_inset_cavity();
                }
            }
        }

        color(cavity_color) {
            _control_panel_backing();
        }

        color(color) {
            _control_panel_labels();
        }
    }
}
