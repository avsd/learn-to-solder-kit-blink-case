boardThickness = 1.5;
boardDimensions = [56, 33];
wallThickness = 1.6;
ledHeight = 9;
spaceUnderBoard = 3;
verticalTolerance = 0.2;
horizontalTolerance = 0.4;

boxInnerHeight = spaceUnderBoard + boardThickness + ledHeight + verticalTolerance;
boxHeight = boxInnerHeight + (wallThickness * 2);

bottomInner = [for (a = boardDimensions) a + horizontalTolerance * 2];
cornerCoords = [for (a = bottomInner) a / 2];
bottom = [for (a = bottomInner) a + wallThickness * 2];

buttonsOffsetX = 4.5;
buttonsOffsetY = 5.5;
buttonsDistance = 10;
buttonHeight = 5;
buttonWidth = 7;
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
        wallThickness + ledHeight - cornerHeight - verticalTolerance
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
bottomLimitorZ = wallThickness + ledHeight + boardThickness + verticalTolerance * 2;
bottomLimitorHeight = boxHeight - bottomLimitorZ - wallThickness;
module bottomLimitor() {
    translate([
        - bottomLimitorWidth / 2,
        cornerCoords[1],
        bottomLimitorZ
    ])
    rotate([180, -90, 0])
    linear_extrude(bottomLimitorWidth)
    polygon([
        [0, 0],
        [bottomLimitorHeight, 0],
        [0, bottomLimitorDepth]
    ]);
};
bottomLimitor();
mirror([0, -1, 0]) bottomLimitor();

// (original bottom limitor, for reference)
module bottomLimitorOrig() {
    translate([
        0,
        cornerCoords[1] - bottomLimitorDepth / 2,
        bottomLimitorZ
    ])
    linear_extrude(boxHeight - bottomLimitorZ - wallThickness)
    square([bottomLimitorWidth, bottomLimitorDepth], true);
};
// bottomLimitorOrig();

// Buttons
translate([0, buttonsOffsetY * 2 + wallThickness, 0])
for (i = [0 : 2]) {
    
    // button face
    translate([
        cornerCoords[0] - buttonsOffsetX - buttonsDistance * i,
        cornerCoords[1] - buttonsOffsetY,
        0,
    ])
    linear_extrude(wallThickness * 2)
    square(buttonWidth - horizontalTolerance * 2, true);
    
    // button back
    translate([
        cornerCoords[0] - buttonsOffsetX - buttonsDistance * i,
        cornerCoords[1] - buttonsOffsetY,
        wallThickness,
    ])
    linear_extrude(wallThickness)
    square(buttonWidth + horizontalTolerance * 2, true);
    
    // presser
    translate([
        cornerCoords[0] - buttonsOffsetX - buttonsDistance * i,
        cornerCoords[1] - buttonsOffsetY,
        0,
    ])
    linear_extrude(ledHeight - buttonHeight + wallThickness - verticalTolerance * 2)
    circle(presserRadius, $fn=20);
};