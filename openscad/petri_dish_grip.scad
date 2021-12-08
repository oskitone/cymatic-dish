include <control_panel.scad>;
include <enclosure.scad>;
include <petri_dish.scad>;
include <speaker.scad>;

$fn = 60;

module petri_dish_grip(
    wall = 1.8,

    dish_diameter = PETRI_DISH_DIAMETER ,
    dish_height = PETRI_DISH_HEIGHT,

    speaker_cavity_diameter = SPEAKER_DIAMETER - SPEAKER_BRIM_DEPTH * 2,
    speaker_brim_height = SPEAKER_BRIM_HEIGHT,

    background_disc_height = .6,
    floor_height = 1,

    tolerance = 0
) {
    e = .0381;

    cavity_diameter = dish_diameter + tolerance * 2;
    cavity_height = dish_height + background_disc_height + speaker_brim_height;

    outer_diameter = cavity_diameter + wall * 2;
    outer_height = cavity_height + floor_height;

    difference() {
        cylinder(
            d = outer_diameter,
            h = outer_height
        );

        translate([0, 0, floor_height]) {
            cylinder(
                d = cavity_diameter,
                h = cavity_height + e
            );
        }

        translate([0, 0, -e]) {
            cylinder(
                d = speaker_cavity_diameter + tolerance * 2,
                h = floor_height + e * 2
            );
        }
    }
}

module background_disc(
    diameter = PETRI_DISH_DIAMETER,
    height = .6
) {
    cylinder(
        d = diameter,
        h = height
    );
}

background_disc_height = .6;
floor_height = 1;

difference() {
    group() {
        translate([0, 0, floor_height + background_disc_height + SPEAKER_BRIM_HEIGHT + .01]) {
            % petri_dish();
        }

        translate([0, 0, floor_height + SPEAKER_BRIM_HEIGHT]) {
            # background_disc(height = background_disc_height);
        }

        translate([0, 0, floor_height - SPEAKER_TOTAL_HEIGHT + SPEAKER_BRIM_HEIGHT]) {
            % speaker();
        }

        petri_dish_grip(
            tolerance = .2,
            background_disc_height = background_disc_height,
            floor_height = floor_height
        );
    }

    * translate([0, -100, -100]) {
        cube([100, 100 * 2, 100 * 2]);
    }
}
