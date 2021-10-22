use <../../poly555/openscad/lib/basic_shapes.scad>;

include <control_panel.scad>;
include <petri_dish.scad>;

ENCLOSURE_WALL = 2.4;
ENCLOSURE_FLOOR_CEILING = 1.8;
ENCLOSURE_INNER_WALL = 1.2;
ENCLOSURE_FILLET = 2;

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

    control_panel_z = 0,
    control_panel_depth = 1,

    tolerance = 0,

    petri_dish_z,
    petri_dish_clearance,

    quick_preview = true
) {
    e = .0824;

    window_diameter = diameter - brim * 2;

    module _outer() {
        module _end() {
            render() donut(
                diameter = diameter,
                thickness = fillet * 2,
                segments = 36
            );
        }

        if (quick_preview) {
            cylinder(
                d = diameter,
                h = height
            );
        } else {
            hull() {
                for (z = [fillet, height - fillet]) {
                    translate([0, 0, z]) {
                        _end();
                    }
                }
            }
        }

        translate([0, diameter / -2, control_panel_z]) {
            rotate([90, 0, 0]) {
                control_panel(
                    depth = control_panel_depth,
                    tolerance = tolerance,
                    show_panel = true
                );
            }
        }
    }

    difference() {
        _outer();

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
    }
}
