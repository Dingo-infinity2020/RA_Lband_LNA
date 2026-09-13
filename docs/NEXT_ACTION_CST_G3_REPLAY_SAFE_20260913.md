# Next action — CST G3 replay-safe build-only validation

Date: 2026-09-13
Reviewer decision: **G2 accepted. Authorize G3 BUILD-ONLY only. G4 and all solvers remain HOLD.**

## Review decision on G2

Run `reports/cst_build_only/G2/20260913_142924/` is accepted as:

`FINAL_STATUS=CST_G2_REPLAY_SAFE_BUILD_ONLY_PASS`

The evidence is sufficient:

- authoritative macro used without local edits;
- expected pre-save topology: 58 bricks / 24 vias / 7 lumped elements / 2 ports;
- all 7 lumped elements and both ports survive two complete close/reopen cycles;
- all 16 J2 taper steps and 12 GF_* vias are present;
- C2/L1/R3/C8 copper gaps are preserved and not shorted by copper;
- no history replay error;
- solver/sweep/optimizer/mesh adaptation were not run.

The one rejected first Save-As attempt caused by the keyboard/IME path entry is an operational GUI event only and does not affect acceptance.

G3 is the focused bias-network topology checkpoint. It intentionally removes the output launch/C2 path and places the two S-parameter ports directly at the RF_OUT_VDD node and the VIN5/J3 node. This is the model that will later be used for the bias-isolation/resonance solver gate, but **this run is still BUILD ONLY**.

---

## Authoritative G3 macro

Use exactly:

`source/cst/G3_REPLAY_SAFE_STRUCTURE_V2.bas`

Introducing commit:

`7a9ec7414c1df88e4f4d058ac5a401e0a8a3edc7`

This is a flattened Structure Macro derived from the original G3 bias-network topology. It contains no helper procedures, loops, project-creation commands, completion dialogs, or solve-start commands.

Expected nominal object counts:

- Brick solids: **38**
- Cylindrical vias: **6**
- Lumped elements: **7**
- Discrete ports: **2**
- Frequency range: **0.5–3.0 GHz**

Expected lumped elements:

1. `L1_18nH`
2. `C5_CAP`
3. `C3_CAP`
4. `C4_CAP`
5. `R3_0R`
6. `C8_10uF`
7. `R4_3k32`

Expected vias:

- `C5_GND_VIA`
- `C3_GND_VIA`
- `C4_GND_VIA`
- `C8_GND_VIA`
- `J3_GND_V1`
- `J3_GND_V2`

Expected ports:

- `port1`: RF_OUT_VDD / U1 Pin-7 reference at approximately (7.90, 9)
- `port2`: VIN5 / J3 +5 V reference at approximately (17.0, 15.1)

---

## Exact G3 procedure

### Absolute rules

- BUILD ONLY.
- DO NOT run any solver.
- DO NOT run mesh adaptation, parameter sweep, optimizer, time-domain or frequency-domain simulation.
- DO NOT edit V1.0F Gerber/BOM/CPL/PCB geometry.
- DO NOT locally modify `G3_REPLAY_SAFE_STRUCTURE_V2.bas`.
- If the macro/API/history replay fails, capture the exact failure and stop.
- DO NOT proceed to G4 after this task, even if G3 passes.

### Run

1. Pull latest `main`.
2. Create a fresh empty Microwave Studio project via the GUI.
3. Create a new **Structure Macro** via `Macros -> Make VBA Macro`.
4. Paste the exact contents of `source/cst/G3_REPLAY_SAFE_STRUCTURE_V2.bas`.
5. Save the macro and execute it via `Macros -> Run Macro`.
6. Do not execute through the ordinary VBA editor run path.

### Pre-save checks

Verify all of the following:

- exactly 38 brick solids;
- exactly 6 via cylinders;
- exactly 7 lumped elements with the names listed above;
- exactly 2 discrete ports;
- `FR4_RA_LNA`, PEC and Vacuum exist;
- L1 RF/VDD pad gap remains open and is bridged only by `L1_18nH`;
- C5/C3/C4 VDD/GND pad gaps remain open and are bridged only by their lumped capacitors;
- R3 pad gap remains open and is bridged only by `R3_0R`;
- C8 VIN/GND pad gap remains open and is bridged only by `C8_10uF`;
- R4 lower/upper pad gap remains open and is bridged only by `R4_3k32`;
- `U1_PIN1_PAD -> R4_STUB -> R4_PAD_LO` is visibly connected;
- `R4_PAD_HI` overlaps/connects the VDD_LOCAL bus as intended;
- VIN_H/VIN_V/J3_5V are continuous;
- `J3_GND` and both J3 ground vias exist;
- frequency range is 0.5–3.0 GHz;
- there are no solver results.

Save as a NEW file, for example:

`RA_LNA_G3_BIAS_REPLAYSAFE_V2.cst`

Record file size and SHA256.

### Reopen-integrity checks

Close the project fully and reopen the saved file twice.

After reopen #1 verify:

- no `Processing history information` error;
- 38 bricks remain;
- 6 vias remain;
- all 7 lumped elements remain;
- both ports remain;
- materials and 0.5–3.0 GHz range remain;
- the Structure-Macro history block is present and replayable.

Close without mutation and perform reopen #2. Repeat at minimum:

- all 7 lumped elements present;
- both ports present;
- geometry tree present;
- no history error.

---

## Required evidence package

Create:

`reports/cst_build_only/G3/<new_run_id>/`

Include at minimum:

- `REPORT.md`
- `BUILD_LOG.txt`
- `MACRO_USED.bas`
- `STATUS.json`
- `SCREENSHOT_01_BUILT_OVERVIEW.png`
- `SCREENSHOT_02_RF_OUT_L1_CLOSEUP.png`
- `SCREENSHOT_03_DECOUPLING_AND_R3.png`
- `SCREENSHOT_04_C8_VIN_J3_CLOSEUP.png`
- `SCREENSHOT_05_R4_BRANCH_CLOSEUP.png`
- `SCREENSHOT_06_LUMPED_PORTS_TREE.png`
- `SCREENSHOT_07_HISTORY_BEFORE_SAVE.png`
- `SCREENSHOT_08_REOPEN1_TREE_PORTS_LUMPED.png`
- `SCREENSHOT_09_REOPEN1_HISTORY_NO_ERROR.png`
- `SCREENSHOT_10_REOPEN2_TREE_PORTS_LUMPED.png`

If convenient, also include a Vias-tree screenshot proving all six vias.

### REPORT.md must explicitly state

- exact macro source path and introducing commit SHA;
- whether any local edit occurred;
- brick/via/lumped/port counts before save;
- names of all 7 lumped elements;
- lumped count after reopen #1 and #2;
- port count after reopen #1 and #2;
- status of the L1, C5, C3, C4, R3, C8 and R4 copper gaps;
- whether the R4 branch is visibly connected to U1 Pin-1 side and VDD_LOCAL side;
- CST file size and SHA256;
- `Model.mod` size and native-command counts if inspected;
- `SOLVER_RUN=NO`.

### PASS condition

Use:

`FINAL_STATUS=CST_G3_REPLAY_SAFE_BUILD_ONLY_PASS`

only if all are true:

- build succeeds with 38 bricks / 6 vias / 7 lumped / 2 ports;
- all intended copper gaps are present with no unintended short;
- R4 branch topology is correct;
- all 7 lumped elements and both ports survive both reopen cycles;
- no history replay error occurs;
- no solver/sweep/optimizer/mesh adaptation was run.

Otherwise use:

`FINAL_STATUS=CST_G3_REPLAY_SAFE_BUILD_ONLY_HOLD`

and stop.

---

## Modeling note

G3 still uses idealized/simple lumped screening values. In particular, the 1 uF and 10 uF capacitors are **not** considered physically accurate at GHz frequencies. That is acceptable for this build-only persistence/topology gate.

Do not interpret a G3 build-only PASS as an RF-performance PASS.

The later G3 solver stage will require a separate reviewer decision on whether to replace C3/C4/C5/C8 with parasitic-aware RLC or vendor S-parameter models before trusting GHz isolation/resonance results.

## After G3

Do not run G4 automatically.

If G3 passes, the next reviewer action will be to create/authorize the replay-safe G4 full-board build-only model. Only after G0–G4 are all persistent and visually accepted will solver authorization be considered.

## Project state

- PCB baseline: **RA-LNA-L1 V1.0F**
- PCB geometry: **frozen**
- Fabrication: **HOLD**
- CST G0: **PASS**
- CST G1: **PASS**
- CST G2: **PASS**
- CST G3: **AUTHORIZED FOR BUILD-ONLY VALIDATION**
- CST G4: **HOLD**
- Solver authorization: **NO**
