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

    fillet = ENCLOSURE_FILLET,
    depth = 1,
    chamfer_x = undef,
    chamfer_y = undef,

    tolerance = 0,

    show_knobs = false,
    show_labels = false,
    show_panel = false
) {
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
            cylinder(
                d = knob_diameter,
                h = knob_height
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
            flat_top_rectangular_pyramid(
                top_width = width,
                top_length = length,

                bottom_width = width + chamfer_x * 2,
                bottom_length = length + chamfer_y * 2,

                height = depth
            );
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
