
include <../OpenSCADdesigns/MakeInclude.scad>
include <../OpenSCADdesigns/chamferedCylinders.scad>
use <../OpenSCADdesigns/torus.scad>

diskOD = 40;
diskZ = 10;
diskChamferZ = 3;
diskChamferRadius = 4.8;
diskOffsetY = 8;

// shackleX = 15;
// shackleY = 8.5;
// cornerDia = 1.5;
// cornerOffset = cornerDia * 0.3;
// echo("cornerOffset = ", cornerOffset);
// x2 = shackleX/2 - cornerOffset;
// y2 = shackleY/2 - cornerOffset;
shackleOpeningDia = 18;

ratchetLineHoleDia = 7/32*25.4;
ratchetLineSpacing = 26;
ratchetLineAngle = 5;

echo("ratchetLineHoleDia = ", ratchetLineHoleDia);

lineRecessZ = 20;
lineDia = 15 * 1.25;
lineRecessDia = 30;

module disk()
{
    difference()
    {
        hull()
        {
            doubleY() translate([0,diskOffsetY,0]) radiusedChamferedCylinderDoubleEnded(d=diskOD, h=diskZ, r=diskChamferRadius, cz=diskChamferZ);
        }

        shackleOpening();
        lineRecess();
        lineHoles();
    }
}

module lineHoles()
{
    diskEdgeX = diskOD/2;
    doubleY() 
        translate([0, ratchetLineSpacing/2, diskZ/2])
            rotate([0,0,-ratchetLineAngle]) rotate([0,90,0])
            {
                tcy([0,0,-100], d=ratchetLineHoleDia, h=200);
                translate([0,0,diskEdgeX-ratchetLineHoleDia/2-4]) cylinder(d2=20, d1=0, h=10);
                translate([0,0,-diskEdgeX-10+ratchetLineHoleDia/2+4]) cylinder(d1=20, d2=0, h=10);
            }
}

module lineRecess()
{
    difference()
    {
        translate([0,0,lineRecessZ])
            rotate([0,90,0]) 
                hull() torus3(outsideDiameter=lineRecessDia, circleDiameter=lineDia);
    }
}

module shackleOpening()
{
    // The hole:
    h = 200;
    tcy([0,0,-h/2], d=shackleOpeningDia, h=h);

    // Chamfers:
    cz = 3;
    translate([0,0,-12.5+shackleOpeningDia/2+cz]) cylinder(d1=25, d2=0, h=12.5);
    translate([0,0,diskZ-shackleOpeningDia/2-cz]) cylinder(d2=40, d1=0, h=20);
}

module clip(d=0.0)
{
	tcu([0-d, -200, -200], 400);
    // tcu([-200, -200, diskZ/2-d], 400);
}

if(developmentRender)
{
	difference()
	{
		display() disk();
        displayGhost() shackle();
		clip();
	}
}
else
{
	disk();
}

module shackle()
{
    offsetZ = 2;
    x = 14.5;
    y = 8.1;
    z = 16 + offsetZ;

    tcu([-x/2, -y/2, -offsetZ], [x, y, z]);
}