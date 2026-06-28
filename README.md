# Heltec WiFi LoRa 32 (V4) Case Generator

A parametric OpenSCAD enclosure for the **Heltec WiFi LoRa 32 V4** (ESP32-S3 + SX1262, with an on-board OLED). Same two-part snap+screw architecture as the [WisBlock case](https://github.com/magikh0e/wisblock-case-generator), but laid out for the V4's board size and its connector row.

**Source / latest version:** https://github.com/magikh0e/heltec-v4-case-generator

> Dimensions come from the published V4 product manual and the geometry is verified manifold, but port offsets vary and tolerances differ by printer. The connector row is the high-risk area, so always run the fit-checker (section 5) before a full print.

---

## How the V4 differs from the WisBlock case

If you've used the WisBlock generator, the structure is identical. Only the board-specific bits changed:

- **Smaller board:** 51.7 x 25.4 mm (vs 60 x 30).
- **Connector row on one LONG edge:** the V4 puts the USER button, USB-C, and RST button in a row along the same long side. The generator cuts them at individual X positions on that edge (`front_edge`, default `y0`).
- **OLED window:** the V4 has a 0.96" display on top. The lid has an optional cutout (`oled_window`) with a recessed ledge for a clear cover.
- **LoRa antenna:** IPEX1.0 on board. Default is an **SMA bulkhead hole** (`ant_mode="sma"`) so you run a u.FL to SMA pigtail out to a real antenna for best range. Switch to `ant_mode="internal"` for no hole (keep the antenna inside).
- **M2 mounting** (the V4 uses M2, vs M2.5 on the WisBlock).

---

## 1. What you need

- **OpenSCAD**: https://openscad.org
- The file **`Heltecv4_Case_Generator.scad`**.
- A slicer (PrusaSlicer, Orca, Cura, Bambu Studio...).
- **Calipers**: more important here than on the WisBlock, because the connector X positions are the make-or-break dimension (see section 5).

This repo ships the generator plus pre-exported, ready-to-slice STLs: `heltec_v4_base.stl`, `heltec_v4_lid_snap.stl`, `heltec_v4_lid_screw.stl`, `heltec_v4_both_lids.stl`, and the clear `heltec_v4_oled_cover.stl` (print that one in transparent filament). The STLs are built from the default variables; if you change board-specific dimensions, re-export from the `.scad` (section 4) so the parts match.

---

## 2. Opening and previewing

1. Open `Heltecv4_Case_Generator.scad` in OpenSCAD.
2. **F5** = fast preview, **F6** = full render.
3. Enable the **Customizer** (Window menu) for labelled sliders and toggles grouped under `[Board]`, `[Connector row]`, `[OLED window]`, etc.
4. Export with **File -> Export -> Export as STL** (`F7`).

---

## 3. Choosing what to render

```
part = "both";
```

| Value | Renders |
|---|---|
| `"base"` | Base tray only |
| `"lid"` | Lid following `use_snaps` / `use_screws` |
| `"lid_snap"` | Lid, snaps only |
| `"lid_screw"` | Lid, screw holes only |
| `"all_lids"` | Both lids side by side on one plate |
| `"oled_cover"` | Printable clear window cover (print in transparent filament) |
| `"both"` | Base + lid exploded. **Preview only, don't print this** |

The **base is shared** by both lids (it has snap recesses *and* screw posts). Print one base, then whichever lid you want.

---

## 4. Print workflow

1. `part = "base";` -> F6 -> export base.
2. `part = "lid_snap";` (or `lid_screw`) -> F6 -> export lid.
3. Slice both. Base flat / open side up, lid lip-up, no supports needed (the snap chamfers stay under ~45 degrees). The OLED window prints fine face-up.
4. Assemble (section 8).

---

## 5. Verify before printing — the connector row

This is the critical step for the V4. The board size is exact, but the **X positions of the USB-C and buttons along the front edge** must match your board or the ports won't line up. Measure from the left end of the PCB to the center of each feature and set:

```
usbc_x    = 14;   // USB-C center
usrbtn_x  = 6;    // USER button center (0 disables)
rstbtn_x  = 22;   // RST button center  (0 disables)
```

Also confirm:
- `front_edge` (`y0` or `y1`): which long side the row faces. If your board sits flipped, set `y1`.
- `oled_cx` / `oled_cy`: the OLED window center, if you've enabled it.
- `usbc_w` / `usbc_h`: widen for a chunky cable overmold.

**Fit-checker trick:** set `comp_clear = 1;` and print just the base. You get a shallow tray that confirms the board footprint, USB-C, and button alignment in about 15 minutes of filament. Adjust the X values, reprint if needed, then set `comp_clear` back to 12 for the real thing.

---

## 6. Variable reference

### `[Board]`
| Variable | Default | Meaning |
|---|---|---|
| `board_x`, `board_y` | 51.7, 25.4 | V4 PCB footprint (mm). |
| `standoff_h` | 4 | PCB lift off the floor. |
| `screw_hole_d` | 1.8 | M2 self-tap pilot. |
| `post_d` | 4.5 | Standoff post OD. |
| `hole_inset_x/y` | 2.5 | Mounting-hole inset. Verify. |

### `[Clearances]`
| Variable | Default | Meaning |
|---|---|---|
| `wall`, `floor_t`, `lid_t` | 2.0 | Thicknesses. |
| `clr` | 0.4 | Gap around PCB. |
| `comp_clear` | 12 | Headroom above PCB (the OLED bracket is the tall part). |

### `[Connector row]`
| Variable | Default | Meaning |
|---|---|---|
| `front_edge` | `"y0"` | Which long edge the row faces. |
| `usbc_x` | 14 | USB-C center X. **Verify**. |
| `usbc_w`, `usbc_h` | 9.5, 4.0 | USB-C opening size. |
| `usbc_z` | 1.0 | Port bottom above PCB surface. |
| `usrbtn_x` | 6 | USER button X (0 = off). |
| `rstbtn_x` | 22 | RST button X (0 = off). |
| `btn_d` | 3.5 | Button pin-poke hole diameter. |

### `[LoRa antenna]`
| Variable | Default | Meaning |
|---|---|---|
| `ant_mode` | `"sma"` | `"sma"` = bulkhead hole; `"internal"` = no hole. |
| `ant_d` | 6.5 | SMA nut hole diameter. |
| `ant_edge` | `"x1"` | Which short wall the SMA exits. |
| `ant_pos` | board_y/2 | Position along that wall. |
| `ant_z` | 3 | Hole-center height above PCB. |

> Note: for the SMA pigtail to work you may need to move the V4's RF-path resistor to the IPEX side per Heltec's hardware notes. Check the board docs before relying on the external antenna.

### `[OLED window]`
| Variable | Default | Meaning |
|---|---|---|
| `oled_window` | true | true = cutout; false = solid lid. |
| `oled_w`, `oled_h` | 26, 15 | Window size. Verify against your screen. |
| `oled_cx`, `oled_cy` | 33, center | Window center on the board. |
| `oled_recess` | true | Recessed ledge for a clear cover. |
| `oled_ledge` | 1.5 | Ledge width the cover rests on. |
| `oled_cover_t` | 1.0 | Recess depth (match your acrylic thickness). |
| `oled_cover_gap` | 0.3 | Fit clearance for the printed cover to drop in. |

A clear cover is optional. Two ways to make one:
- **Print it:** set `part = "oled_cover";` and print in transparent PETG or clear PLA (or use the bundled `heltec_v4_oled_cover.stl`). It's sized to drop straight into the recess (footprint minus `oled_cover_gap`).
- **Cut it:** a 1 mm acrylic / polycarbonate rectangle at `oled_w + 2*oled_ledge` x `oled_h + 2*oled_ledge` (about 28.7 x 17.7 mm at defaults).

Or just leave the window open for a bare cutout.

### `[Lid fit]`
| Variable | Default | Meaning |
|---|---|---|
| `use_screws` | true | M2 holes into the corner posts. |
| `use_snaps` | true | Cantilever snaps on the long walls. |

Both on by default (snaps hold it shut, screws clamp for weather sealing).

### `[Snap-fit]`
Same as the WisBlock: `snap_depth` (0.9) is the click strength. Lower for easier opening, higher for a firmer lock. Keep `snap_relief = true` for PLA/PETG.

### `[Lanyard]`, `[Battery shelf]`, `[JST pigtail exit]`
- Lanyard tab defaults to the `x1` short end. **If your SMA is also on `x1`, move one of them** (`lanyard_edge` or `ant_edge`) so they don't overlap.
- Battery shelf off by default; enable and size it for your LiPo.
- Pigtail slot (`pigtail_slot`) lets the SH1.25 battery / solar leads exit; set `pigtail_x` along the front edge.

---

## 7. Quick recipes

**Headless node, no screen:** `oled_window = false;`

**Keep antenna internal:** `ant_mode = "internal";`

**Board mounted the other way round:** `front_edge = "y1";` (and move the OLED / pigtail edges to match).

**Tighter fit:** `clr = 0.3;`. Won't seat: `clr = 0.5;`.

**Big battery in the lid space:** enable `battery`, set `bat_x` / `bat_y`, and raise `comp_clear` if it's thick.

---

## 8. Assembly

1. Seat the V4 on the four standoffs (M2 corners).
2. **SMA build:** mount the u.FL to SMA pigtail's bulkhead through the antenna hole, tighten the nut, then clip the u.FL onto the board's IPEX1.0 connector. **Internal build:** just leave the IPEX antenna inside.
3. If using a battery, route its SH1.25 lead out through the pigtail slot.
4. Optional: drop a clear cover into the OLED recess (print `part="oled_cover"` in transparent filament, use the bundled STL, or cut acrylic to size). A dab of clear glue holds it.
5. Close the lid: snap it shut, then drive four **M2 x 6 to 8 mm** self-tapping screws into the posts (or use M2 heat-set inserts + machine screws if you'll open it often).

---

## 9. Material notes (outdoor / hot climates)

- **PLA**: easiest, but softens in heat and sun, so the snaps relax over time. Indoor / bench only.
- **PETG**: best all-round here; flexes for repeated snaps, better heat and UV tolerance.
- **ASA**: best for sustained outdoor sun.

For a sealed outdoor node, use the screw lid (optionally with a gasket) and PETG or ASA.

---

## 10. Disclaimer

Dimensions come from the published V4 product manual and the geometry is verified manifold, but **port offsets vary and tolerances differ by printer**. The connector row is the high-risk area: always run the fit-checker (section 5) before a full print.
