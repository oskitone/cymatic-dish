use <../../apc/openscad/wheels.scad>;
use <../../poly555/openscad/lib/basic_shapes.scad>;
use <../../poly555/openscad/lib/engraving.scad>;

KNOB_DEFAULT_DIAMETER = 20;
KNOB_DEFAULT_HEIGHT = 10;

CONTROL_PANEL_DEFAULT_GUTTER = 14;
CONTROL_PANEL_DEFAULT_OUTER_GUTTER = 10;

CONTROL_PANEL_DEFAULT_LABEL_SIZE = 3.2;
CONTROL_PANEL_DEFAULT_LABEL_GUTTER = 2;
CONTROL_PANEL_DEFAULT_LABEL_HEIGHT = 1;

function get_control_panel_width(
    count,
    knob_diameter = KNOB_DEFAULT_DIAMETER,
    gutter = CONTROL_PANEL_DEFAULT_GUTTER,
    outer_gutter = CONTROL_PANEL_DEFAULT_OUTER_GUTTER
) = (
    knob_diameter * count + gutter * (count - 1) + outer_gutter * 2
);
function get_control_panel_length(
    knob_diameter = KNOB_DEFAULT_DIAMETER,
    outer_gutter = CONTROL_PANEL_DEFAULT_OUTER_GUTTER,
    label_size = CONTROL_PANEL_DEFAULT_LABEL_SIZE,
    label_gutter = CONTROL_PANEL_DEFAULT_LABEL_GUTTER
) = (
    knob_diameter + label_gutter + label_size + outer_gutter * 2
);

module control_panel(
    labels = ["XYZ"],

    knob_diameter = KNOB_DEFAULT_DIAMETER,
    knob_height = KNOB_DEFAULT_HEIGHT,

    gutter = CONTROL_PANEL_DEFAULT_GUTTER,
    outer_gutter = CONTROL_PANEL_DEFAULT_OUTER_GUTTER,

    label_size = CONTROL_PANEL_DEFAULT_LABEL_SIZE,
    label_gutter = CONTROL_PANEL_DEFAULT_LABEL_GUTTER,
    label_height = CONTROL_PANEL_DEFAULT_LABEL_HEIGHT,

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

    width = get_control_panel_width(count, knob_diameter, gutter, outer_gutter);
    length = get_control_panel_length(
        knob_diameter, outer_gutter, label_size, label_gutter
    );

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
