boardThickness = 1.5;
wallThickness = 1.6;
ledHeight = 9;
spaceUnderBoard = 3;
verticalTolerance = 0.1;

boxInnerHeight = spaceUnderBoard + boardThickness + ledHeight + verticalTolerance;
boxHeight = boxInnerHeight + (wallThickness * 2);

bottomInner = [56, 33];
cornerCoords = [for (a = bottomInner) a / 2];
bottom = [for (a = bottomInner) a + wallThickness * 2];

buttonsOffsetX = 4.5;
buttonsOffsetY = 5.5;
buttonsDistance = 10;
buttonHeight = 5;
buttonWidth = 7;
buttonTolerance = 0.2;
presserRadius = 2;
cornerHeight = 2;
cornerWidth = 3;

// Face
difference() {
    // Bottom of the box (top of the model)
    linear_extrude(wallThickness) square(bottom, true);
    
    // Button holes
    union() {
        for (i = [0 : 2]) {
            translate([
                cornerCoords[0] - buttonsOffsetX - buttonsDistance * i,
                cornerCoords[1] - buttonsOffsetY,
                0,
            ])
            linear_extrude(wallThickness) square(buttonWidth, true);
        }
    };
};

// Walls
linear_extrude(boxHeight) {
    
    difference() {
        square(bottom, true);
        square(bottomInner, true);
    }
};

// Corner limitors
module cornerLimitor() {
    translate([
        cornerCoords[0],
        cornerCoords[1],
        boxHeight - spaceUnderBoard - boardThickness - cornerHeight - verticalTolerance
    ])
    linear_extrude(cornerHeight)
    polygon([[0, 0], [0, -cornerWidth], [-cornerWidth, 0]]);
};
cornerLimitor();
mirror([0, -1, 0]) cornerLimitor();
mirror([-1, 0, 0]) cornerLimitor();
mirror([0, -1, 0]) mirror([-1, 0, 0]) cornerLimitor();

// Bottom limitors
bottomLimitorDepth = 0.8;
bottomLimitorWidth = 5;
module bottomLimitor() {
    translate([
        0,
        cornerCoords[1] - bottomLimitorDepth / 2,
        // boxHeight - wallThickness,
        boxHeight - spaceUnderBoard - wallThickness
    ])
    linear_extrude(spaceUnderBoard + wallThickness)
    square([bottomLimitorWidth, bottomLimitorDepth], true);
};
bottomLimitor();
mirror([0, -1, 0]) bottomLimitor();

// Buttons
translate([0, buttonsOffsetY * 2, 0])
for (i = [0 : 2]) {
    
    // button face
    translate([
        cornerCoords[0] - buttonsOffsetX - buttonsDistance * i,
        cornerCoords[1] - buttonsOffsetY,
        0,
    ])
    linear_extrude(wallThickness * 2)
    square(buttonWidth - buttonTolerance * 2, true);
    
    // button back
    translate([
        cornerCoords[0] - buttonsOffsetX - buttonsDistance * i,
        cornerCoords[1] - buttonsOffsetY,
        wallThickness,
    ])
    linear_extrude(wallThickness)
    square(buttonWidth + buttonTolerance * 2, true);
    
    // presser
    translate([
        cornerCoords[0] - buttonsOffsetX - buttonsDistance * i,
        cornerCoords[1] - buttonsOffsetY,
        0,
    ])
    linear_extrude(ledHeight - buttonHeight + wallThickness)
    circle(presserRadius, $fn=20);
};