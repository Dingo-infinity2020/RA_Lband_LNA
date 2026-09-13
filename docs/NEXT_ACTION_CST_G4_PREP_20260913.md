# Next action — CST G4 replay-safe macro preparation

Date: 2026-09-13
Reviewer decision: **G3 accepted. Authorize G4 source preparation/static audit only. Do not run CST G4 yet. All solvers remain HOLD.**

## Review decision on G3

Accepted run:

`reports/cst_build_only/G3/20260913_150740/`

Accepted status:

`FINAL_STATUS=CST_G3_REPLAY_SAFE_BUILD_ONLY_PASS`

The evidence is sufficient: 38 bricks / 6 vias / 7 lumped elements / 2 ports were present before save; all seven lumped elements and both ports survived two clean close/reopen cycles; the required L1/C5/C3/C4/R3/C8/R4 copper gaps and R4 branch topology were preserved; no history replay error occurred; no solver/sweep/optimizer/mesh adaptation ran.

## Why G4 is not run immediately

No authoritative replay-safe G4 macro exists on `main` yet. G4 is the final BUILD-ONLY topology gate and must not be improvised interactively.

The repository gate plan defines G4 as a **passive four-port full-board direct input/output coupling screen with the active QPL9547 removed**. Its later solver purpose is to expose EM feedback that bypasses the active device. Solver targets remain provisional until a separate authorization:

- desired direct input-to-output coupling: < -40 dB;
- investigate any region > -30 dB.

This task only prepares the model source. It does not solve it.

## G4 physical/port contract

Build a flattened CST Structure Macro using the already accepted replay-safe contracts as the only geometry source:

- input chain from `source/cst/G1_REPLAY_SAFE_STRUCTURE_V2.bas`;
- output path + C2 + output launch + nominal output-bias loading from `source/cst/G2_REPLAY_SAFE_STRUCTURE_V2.bas`;
- R4 / VBIAS branch from `source/cst/G3_REPLAY_SAFE_STRUCTURE_V2.bas`;
- V1.0F remains the frozen PCB authority; V1.0F is copper-identical to V1.0E and differs only by silkscreen cleanup.

The active QPL9547 device body/model is **absent**. Do not create a conductive or circuit connection between U1 Pin-2 and U1 Pin-7.

Use four 50-ohm discrete S-parameter ports:

1. `port1` — left/J1 external RF reference, accepted G1 coordinate approximately `(0.25, 9)`;
2. `port2` — U1 Pin-2 input reference, accepted G1 coordinate approximately `(6.50, 9)`;
3. `port3` — U1 Pin-7 output/RF_OUT_VDD reference, accepted G2/G3 coordinate approximately `(7.90, 9)`;
4. `port4` — right/J2 external RF reference, accepted G2 coordinate approximately `(25.75, 9)`.

The future direct-coupling observable is therefore primarily `S41`/`S14` (J1 external <-> J2 external), with the internal Pin-2/Pin-7 ports retained for de-embedding/diagnostic interpretation.

## Composition rules

Create:

`source/cst/G4_REPLAY_SAFE_STRUCTURE_V2.bas`

Rules:

- flattened Structure Macro only;
- `Sub Main` contains native CST commands only;
- no helper procedures/functions;
- no loops;
- no `NewMWS` or project-creation command;
- no `MsgBox` or completion dialog;
- no `SaveAs`;
- no solver-start command;
- no optimizer/sweep/mesh-adaptation command;
- frequency range remains 0.5--3.0 GHz;
- preserve the accepted stack parameters/material definitions from G1/G2/G3;
- preserve accepted passive lumped values and copper-gap implementation;
- do not duplicate overlapping U1 EP/ground structures when combining source blocks;
- do not create duplicate solids/vias with the same physical role;
- include C1 and C2 as accepted lumped 100 pF series elements;
- include the accepted output-bias branch elements from G2;
- include `R4_3k32` and its accepted G3 copper branch;
- do not invent a QPL9547 active model, package lead network, vendor connector CAD, soldermask, or new parasitic component values.

R2/SHDN is not yet part of an accepted CST gate geometry. **Do not invent it in G4-PREP.** Record its omission explicitly as a modeling limitation for the first passive-coupling screen.

## Required static audit before any CST execution

Before asking the user to run G4, produce a static report proving at minimum:

- the new macro contains exactly one `Sub Main` and no other procedures/functions;
- no prohibited project-creation/solve/sweep/optimizer/mesh-adaptation/SaveAs token is present;
- four `With DiscretePort` blocks exist with port numbers 1--4 and the coordinates above;
- Pin-2 and Pin-7 are not connected by any brick/lumped element;
- C1 and C2 gaps remain open and are bridged only by their lumped capacitors;
- L1/C5/C3/C4/R3/C8/R4 gaps remain open and are bridged only by their accepted lumped elements;
- J1/J2 taper and ground/via structures are retained from accepted G1/G2;
- no duplicated U1 EP/via primitives are emitted;
- 0.5--3.0 GHz is retained;
- source provenance records the exact current blob/commit identities of G1/G2/G3.

Do not guess final brick/via counts until the union/deduplication is actually generated and audited. The static report must state the resulting counts and list any deliberate deduplication.

## Deliverables

Commit only lightweight source/docs, preferably:

- `source/cst/G4_REPLAY_SAFE_STRUCTURE_V2.bas`
- `docs/G4_REPLAY_SAFE_SOURCE_AUDIT_20260913.md`
- optional machine-readable static audit under `reports/cst_build_only/G4_preflight/`

Update `README.md` only to say G3 PASS and G4 macro-preparation/source-audit pending or complete. Do **not** claim G4 BUILD-ONLY PASS until the user has run the macro in CST, saved it, and completed two clean reopen cycles.

## Stop condition

After source generation/static audit and push, stop and report:

- G4 macro commit SHA;
- resulting brick/via/lumped/port counts from static parsing;
- exact four port coordinates;
- list of deduplicated primitives;
- confirmation `SOLVER_RUN=NO` and `CST_G4_EXECUTED=NO`.

Do not run G4 in CST automatically. Do not start any solver.
