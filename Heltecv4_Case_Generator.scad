// ============================================================
// Heltec WiFi LoRa 32 (V4) — Parametric Case
// magikh0e
// ============================================================
// Two-part snap+screw enclosure: base tray + lid.
// Board: ESP32-S3 + SX1262, ~51.7 x 25.4 mm, OLED on top, IPEX1.0 LoRa antenna.
// Front-edge connector row (USER btn, USB-C, RST btn) sits on ONE long edge.
// VERIFY connector X positions with calipers — the datasheet gives board size
// precisely but exact port offsets vary, and a case that misses the USB-C by
// 2mm is scrap. Print the fit-checker first (see GUIDE).
// ============================================================

/* [Render] */
part = "both";   // ["base","lid","lid_snap","lid_screw","both","all_lids","oled_cover"]
explode = 8;     // visual gap when part=="both"

/* [Board] — Heltec WiFi LoRa 32 V4 (verified against V4.2 dimensional drawing) */
board_x        = 51.7;   // length (datasheet 51.69mm)
board_y        = 25.4;   // width  (datasheet 25.40mm)
board_thick    = 1.6;
// V4 component stack is 10.70mm above the PCB (datasheet + side-view drawing).
standoff_h     = 4;

// M2 mounting holes — measured hole-to-hole spans (confirmed against the board):
//   along the 51.69 length: 33.00mm hole-to-hole (centered)
//   across the 25.40 width:  18.60mm hole-to-hole
hole_span_x    = 33.00;  // hole-to-hole along board length
hole_span_y    = 14.00;  // hole-to-hole across board width (datasheet p16)
screw_hole_d   = 1.8;    // M2 self-tap pilot in plastic
post_d         = 4.5;    // standoff post OD (M2)

/* [Clearances] */
wall           = 2.0;
floor_t        = 2.0;
lid_t          = 2.0;
clr            = 0.4;    // gap around PCB
// Headroom above PCB. Real V4 stack (incl. OLED) is 10.70mm; +margin.
comp_clear     = 11.5;

/* [Connector row] — all along one LONG edge (the "front") */
/* [Connectors] — from the V4.2 drawing, USB-C + JSTs are on a SHORT end */
// USB-C sits on a short end of the board. usbc_pos locates it across the width (board_y),
// usbc_z is the connector CENTER height above the PCB top (side-view drawing: ~5.5mm).
conn_edge      = "x0";        // ["x0","x1"] which short end the connectors face
usbc_pos       = board_y/2 + 3.1;  // across-width position (drawing: 15.81 from edge -> +3.1 off center)
usbc_w         = 9.5;         // opening width
usbc_h         = 3.5;         // opening height (V4 USB-C ~3.2 + margin)
usbc_z         = 5.5;         // USB-C connector CENTER height above PCB top (side view)

// Two SH1.25 JSTs on the same short end, near the USB-C.
jst_enable     = true;
jst_w          = 5.0;         // JST lead slot width
jst_h          = 4.0;         // JST lead slot height
jst1_pos       = board_y/2 - 1.5;  // solar JST across-width position
jst2_pos       = board_y/2 + 7.5;  // battery JST
jst_z          = 2.0;         // JST lead height above PCB

// Buttons (USER/RST) also on this short end — poke holes, optional.
btn_d          = 3.5;         // pin-poke hole for the buttons (0 to disable)
btn1_pos       = board_y/2 - 7;
btn2_pos       = board_y/2 + 7;

/* [LoRa antenna] */
// V4 LoRa antenna is IPEX1.0. Default: SMA bulkhead hole so you run a u.FL->SMA
// pigtail out to a real antenna (best for range). Option: internal IPEX, no hole.
ant_mode       = "sma";       // ["sma","internal"]
ant_d          = 6.5;         // SMA bulkhead nut hole (~6.3-6.5mm)
ant_edge       = "x1";        // which wall the SMA exits (short end)
ant_pos        = board_y/2;   // position along that edge
ant_z          = 3;           // height of hole center above PCB top

/* [OLED window] */
// V4 0.96" OLED, active area 22.00 x 11.40mm (from the V4.2 drawing). Toggle a lid window.
oled_window    = true;        // true = cutout to see screen; false = solid lid
oled_w         = 22.0;        // window width  (X, along board length)
oled_h         = 11.4;        // window height (Y, across board width)
oled_cx        = board_x*0.62; // window center X (OLED sits toward the non-USB end) — VERIFY
oled_cy        = board_y/2;   // window center Y
oled_recess    = true;        // sink a ledge so a clear cover sits flush
oled_ledge     = 1.5;         // ledge width around the window for the cover to rest on
oled_cover_t   = 1.0;         // recess depth for the cover
oled_cover_gap = 0.3;         // fit clearance so the printed cover drops into the recess

/* [Lid fit] */
use_screws     = true;
use_snaps      = true;
lip_h          = 4;
lip_inset      = wall/2;
vent           = true;
vent_count     = 4;

/* [Snap-fit] (when use_snaps) — on the two LONG walls */
snap_count     = 2;
snap_w         = 6;
snap_depth     = 0.9;
snap_h         = 1.6;
snap_z         = 2.0;
snap_lead      = 0.6;
snap_relief    = true;

/* [Lanyard loop] */
lanyard        = true;
lanyard_edge   = "x1";        // short end; if SMA also on x1, move one of them
lanyard_pos    = 0.5;
lanyard_thick  = 4;
lanyard_reach  = 9;
lanyard_hole_d = 4;

/* [Battery shelf] */
battery        = false;
bat_x          = 50;
bat_y          = 30;
bat_wall       = 1.5;
bat_pos_x      = 1;
bat_pos_y      = 1;

/* [JST pigtail exit] */
// Slot for the SH1.25 battery / solar leads to exit. On the connector edge.
pigtail_slot   = true;
pigtail_w      = 5;
pigtail_h      = 3;
pigtail_edge   = "y0";
pigtail_x      = 40;          // X position along the long edge
pigtail_z      = 0;

// ============================================================
// derived
// ============================================================
inner_x = board_x + 2*clr;
inner_y = board_y + 2*clr;
inner_z = standoff_h + board_thick + comp_clear;

out_x = inner_x + 2*wall;
out_y = inner_y + 2*wall;
base_z = floor_t + standoff_h + board_thick + 1;
lid_z  = inner_z - standoff_h - board_thick + lid_t;

eps = 0.01;
$fn = 48;

// M2 hole positions: centered rectangle, 33.00 x 18.60 hole-to-hole.
// In PCB coordinates [0..board_x] x [0..board_y]; clr offsets into the cavity.
hcx = clr + board_x/2;
hcy = clr + board_y/2;
hxa = hcx + hole_span_x/2;   // +x column
hxb = hcx - hole_span_x/2;   // -x column
hy_hi = hcy + hole_span_y/2;
hy_lo = hcy - hole_span_y/2;
holes = [[hxb,hy_lo],[hxa,hy_lo],[hxb,hy_hi],[hxa,hy_hi]];

// ============================================================
// primitives
// ============================================================
module rrect(x,y,z,r=2){
    linear_extrude(z) offset(r) offset(-r) square([x,y]);
}
module post(h){
    difference(){
        cylinder(d=post_d, h=h);
        translate([0,0,-eps]) cylinder(d=screw_hole_d, h=h+2*eps);
    }
}

// rectangular port cut through a LONG wall (y0/y1), centered at board-X = cx
module port_cut_long(edge, cx, w, h, z_above_pcb){
    zc = floor_t + standoff_h + board_thick + z_above_pcb;
    xc = wall + clr + cx;
    if(edge=="y0") translate([xc - w/2, -eps, zc]) cube([w, wall+2*eps, h]);
    if(edge=="y1") translate([xc - w/2, out_y-wall-eps, zc]) cube([w, wall+2*eps, h]);
}
// round hole through a LONG wall
module hole_cut_long(edge, cx, d, z_above_pcb){
    zc = floor_t + standoff_h + board_thick + z_above_pcb;
    xc = wall + clr + cx;
    if(edge=="y0") translate([xc, wall+eps, zc]) rotate([90,0,0]) cylinder(d=d, h=wall+2*eps, center=true);
    if(edge=="y1") translate([xc, out_y-wall-eps, zc]) rotate([-90,0,0]) cylinder(d=d, h=wall+2*eps, center=true);
}
// rectangular port cut through a SHORT wall (x0/x1), centered at board-Y = cy
module port_cut_short(edge, cy, w, h, z_above_pcb){
    zc = floor_t + standoff_h + board_thick + z_above_pcb;
    yc = wall + clr + cy;
    if(edge=="x0") translate([-eps, yc - w/2, zc]) cube([wall+2*eps, w, h]);
    if(edge=="x1") translate([out_x-wall-eps, yc - w/2, zc]) cube([wall+2*eps, w, h]);
}
// round hole through a SHORT wall (x0/x1)
module hole_cut_short(edge, cy, d, z_above_pcb){
    zc = floor_t + standoff_h + board_thick + z_above_pcb;
    yc = wall + clr + cy;
    if(edge=="x0") translate([wall+eps, yc, zc]) rotate([0,-90,0]) cylinder(d=d, h=wall+2*eps, center=true);
    if(edge=="x1") translate([out_x-wall-eps, yc, zc]) rotate([0,90,0]) cylinder(d=d, h=wall+2*eps, center=true);
}

// rounded-end slot primitive (along X, pierces Y)
module _slotx(w,h){
    hull(){
        translate([-w/2 + h/2, 0, 0]) rotate([90,0,0]) cylinder(d=h, h=wall+2*eps, center=true);
        translate([ w/2 - h/2, 0, 0]) rotate([90,0,0]) cylinder(d=h, h=wall+2*eps, center=true);
    }
}
module pigtail_cut(){
    if(pigtail_slot){
        xc = wall + clr + pigtail_x;
        zb = floor_t + pigtail_z + pigtail_h/2;
        if(pigtail_edge=="y0") translate([xc, wall+eps, zb]) _slotx(pigtail_w,pigtail_h);
        if(pigtail_edge=="y1") translate([xc, out_y-wall-eps, zb]) _slotx(pigtail_w,pigtail_h);
    }
}

module vents(){
    if(vent)
    for(s=[0,1])
    for(i=[0:vent_count-1]){
        yy=(s==0)? -eps : out_y-wall-eps;
        translate([out_x*0.28 + i*((out_x*0.44)/vent_count), yy, floor_t+standoff_h+5])
            cube([2, wall+2*eps, inner_z*0.35]);
    }
}

// ============================================================
// lanyard
// ============================================================
module _tab(w){
    difference(){
        hull(){
            cube([w, eps, lanyard_thick]);
            translate([w/2, lanyard_reach, 0]) cylinder(d=w, h=lanyard_thick);
        }
        translate([w/2, lanyard_reach, -eps]) cylinder(d=lanyard_hole_d, h=lanyard_thick+2*eps);
    }
}
module lanyard_tab(){
    if(lanyard){
        z=floor_t; w=lanyard_hole_d+2*2.5;
        if(lanyard_edge=="y1") translate([wall+inner_x*lanyard_pos - w/2, out_y-eps, z]) _tab(w);
        if(lanyard_edge=="y0") translate([wall+inner_x*lanyard_pos + w/2, eps, z]) rotate([0,0,180]) _tab(w);
        if(lanyard_edge=="x1") translate([out_x-eps, wall+inner_y*lanyard_pos - w/2, z]) rotate([0,0,-90]) _tab(w);
        if(lanyard_edge=="x0") translate([eps, wall+inner_y*lanyard_pos + w/2, z]) rotate([0,0,90]) _tab(w);
    }
}

// ============================================================
// battery shelf
// ============================================================
module battery_shelf(){
    if(battery)
    translate([wall+clr+bat_pos_x, wall+clr+bat_pos_y, floor_t-eps])
    difference(){
        rrect(bat_x+2*bat_wall, bat_y+2*bat_wall, bat_wall, 1.5);
        translate([bat_wall,bat_wall,-eps]) rrect(bat_x, bat_y, bat_wall+2*eps, 1);
    }
}

// ============================================================
// snap-fit
// ============================================================
function snap_xs() = [ for(i=[0:snap_count-1]) wall + inner_x*(i+1)/(snap_count+1) ];

module _snap_bump(){
    hull(){
        translate([-snap_w/2, 0, -snap_h/2]) cube([snap_w, eps, snap_h]);
        translate([-snap_w/2, snap_depth, -snap_h/2+snap_lead]) cube([snap_w, eps, snap_h-2*snap_lead]);
    }
}
module _snap_relief_slots(){
    sl=0.8; gap=snap_w/2+1.2;
    for(s=[-1,1]) translate([s*gap - sl/2, -eps, -lip_h-eps]) cube([sl, lip_inset+2*eps, lip_h*0.9]);
}
module _recess_y0(){ cl=0.15; translate([-(snap_w/2+cl), -snap_depth, -(snap_h/2+cl)]) cube([snap_w+2*cl, snap_depth+eps, snap_h+2*cl]); }
module _recess_y1(){ cl=0.15; translate([-(snap_w/2+cl), 0, -(snap_h/2+cl)]) cube([snap_w+2*cl, snap_depth+eps, snap_h+2*cl]); }

module base_snap_recesses(){
    if(use_snaps)
    for(x=snap_xs()){
        zc=floor_t+snap_z;
        translate([x, wall, zc]) _recess_y0();
        translate([x, out_y-wall, zc]) _recess_y1();
    }
}
module lid_snap_bumps(snaps=use_snaps){
    if(snaps)
    for(x=snap_xs()){
        zc=-lip_h+snap_z;
        translate([x, wall+lip_inset, zc]) rotate([0,0,180]) _snap_bump();
        translate([x, out_y-wall-lip_inset, zc]) _snap_bump();
    }
}
module lid_snap_relief(snaps=use_snaps){
    if(snaps && snap_relief)
    for(x=snap_xs()){
        translate([x, wall+lip_inset, 0]) _snap_relief_slots();
        translate([x, out_y-wall-lip_inset, 0]) rotate([0,0,180]) _snap_relief_slots();
    }
}

// ============================================================
// OLED window in lid
// ============================================================
module oled_cut(){
    if(oled_window){
        cx = wall+clr+oled_cx;
        cy = wall+clr+oled_cy;
        translate([cx-oled_w/2, cy-oled_h/2, -lip_h-eps])
            cube([oled_w, oled_h, lid_t+lip_h+2*eps]);
        if(oled_recess)
            translate([cx-(oled_w/2+oled_ledge), cy-(oled_h/2+oled_ledge), lid_t-oled_cover_t])
                cube([oled_w+2*oled_ledge, oled_h+2*oled_ledge, oled_cover_t+eps]);
    }
}

// Printable clear cover that drops into the recess ledge.
// Print this in transparent filament (or cut acrylic to the same size).
module oled_cover(){
    cw = oled_w + 2*oled_ledge - oled_cover_gap;
    ch = oled_h + 2*oled_ledge - oled_cover_gap;
    rrect(cw, ch, oled_cover_t, 1);
}

// ============================================================
// BASE
// ============================================================
module base(){
    difference(){
        union(){
            difference(){
                rrect(out_x,out_y,base_z,3);
                translate([wall,wall,floor_t]) rrect(inner_x,inner_y,base_z,2);
            }
            for(p=holes) translate([wall+p[0], wall+p[1], floor_t]) post(standoff_h);
            lanyard_tab();
            battery_shelf();
        }
        // USB-C on the short end (drawing-verified position/height)
        port_cut_short(conn_edge, usbc_pos, usbc_w, usbc_h, usbc_z - usbc_h/2);
        // two SH1.25 JSTs on the same short end
        if(jst_enable){
            port_cut_short(conn_edge, jst1_pos, jst_w, jst_h, jst_z - jst_h/2);
            port_cut_short(conn_edge, jst2_pos, jst_w, jst_h, jst_z - jst_h/2);
        }
        // optional button poke-holes on the same short end
        if(btn_d>0){
            hole_cut_short(conn_edge, btn1_pos, btn_d, usbc_z);
            hole_cut_short(conn_edge, btn2_pos, btn_d, usbc_z);
        }
        // LoRa antenna (SMA bulkhead on a chosen wall, or internal)
        if(ant_mode=="sma") hole_cut_short(ant_edge, ant_pos, ant_d, ant_z);
        base_snap_recesses();
        vents();
    }
}

// ============================================================
// LID
// ============================================================
module lid(snaps=use_snaps, screws=use_screws){
    difference(){
        union(){
            rrect(out_x,out_y,lid_t,3);
            translate([wall+lip_inset, wall+lip_inset, -lip_h])
                difference(){
                    rrect(inner_x-2*lip_inset, inner_y-2*lip_inset, lip_h, 1.5);
                    translate([lip_inset,lip_inset,-eps]) rrect(inner_x-4*lip_inset, inner_y-4*lip_inset, lip_h+2*eps,1);
                }
            lid_snap_bumps(snaps);
        }
        if(screws)
            for(p=holes)
                translate([wall+p[0], wall+p[1], -lip_h-eps]) cylinder(d=screw_hole_d+0.6, h=lid_t+lip_h+2*eps);
        oled_cut();
        lid_snap_relief(snaps);
    }
}

// ============================================================
// place
// ============================================================
if(part=="base") base();
else if(part=="lid") lid();
else if(part=="lid_snap") lid(snaps=true, screws=false);
else if(part=="lid_screw") lid(snaps=false, screws=true);
else if(part=="all_lids"){
    lid(snaps=true, screws=false);
    translate([0, out_y+6, 0]) lid(snaps=false, screws=true);
}
else if(part=="oled_cover") oled_cover();
else {
    base();
    translate([0,0, base_z+explode+lid_z]) rotate([180,0,0]) lid();
}
