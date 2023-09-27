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
clipWidth = 5;


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
// side hole (used when rendering walls)
sideHoleHeight = wallThickness + ledHeight + boardThickness + verticalTolerance * 2;
module sideHole() {
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
module cornerLimitor() {
    translate([
        cornerCoords[0],
        cornerCoords[1],
        wallThickness + ledHeight - cornerHeight + verticalTolerance
    ])
    linear_extrude(cornerHeight)
    polygon([[0, 0], [0, -cornerWidth], [-cornerWidth, 0]]);
};
cornerLimitor();
mirror([0, -1, 0]) cornerLimitor();
mirror([-1, 0, 0]) cornerLimitor();
mirror([0, -1, 0]) mirror([-1, 0, 0]) cornerLimitor();

/*
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
*/

// Buttons
module buttons() {
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
        linear_extrude(ledHeight - buttonHeight + wallThickness - verticalTolerance)
        circle(presserRadius, $fn=20);
    };
};
translate([0, buttonsOffsetY * 2 + wallThickness, 0]) buttons();


// Uncomment this to test how buttons fit
// translate([0, 0, verticalTolerance]) buttons();


// Cover
module coverLocker() {
    translate([
        (boardDimensions[0] - wallThickness) / 2,
        0,
        sideHoleHeight - boxHeight
    ])
    linear_extrude(wallThickness * 2)
    square([wallThickness, clipWidth], true);
    
    translate([
        (boardDimensions[0] + horizontalTolerance * 2) / 2,
        0,
        sideHoleHeight - boxHeight + verticalTolerance
    ])
    linear_extrude(wallThickness)
    square([horizontalTolerance * 3, clipWidth], true);
}
module cover() union() {
    // cover plage
    translate([
        0,
        0,
        - wallThickness
    ])
    linear_extrude(wallThickness)
    square(boardDimensions, true);
    coverLocker();
    mirror([-1, 0, 0]) coverLocker();
};
mirror([0, 0, -1])
translate([0, - (bottom[1] + wallThickness), 0])
cover();

// Uncomment this to test how cover fits:
// translate([0, 0, boxHeight]) cover();
