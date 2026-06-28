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

/* [Board] — Heltec WiFi LoRa 32 V4 */
board_x        = 51.7;   // length (datasheet 51.69mm)
board_y        = 25.4;   // width  (datasheet 25.40mm)
board_thick    = 1.6;
// V4 tallest point ~15.6mm incl. OLED bracket. Standoff lifts PCB off the floor
// to clear bottom headers/GNSS connector solder.
standoff_h     = 4;

// V4 uses M2 corner mounting holes. Inset measured from PCB edges — VERIFY.
hole_inset_x   = 2.5;
hole_inset_y   = 2.5;
screw_hole_d   = 1.8;    // M2 self-tap pilot in plastic
post_d         = 4.5;    // standoff post OD (M2)

/* [Clearances] */
wall           = 2.0;
floor_t        = 2.0;
lid_t          = 2.0;
clr            = 0.4;    // gap around PCB
// Headroom above PCB. OLED + bracket is the tall part (~10mm above PCB).
comp_clear     = 12;

/* [Connector row] — all along one LONG edge (the "front") */
// Edge the USB-C / buttons face. V4 row order L->R: USER, USB-C, RST, LEDs, JSTs.
front_edge     = "y0";        // ["y0","y1"] long edge with the connector row
// X positions measured from PCB origin (the board's left end). VERIFY THESE.
usbc_x         = 14;          // USB-C center X
usbc_w         = 9.5;         // opening width
usbc_h         = 4.0;         // opening height (V4 USB-C ~3.2 + margin)
usbc_z         = 1.0;         // bottom of port above PCB top surface

usrbtn_x       = 6;           // USER button center X (0 to disable)
rstbtn_x       = 22;          // RST button center X (0 to disable)
btn_d          = 3.5;         // pin-poke hole for the buttons

/* [LoRa antenna] */
// V4 LoRa antenna is IPEX1.0. Default: SMA bulkhead hole so you run a u.FL->SMA
// pigtail out to a real antenna (best for range). Option: internal IPEX, no hole.
ant_mode       = "sma";       // ["sma","internal"]
ant_d          = 6.5;         // SMA bulkhead nut hole (~6.3-6.5mm)
ant_edge       = "x1";        // which wall the SMA exits (short end)
ant_pos        = board_y/2;   // position along that edge
ant_z          = 3;           // height of hole center above PCB top

/* [OLED window] */
// V4 has a 0.96" OLED on TOP under a plastic bracket. Toggle a lid window.
oled_window    = true;        // true = cutout to see screen; false = solid lid
// OLED active-area footprint & position on the PCB (from PCB origin). VERIFY.
oled_w         = 26;          // window width  (X)
oled_h         = 15;          // window height (Y)
oled_cx        = 33;          // window center X on the board
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

hx0 = clr + hole_inset_x;
hx1 = clr + board_x - hole_inset_x;
hy0 = clr + hole_inset_y;
hy1 = clr + board_y - hole_inset_y;
holes = [[hx0,hy0],[hx1,hy0],[hx0,hy1],[hx1,hy1]];

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
        port_cut_long(front_edge, usbc_x, usbc_w, usbc_h, usbc_z);
        if(usrbtn_x>0) hole_cut_long(front_edge, usrbtn_x, btn_d, usbc_z+usbc_h/2);
        if(rstbtn_x>0) hole_cut_long(front_edge, rstbtn_x, btn_d, usbc_z+usbc_h/2);
        if(ant_mode=="sma") hole_cut_short(ant_edge, ant_pos, ant_d, ant_z);
        pigtail_cut();
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
