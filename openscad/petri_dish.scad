PETRI_DISH_DIAMETER = 100;
PETRI_DISH_HEIGHT = 15;

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
