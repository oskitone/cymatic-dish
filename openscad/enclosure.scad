use <../../poly555/openscad/lib/basic_shapes.scad>;

include <petri_dish.scad>;

ENCLOSURE_WALL = 2.4;
ENCLOSURE_FLOOR_CEILING = 1.8;
ENCLOSURE_INNER_WALL = 1.2;
ENCLOSURE_FILLET = 2;

module enclosure(
    wall = 2,
    brim = 6,

    fillet = ENCLOSURE_FILLET,

    tolerance = 0,

    petri_dish_z,
    petri_dish_clearance = 1,

    quick_preview = false
) {
    e = .0824;

    inner_diameter = PETRI_DISH_DIAMETER
        + tolerance * 2 + petri_dish_clearance * 2;
    outer_diameter = inner_diameter + ENCLOSURE_WALL * 2;
    window_diameter = outer_diameter - brim * 2;

    inner_height = (petri_dish_z - ENCLOSURE_FLOOR_CEILING)
        + PETRI_DISH_HEIGHT + petri_dish_clearance;
    height = inner_height + ENCLOSURE_FLOOR_CEILING * 2;

    module _outer() {
        module _end() {
            render() donut(
                diameter = outer_diameter,
                thickness = fillet * 2,
                segments = 36
            );
        }

        if (quick_preview) {
            cylinder(
                d = outer_diameter,
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
