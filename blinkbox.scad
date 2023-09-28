// Board & case dimensions
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

// Button dimensions
buttonsOffsetX = 4.5;
buttonsOffsetY = 5.5;
buttonsDistance = 10;
buttonHeight = 5;
buttonExtraHeight = 1;
buttonWidth = 7;
presserRadius = 2;
cornerHeight = 2;
cornerWidth = 3;
clipWidth = 5;
letters = "RGB";
letterHeight = 0.4;


// Face
difference() {
    // Bottom of the box (top of the model)
    linear_extrude(wallThickness) square(bottom, true);

    union() {
        // Button holes
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
sideHoleHeight = wallThickness + ledHeight + boardThickness + verticalTolerance * 2;
module sideHole() {
    // side hole (used when rendering walls)
    translate([
        cornerCoords[0] + wallThickness / 2,
        0,
        sideHoleHeight,
    ])
    linear_extrude(wallThickness + verticalTolerance * 2)
    square([wallThickness * 2, clipWidth + horizontalTolerance * 2], true);
};
difference() {

    // walls themselves
    linear_extrude(boxHeight) {

        difference() {
            square(bottom, true);
            square(bottomInner, true);
        }
    };

    // Side holes
    sideHole();
    mirror([-1, 0, 0]) sideHole();

}

// Corner limitors
cornerLimitorZ = wallThickness + ledHeight + verticalTolerance;
module cornerLimitor() {
    translate([
        cornerCoords[0],
        cornerCoords[1],
        cornerLimitorZ - cornerHeight
    ])
    linear_extrude(cornerHeight)
    polygon([[0, 0], [0, -cornerWidth], [-cornerWidth, 0]]);
};
cornerLimitor();
mirror([0, -1, 0]) cornerLimitor();
mirror([-1, 0, 0]) cornerLimitor();
mirror([0, -1, 0]) mirror([-1, 0, 0]) cornerLimitor();


// Buttons
module drawLetter(l)
    linear_extrude(letterHeight)
    text(l, size=buttonWidth * 0.8, halign="center", valign="center");
module buttons() {
    for (i = [0 : 2]) {

        bnX = cornerCoords[0] - buttonsOffsetX - buttonsDistance * i;
        bnY = cornerCoords[1] - buttonsOffsetY;

        // button face
        translate([bnX, bnY, -buttonExtraHeight])
            difference() {
                linear_extrude(wallThickness * 2 + buttonExtraHeight)
                    square(buttonWidth - horizontalTolerance * 2, true);
                mirror([-1, 0, 0]) drawLetter(letters[i]);
            };

        // button back
        translate([bnX, bnY, wallThickness])
            linear_extrude(wallThickness)
            square(buttonWidth + horizontalTolerance * 2, true);

        // presser
        translate([bnX, bnY, 0])
            linear_extrude(ledHeight - buttonHeight + wallThickness - verticalTolerance)
            circle(presserRadius, $fn=20);
    };
};
translate([0, buttonsOffsetY * 2 + wallThickness, buttonExtraHeight]) buttons();


// Cover
jambDepth = horizontalTolerance * 2 + 0.3;
coverRestOffset = 10;
coverRestLength = 5;
module coverPlate()
    translate([0, 0, boxHeight - wallThickness])
    linear_extrude(wallThickness)
    square(boardDimensions, true);
module coverRest()
    translate([
        (boardDimensions[0] - coverRestLength) / 2 - coverRestOffset,
        (boardDimensions[1] - wallThickness) / 2,
        cornerLimitorZ + boardThickness])
    linear_extrude(spaceUnderBoard + wallThickness)
    square([coverRestLength, wallThickness], true);

module cover() union() {
    // cover plate
    coverPlate();

    // cover locker
    translate([
        (boardDimensions[0] - wallThickness) / 2,
        0,
        cornerLimitorZ + boardThickness
    ])
    linear_extrude(spaceUnderBoard + wallThickness)
    square([wallThickness, clipWidth], true);

    translate([
        boardDimensions[0] / 2 + horizontalTolerance,
        0,
        sideHoleHeight + verticalTolerance * 2
    ])
    linear_extrude(wallThickness)
    square([wallThickness * 2, clipWidth], true);

    // cover jamb (clicker)
    translate([
        - (boardDimensions[0]) / 2 ,
        -clipWidth / 2,
        cornerLimitorZ + boardThickness + wallThickness + verticalTolerance * 3
        ])
        rotate([0, 90, 90])
        linear_extrude(clipWidth, true)
        polygon([[0, 0], [wallThickness, 0], [0, jambDepth]]);
    translate([
        - (boardDimensions[0] - wallThickness) / 2,
        0,
        cornerLimitorZ + boardThickness + verticalTolerance * 3
    ])
    linear_extrude(spaceUnderBoard + wallThickness - verticalTolerance * 3)
    square([wallThickness, clipWidth], true);

    // cover rests
    coverRest();
    mirror([0, -1, 0]) coverRest();

};
mirror([0, 0, -1])
translate([0, - (bottom[1] + wallThickness), -boxHeight])
cover();


// Board (not part of the model!)
module board() {
    translate([0, 0, cornerLimitorZ])
    linear_extrude(boardThickness)
    square(boardDimensions, true);
}

// board();  // <-- Uncomment to render the board
// cover();     // <-- Uncomment to test how cover fits
// translate([0, 0, verticalTolerance]) buttons();  // <-- Uncomment to test how buttons fit
// buttons();  // <-- Uncomment to see how buttons fit at the limit
