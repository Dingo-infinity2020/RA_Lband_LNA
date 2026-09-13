# Next action — CST G2 replay-safe build-only validation

Date: 2026-09-13
Reviewer decision: **G1 accepted. Authorize G2 BUILD-ONLY only. G3–G4 and all solvers remain HOLD.**

## Review decision on G1

Run `reports/cst_build_only/G1/20260913_140307/` is accepted as:

`FINAL_STATUS=CST_G1_REPLAY_SAFE_BUILD_ONLY_PASS`

The evidence is sufficient to prove that the flat Structure-Macro pattern is replay-safe not only for geometry and discrete ports, but also for the first `LumpedElement`:

- exact authoritative macro used with no local edits;
- 31 brick solids, 7 via cylinders, 1 lumped element and 2 ports before save;
- `C1_100pF` survives reopen #1 and reopen #2;
- both ports survive reopen #1 and reopen #2;
- the 16-step input taper exists and the C1 copper gap remains open;
- no history-replay error;
- no solver, sweep, optimizer or mesh adaptation was run.

G1 therefore closes the persistence blocker for the basic lumped-element pattern.

G2 is the next checkpoint because it substantially increases topology complexity: output SMA launch, long RF line, via fence, C2, 18 nH bias choke, three local decouplers, R3 link, C8 bulk decoupler and VIN/J3 geometry.

---

## Authoritative G2 macro

Use exactly:

`source/cst/G2_REPLAY_SAFE_STRUCTURE_V2.bas`

Introducing commit:

`9d45e8165d754b84a23969694c8cb3f55b03e046`

This is a flattened Structure Macro derived from the original G2 build-only topology. It contains no helper procedures, loops, completion dialogs, project-creation command or solve-start command.

Expected nominal object counts after a successful build:

- Brick solids: **58**
- Cylindrical vias: **24**
- Lumped elements: **7**
- Discrete ports: **2**
- Frequency range: **0.5–3.0 GHz**

Expected lumped elements:

- `L1_18nH`
- `C5_CAP`
- `C3_CAP`
- `C4_CAP`
- `R3_0R`
- `C8_10uF`
- `C2_100pF`

Expected key geometry:

- `J2_SIG`
- `J2_TAPER_0` … `J2_TAPER_15`
- `J2_GND_LO`, `J2_GND_HI`
- `J2_V1` … `J2_V4`
- `U1_PIN7_PAD`
- `L1_STUB_H`, `L1_STUB_V`, `L1_PAD_RF`, `L1_PAD_VDD`
- `VDD_BUS`
- C5/C3/C4 pads and ground vias
- R3 pads
- VIN bus and `J3_5V`
- C8 pads/stubs and `C8_GND_VIA`
- `J3_GND`, `J3_GND_V1`, `J3_GND_V2`
- `U1_EP`, `U1_EP_A`, `U1_EP_B`
- `RF_OUT_PRE_C2`
- `C2_PAD1`, `C2_PAD2`
- `RF_OUT_LINE`
- `GF_L1` … `GF_L7`
- `GF_U1` … `GF_U5`
- `port1`, `port2`

---

## Exact G2 procedure

### Absolute rules

- BUILD ONLY.
- DO NOT run any solver.
- DO NOT run mesh adaptation, optimizer, parameter sweep, transient solver, frequency-domain solver or any other solve command.
- DO NOT edit V1.0F PCB/Gerber/BOM/CPL.
- DO NOT locally modify the authoritative G2 macro. If it fails, capture the failure and stop.
- DO NOT proceed to G3 after this task even if G2 passes.

### Run

1. Pull latest `main`.
2. Create a **fresh empty Microwave Studio project through the GUI**.
3. Create a new **Structure Macro** using `Macros -> Make VBA Macro`.
4. Paste the exact contents of `source/cst/G2_REPLAY_SAFE_STRUCTURE_V2.bas`.
5. Save the macro and run it through `Macros -> Run Macro`.
6. Do not use the ordinary VBA-editor execution path.

### Pre-save checks

Verify all of the following before saving:

- 58 brick solids;
- 24 via cylinders;
- 7 lumped elements with the exact names listed above;
- `port1` and `port2` exist;
- all 16 `J2_TAPER_*` bricks exist and widen monotonically toward the SMA signal land;
- the output RF line is continuous from the C2 output side into the right-launch taper region;
- `C2_PAD1` and `C2_PAD2` retain the intended 0.30 mm copper gap, bridged only by `C2_100pF`;
- `L1_PAD_RF` and `L1_PAD_VDD` retain the intended gap, bridged only by `L1_18nH`;
- `R3_PAD1` and `R3_PAD2` retain the intended gap, bridged only by `R3_0R`;
- C5/C3/C4 each connect VDD_LOCAL to their own ground branch through a lumped capacitor, not through a copper short;
- C8 VIN/GND pads remain separated and bridged only by `C8_10uF`;
- the twelve `GF_*` ground-fence vias exist;
- U1 EP and both 0.30 mm EP vias exist;
- the old deleted SMA solder-land boundary drill hits are not reintroduced;
- frequency range is 0.5–3.0 GHz;
- no solver results exist.

Save as a NEW file, for example:

`RA_LNA_G2_OUTPUT_REPLAYSAFE_V2.cst`

Record file size and SHA256.

### Reopen-integrity checks

Close the project completely, then reopen the saved file twice.

After **reopen #1** verify:

- no `Processing history information` error;
- 58 brick solids remain;
- 24 vias remain;
- all seven lumped elements remain;
- both ports remain;
- materials and frequency range remain;
- history is present and replayable.

Close without mutation and perform **reopen #2**. Repeat at minimum:

- all seven lumped elements present;
- 2 ports present;
- geometry tree present;
- no history error.

The second reopen is mandatory.

---

## Required screenshots/evidence

Create:

`reports/cst_build_only/G2/<new_run_id>/`

Include at minimum:

- `REPORT.md`
- `BUILD_LOG.txt`
- `MACRO_USED.bas`
- `STATUS.json`
- `SCREENSHOT_01_BUILT_OVERVIEW.png`
- `SCREENSHOT_02_OUTPUT_LAUNCH_CLOSEUP.png`
- `SCREENSHOT_03_C2_AND_U1_PIN7.png`
- `SCREENSHOT_04_BIAS_NETWORK_LUMPED_TREE.png`
- `SCREENSHOT_05_VIA_FENCE_AND_RIGHT_LAUNCH.png`
- `SCREENSHOT_06_HISTORY_BEFORE_SAVE.png`
- `SCREENSHOT_07_REOPEN1_TREE_PORTS_LUMPED.png`
- `SCREENSHOT_08_REOPEN1_HISTORY_NO_ERROR.png`
- `SCREENSHOT_09_REOPEN2_TREE_PORTS_LUMPED.png`

If any macro/API/history error occurs, capture it exactly and stop.

### REPORT.md must explicitly state

- exact macro source path and introducing commit SHA;
- whether any local edit occurred;
- brick/via/lumped/port counts before save;
- list of all seven lumped-element names before save;
- lumped-element count after reopen #1 and #2;
- port count after reopen #1 and #2;
- whether all 16 right-launch taper bricks exist;
- whether C2, L1, R3 and C8 gaps are visually present and not copper-shorted;
- whether all 12 `GF_*` vias exist;
- CST file size and SHA256;
- `Model.mod` size if inspected;
- `SOLVER_RUN=NO`.

### PASS condition

Use:

`FINAL_STATUS=CST_G2_REPLAY_SAFE_BUILD_ONLY_PASS`

only if all are true:

- build succeeds with the expected topology;
- all seven lumped elements exist before save and after both reopen cycles;
- both ports exist before save and after both reopen cycles;
- no history replay error occurs;
- output launch, C2, long line, via fence and bias-network geometry visually match intent;
- no unintended copper short is found across C2/L1/R3/C8 component gaps;
- no solver/sweep/optimizer/mesh adaptation was run.

Otherwise use:

`FINAL_STATUS=CST_G2_REPLAY_SAFE_BUILD_ONLY_HOLD`

and stop.

---

## Modeling note

The C3/C5/C4/C8 values in this gate are still idealized lumped screening models. In particular, the 1 uF and 10 uF capacitors are not intended to be trusted as ideal RF capacitors at GHz frequencies. This does **not** block the build-only persistence gate. Their RF parasitics will be treated in the later bias-network simulation stage before any physical-design conclusion is drawn.

## After G2

Do not run G3–G4 automatically.

If G2 passes, the reviewer will next convert/authorize G3, which is the dedicated bias-network topology and resonance-screening gate. Solver authorization remains separate and will not be granted merely because G2 build-only passes.

## Project state

- PCB baseline: **RA-LNA-L1 V1.0F**
- PCB geometry: **frozen**
- Fabrication: **HOLD**
- CST G0: **PASS**
- CST G1: **PASS — replay-safe lumped element + ports verified**
- CST G2: **AUTHORIZED FOR BUILD-ONLY VALIDATION**
- CST G3–G4: **HOLD**
- Solver authorization: **NO**
