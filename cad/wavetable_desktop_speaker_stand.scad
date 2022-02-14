// To customize this model, it is reccomended to create a copy of the params_template.scad file.
include <params_template_small.scad>
// include <params_template_small_with_backstop.scad>
// include <params_template_large.scad>

finalize();

$fn=100;

// Calculated values, not recommended to change.
tapered_thickness = thickness / 2;
back_height = height - top_depth * sin(angle);
in_round = (back_height + 2 * thickness * (sin(angle) - 1)) / 2;
out_round = tapered_thickness / 2;
// Stop height moved to params file:
// stop_height = thickness / 2;

// For debug, access to each submodule:
// backstop();
// form();
// profile();
// base();
// back();
// top();


module finalize(){
    // This module gets the final elements of the stand including
    // adding the backstop if set to true. This module should be
    // called to create the complete model.

    rotate([90, 0, -90])
    translate([0,0,width/2])

    if (include_stop){
        union(){
            speaker_stand();
            backstop();
        }
    }
    else{
        speaker_stand();
    }
}
module backstop(){

    // This module creates the backstop which is optionally added to the stand.
    // It also adds a concavity to the backside which serves to balance the
    // addtional thickness caused by adding the backstop.

    // Crucial coordinates of the new back for calculating the backstop concavity
    Ax = (stop_height - out_round) * sin(angle) + 2 * out_round * cos(angle);
    Ay = (stop_height - out_round) * cos(angle) + back_height - 2 * out_round * sin(angle);
    Bx = 0;
    By = out_round;

    // We need to determine a circle such that the new (flat) rear edge of the backstop creates
    // a chord of the circle that will carve out the concave back.

    // Determine the chord length (equal to back length) and angle (equal to back angle):
    chord_length = sqrt((Ax - Bx) ^ 2 + (Ay - By) ^ 2);
    back_angle = asin((Ay - By)/chord_length);

    // From these two parameters we can calculate the correct radius with trig.
    rear_concavity_radius = chord_length / 2 / sin (90 - back_angle);
    echo(rear_concavity_radius);

    rotate([0,180, 0])
    linear_extrude(width, center=true){
        union(){
            difference(){
                union(){
                    // build main body of what will become the backstop,
                    // this must extend into the existing profile to cover the rounding there.
                    polygon(points=[
                        [Bx, By],
                        [Bx - thickness, By],
                        [Bx - thickness, back_height + thickness * sin(angle)],
                        [0, back_height],
                        [(stop_height - out_round)*sin(angle), (stop_height - out_round) * cos(angle) + back_height],
                        [Ax, Ay],
                        ]
                    );
                    // add small interior corner radius to soften transition into the backstop.
                    transition_radius = 0.5;
                    // 0.003 is a hacky fix due to a gap that opens at some tilt angles
                    translate([0, back_height-0.003])
                    rotate([0,0,-90 - angle])
                    translate([-transition_radius, -transition_radius])
                    difference(){
                        square(transition_radius);
                        circle(r=transition_radius);
                    }
                }
                // carve out the rear concavity.
                translate([rear_concavity_radius, out_round])
                circle(r=rear_concavity_radius, $fn=500);
            }
            // add circle to top of backstop to create round edge.
            translate([(stop_height - out_round)*sin(angle) + out_round * cos(angle), (stop_height - out_round) * cos(angle) + back_height - out_round * sin(angle)])
            circle(r=out_round);
        }
    }
}

module speaker_stand(){
    // This module extrudes the profile() to create the
    // solid model of the stand excludin the backstop.
    linear_extrude(width, center = true)
    profile();
}

module profile(){
    // This module composes the polygons from base(), back() and top() and
    // adds the concave and convex rounding except in the backstop.

    // form concave corners
    offset(r=-in_round, chamfer=true)
    offset(r=in_round, chamfer=true)

    // form convex corners
    offset(r=out_round, chamfer=true)
    offset(r=-out_round, chamfer=true)
    union(){
        back();
        top();
        base();
    }
}

module base(){
    // This module draws the basic shape of the base,
    // tapering to 1/2 the thickness.
    polygon(points=[
            [0,0],
            [0, thickness],
            [bottom_depth, tapered_thickness],
            [bottom_depth, 0]
        ]
    );
}

module back(){
    // This module draws the basic shape of the back
    square([thickness, back_height]);
}

module top(){
    // This module draws the basic shape of the top angled back
    // by the defined angle, and tapering to 1/2 the thickness.
    rise_from_angle = top_depth * sin(angle);
    translate([0, back_height-thickness])
    polygon(points=[
            [0,0],
            [0, thickness],
            [top_depth, thickness + rise_from_angle],
            [top_depth, thickness - tapered_thickness + rise_from_angle]
        ]
    );
}

