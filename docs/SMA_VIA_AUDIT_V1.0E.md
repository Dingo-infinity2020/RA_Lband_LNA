# SMA solder-land via audit — V1.0E

Date: 2026-09-12

## Trigger

JLC's 3D preview showed one visible plated hole at the inner/top edge of each lower SMA ground solder land.

## Root cause

The V1.0D plated-drill file contained two 0.35 mm GND stitching vias at:

- J1 side: `(x, y) = (3.700, 7.550) mm`
- J2 side: `(x, y) = (22.700, 7.550) mm`

Using the locked `CON-SMA-EDGE-S` footprint, the lower ground lands are:

- J1: `x = 0..3.810 mm`, `y = 4.850..7.550 mm`
- J2: `x = 22.190..26.000 mm`, `y = 4.850..7.550 mm`

Therefore these two vias lie exactly on the exposed solder-land boundary. They are electrically valid GND vias, but leaving open plated holes in a wetted SMA ground land is unnecessary and may promote solder wicking / make hand or wave soldering less predictable.

## V1.0E correction

V1.0E removes only those two drill hits from the plated-drill file. The surrounding ground-via fence and the dedicated J1 upper-land plane-transfer via remain unchanged. No RF signal copper or component placement changes are made.

Automated footprint-vs-drill audit after the change: **zero plated drill centers intersect any of the six exposed SMA solder lands** (J1/J2 signal, upper ground, lower ground).

## Manufacturing status

V1.0E supersedes V1.0D for first fabrication. Re-upload the V1.0E Gerber ZIP to JLC and confirm that the two black holes previously visible in the SMA ground solder lands disappear in 3D view.
