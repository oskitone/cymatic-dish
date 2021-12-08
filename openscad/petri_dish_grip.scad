include <control_panel.scad>;
include <enclosure.scad>;
include <petri_dish.scad>;
include <speaker.scad>;

$fn = 60;

module petri_dish_grip(
    wall = 1.8,
    inner_wall = 1.2,

    dish_diameter = PETRI_DISH_DIAMETER ,
    dish_height = PETRI_DISH_HEIGHT,

    speaker_cavity_diameter = SPEAKER_DIAMETER - SPEAKER_BRIM_DEPTH * 2,
    speaker_brim_height = SPEAKER_BRIM_HEIGHT,
    speaker_magnet_height = SPEAKER_MAGNET_HEIGHT,
    speaker_magnet_diameter = SPEAKER_MAGNET_DIAMETER,

    background_disc_height = .6,
    floor_height = 1,

    rattle_gap = 1,

    show_top = true,
    show_bottom = true,

    tolerance = 0
) {
    e = .0381;

    cavity_diameter = dish_diameter + tolerance * 2;
    outer_diameter = cavity_diameter + wall * 2;

    cone_cavity_height = SPEAKER_CONE_HEIGHT - rattle_gap - floor_height;
    bottom_height = SPEAKER_MAGNET_HEIGHT + cone_cavity_height + floor_height;

    module _top() {
        cavity_height = dish_height + background_disc_height + speaker_brim_height;
        outer_height = cavity_height + floor_height;

        difference() {
            cylinder(d = outer_diameter, h = outer_height);

            translate([0, 0, floor_height]) {
                cylinder(d = cavity_diameter, h = cavity_height + e);
            }

            translate([0, 0, -e]) {
                cylinder(
                    d = speaker_cavity_diameter + tolerance * 2,
                    h = floor_height + e * 2
                );
            }
        }
    }

    module _bottom() {
        magnet_grip_cavity_diameter = speaker_magnet_diameter + tolerance * 2;
        magnet_grip_height = bottom_height - cone_cavity_height - floor_height;

        module _outer(
            wire_access_width = 4
        ) {
            difference() {
                cylinder(d = outer_diameter, h = bottom_height);

                translate([0, 0, floor_height]) {
                    cylinder(
                        d = outer_diameter - wall * 2,
                        h = bottom_height - floor_height + e
                    );
                }

                translate([
                    wire_access_width / -2 - tolerance,
                    outer_diameter / -2 - e,
                    floor_height + e
                ]) {
                    cube([
                        wire_access_width + tolerance * 2,
                        wall * 2,
                        bottom_height - floor_height
                    ]);
                }
            }
        }

        module _magnet_grip() {
            translate([0, 0, floor_height - e]) {
                difference() {
                    cylinder(
                        d = magnet_grip_cavity_diameter + inner_wall * 2,
                        h = magnet_grip_height + e
                    );

                    translate([0, 0, -e]) {
                        cylinder(
                            d = magnet_grip_cavity_diameter,
                            h = magnet_grip_height + e * 3
                        );
                    }
                }
            }
        }

        module _webs(
            count = 5,
            width = inner_wall
        ) {
            y = magnet_grip_cavity_diameter / 2 + e;

            length = outer_diameter / 2 - wall - y + e;

            for (i = [0 : count - 1]) {
                rotate([0, 0, 360 * (i / count)]) {
                    translate([width / -2, y, floor_height - e]) {
                        cube([
                            width,
                            length,
                            magnet_grip_height + e
                        ]);
                    }
                }
            }
        }

        _outer();
        _magnet_grip();
        _webs();
    }

    if (show_top) {
        _top();
    }

    if (show_bottom) {
        translate([0, 0, -(bottom_height + rattle_gap)]) {
            _bottom();
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
