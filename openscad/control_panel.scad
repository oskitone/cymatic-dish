use <../../apc/openscad/wheels.scad>;
use <../../poly555/openscad/lib/basic_shapes.scad>;
use <../../poly555/openscad/lib/engraving.scad>;

module control_panel(
    labels = ["VOL", "FREQ"],

    knob_diameter = 20,
    knob_height = 10,

    gutter = 3,
    outer_gutter = 3,

    label_size = 3.2,
    label_gutter = 2,
    label_height = 1,

    engraving_depth = 1,

    fillet = 0,
    depth = 1,
    chamfer_x = undef,
    chamfer_y = undef,

    tolerance = 0,

    color = "#fff",
    cavity_color = "#eee",

    show_knobs = false,
    show_labels = false,
    show_panel = false
) {
    e = .0525;

    count = len(labels);

    width = knob_diameter * count + gutter * (count - 1)
        + outer_gutter * 2;
    length = knob_diameter + label_gutter + label_size
        + outer_gutter * 2;

    chamfer_x = chamfer_x != undef ? chamfer_x : depth / 2;
    chamfer_y = chamfer_y != undef ? chamfer_y : depth;

    module _knob() {
        translate([
            knob_diameter / 2,
            label_size + label_gutter + knob_diameter / 2,
            0
        ]) {
            wheel(
                diameter = knob_diameter,
                height = knob_height,
                spokes_count = 0,
                brodie_knob_count = 0,
                dimple_count = 1,
                dimple_depth = engraving_depth,
                color = color,
                cavity_color = cavity_color,
                tolerance = tolerance
            );
        }
    }

    module _label(string) {
        translate([
            knob_diameter / 2,
            label_size / 2,
            0
        ]) {
            engraving(
                string = string,
                font = "Orbitron:style=Black",
                size = label_size,
                height = label_height,
                center = true
            );
        }
    }

    module _panel() {
        translate([width / -2 - chamfer_x, length / -2 - chamfer_y, -depth]) {
            hull() {
                cube([
                    width + chamfer_x * 2,
                    length + chamfer_y * 2,
                    e
                ]);

                for (
                    x = [chamfer_x, width + chamfer_x],
                    y = [chamfer_y, length + chamfer_y]
                ) {
                    translate([x, y, depth - fillet]) {
                        sphere(
                            r = max(e, fillet),
                            $fn = undef
                        );
                    }
                }
            }
        }
    }

    for (i = [0 : count - 1]) {
        translate([
            outer_gutter + width / -2 + i * (knob_diameter + gutter),
            outer_gutter + length / -2,
            0
        ]) {
            if (show_knobs) {
                _knob();
            }

            if (show_labels) {
                _label(labels[i]);
            }
        }
    }

    if (show_panel) {
        _panel();
    }
}
