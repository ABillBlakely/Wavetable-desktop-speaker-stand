
// Settings file for wavetable_desktop_speaker_stand.scad
// Model: Template
// Year created: 2022

// ASCII diagram of most dimensions:
//
//                    |
//                    |<-._  angle
//                    |    \
//                    |     |      top_depth   ___________---------->/
//                    |    _v________----------                     /
//              /<---------                                        /
//             /                                     ___________   _____
//            /                  __________----------           )    ^
//       \   __________----------                               /    |
//      /   /                                                  /     |
//   width /                                     ___________  /      |
//    /   /                  __________----------       ____)/       |
//   \   /__________----------               ______------            |
//       /                    _______--------                        |
//      |       ______-------                                     height
//      |      /   \__________                                       |
//      |     /    /          -----------____________                |
//      |    (    /                                  )               |
//      |     \  /                                   /               |
//      |      \/__________                         /                |
//      |                  ----------____________  /                 |
//       \_______________________________________)/                __v__
//
//      |                                         |
//      |                                         |
//      |<--------------bottom depth------------->|
//

// thickness is best thought of as overall 'chunkiness.'
// technically the minimum thickness of the back and thickness of top and bottom where they meet the back.
// The leading edges of the top and bottom will taper out to about 1/2 of the thickness.
thickness = 12;

// width of the stand.
width = 125;

//height from flat surface to front edge:
height = 80;

// top_depth is measured along the top surface of the stand, it should be similar to the depth of your speaker.
top_depth = 125;

// The bottom platform can be shorter than the top, values from 0.8 to 1.0 work well with larger values being more stable.
bottom_depth = 0.8*top_depth;

// tilt back angle of the top surface. Depending on thickness, infill percent, speaker weight, the stand could bend a little.
// recommended value is < 12 degrees
angle = 12;

// Include a lip at the back to prevent the speaker from sliding backwards.
// lip dimensions are derived from `thickness`
// the stop is in addition to the speaker depth so no changes to `top_depth` should be required.
include_stop = false;
// adjustable height, but must be at least 1/2 the thickness because of the half round that is added.
stop_height = 6;

