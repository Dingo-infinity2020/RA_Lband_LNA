# RA-LNA-L1 V1.0F pre-fabrication simulation gate plan

## Status

V1.0F PCB geometry is visually frozen after the JLC 3-D review. Fabrication is temporarily **on hold** until the focused pre-fabrication EM gates below are built and reviewed.

This is a risk-reduction step, not an attempt to replace first-article VNA/NF measurements.

## Gate sequence

1. **G0 — CST VBA/API preflight**  
   Minimal stack-up + microstrip + two discrete ports. Purpose: prove the build-only macro syntax on the user's CST Studio Suite 2022 installation before touching the RF gates.

2. **G1 — input launch**  
   PCB-side left SMA land/taper + C1 + trace to the QPL9547 Pin-2 reference plane. First-pass screen: insertion loss < 0.12 dB and return loss > 15 dB over 1.05–1.55 GHz.

3. **G2 — output path**  
   QPL9547 Pin-7 reference plane + nominal bias loading + C2 + long output microstrip + right PCB-side SMA launch. First-pass screen: insertion loss < 0.18 dB, return loss > 15 dB, and no sharp resonance in 0.5–3 GHz.

4. **G3 — bias network**  
   18 nH choke + decoupling network + VIN/J3 network. Inspect RF-node impedance and RF-to-VIN leakage. Initial target: RF-to-VIN S21 < -20 dB; investigate any peak > -15 dB. Bias branch magnitude should remain >100 ohm in-band; flag collapse below 80 ohm.

5. **G4 — full-board passive coupling**  
   Passive four-port whole-board screen with the active QPL9547 removed. Purpose: expose direct input/output EM feedback paths. Initial target: direct input-to-output coupling < -40 dB; investigate > -30 dB.

## Modeling policy

- Build-only first. No solver, parameter sweep, optimizer or automatic SaveAs in the macros.
- Frequency-domain solver is recommended only after each built model is visually accepted.
- Initial EM range: 0.5–3 GHz.
- Baseline stack: JLC04161H-3313 (L1 35 um / 3313 0.0994 mm / L2 15.2 um / core 1.265 mm / L3 15.2 um / 3313 0.0994 mm / L4 35 um).
- The RF Solutions CON-SMA-EDGE-S model is a **PCB-side launch surrogate**. Vendor 3-D connector CAD is not invented.
- Passives are represented by ideal lumped R/L/C elements between their real PCB pad edges in the first screening models.
- No soldermask is modeled in v0.1.
- QPL9547 is not present as an active device in G4; G4 is explicitly a passive coupling screen.

## Tolerance cases after nominal build passes

At minimum rebuild nominal models for:

- er = 3.8 / 4.1 / 4.4;
- L1-to-L2 dielectric thickness = -10% / nominal / +10%;
- RF trace width = 0.145 / 0.1565 / 0.170 mm.

Do not start an automated parameter sweep until a nominal model builds, meshes and solves cleanly.

## Release handling

The build-only macro package is being validated locally against CST Studio Suite 2022. Until G0 is confirmed on the actual CST machine, the macros are treated as a pre-release simulation aid rather than fabrication authority. V1.0F Gerber remains the frozen PCB geometry, but fabrication stays on hold until the EM gate review is complete.
