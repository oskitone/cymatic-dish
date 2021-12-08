PETRI_DISH_DIAMETER = 90.4;
PETRI_DISH_HEIGHT = 16.6;

module petri_dish(
    diameter = PETRI_DISH_DIAMETER,
    height = PETRI_DISH_HEIGHT,
    gray = .25,
    opacity = .25
) {
    color([gray, gray, gray, opacity]) {
        cylinder(
            d = diameter,
            h = height
        );
    }
}
