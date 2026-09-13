# G0 Build-Only Report

Run ID: `20260913_105328` (first pass, original G0 build)

## Status
FINAL_STATUS=FAIL
BUILD_ONLY_CONFIRMED=YES
SOLVER_RUN=NO

> The G0 geometry/materials/ports build itself completed cleanly and was visually inspected,
> and no solver was ever started. FINAL_STATUS is **FAIL** because the saved project does not
> retain its ports when reopened: macros executed from the VBA Macro Editor do not write a
> modeling history, and ports are history objects. See
> `docs/V1.0F_CST_SAVE_INTEGRITY_FINDING.md` and the follow-up fix attempt
> `reports/cst_build_only/G0/20260913_115800/`.

## Baseline
- Repository: Dingo-infinity2020/RA_Lband_LNA
- PCB baseline: RA-LNA-L1 V1.0F
- Gate macro source: `G0_ENV_PREFLIGHT_BUILD_ONLY.bas` (as delivered, SHA256 `fb6b98b1…d905349e`)
- Macro actually executed: patched copy of the above, SHA256 `8565b0dc968cd5144a8e5120d49c5fe5c090626bb6e90875d509277b916bf51` (see Compatibility patches)
- CST version/build: CST Studio Suite 2022 (exact build number not captured)
- OS / host: Windows, host `DESKTOP-GBTI6Q4`, local user `Administrator`
- Run timestamp: 2026-09-13 10:53–10:59 (local, UTC+8)
- Local CST project path: `D:\RA_LNA\RA-LNA-L1_V1.0F_CST_BUILD_ONLY_GATES_v0.1\builds\RA_LNA_G0_PREFLIGHT_BUILD.cst`
  (this local file was later overwritten by run `20260913_115800`; the first-pass save had SHA256 `ee99a80f531841e3eb3700ee0269ac2cbbc3060a7aa639f1c7a6647ed1c06123`)
- Execution method: VBA Macro Editor (`Macros → Open VBA Macro Editor → Open… → Run`)

## Build result
- Macro completed: YES — ended at `MsgBox "G0 BUILD ONLY complete. Do not solve yet. Confirm geometry, ports and stack-up."`
- CST project created/saved: YES (`File → Save As` → `RA_LNA_G0_PREFLIGHT_BUILD.cst`)
- Number of components: 3 (`PCB`, `Planes`, `Top`)
- Number of solids/sheets: 7 brick solids (3 dielectric, 4 PEC)
- Number of ports: 2 (`port1`, `port2`) — present in the live session and at save time; **not retained after reopen** (see Warnings)
- Frequency range configured: 0.5–3.0 GHz (`Solver.FrequencyRange "0.5","3.0"`; configuration only, no solve)
- Solver started: NO

## Geometry / topology checks
- `PCB → PP_TOP`: FR4 brick, x 0–8, y 0–6 mm, z −h12…0
- `PCB → CORE`: FR4 brick, x 0–8, y 0–6 mm, z z_core_bot…z_l2_bot
- `PCB → PP_BOTTOM`: FR4 brick, x 0–8, y 0–6 mm, z z_bot_pp_bot…z_l3_bot
- `Planes → L2_GND`: PEC brick, x 0–8, y 0–6 mm, z z_l2_bot…z_l2_top
- `Planes → L3_GND`: PEC brick, x 0–8, y 0–6 mm, z z_l3_bot…z_l3_top
- `Planes → L4_GND`: PEC brick, x 0–8, y 0–6 mm, z z_bot_cu_min…z_bot_cu_max
- `Top → TRACE`: PEC brick, x 1–7, y 3−trace_w/2…3+trace_w/2, z 0…cu_top
- Materials: `FR4_RA_LNA` (er=4.1, tanD=0.018), `PEC`, `Vacuum`
- Lumped elements: none (as designed for G0)
- Boundaries: all six faces "expanded open"
- Visual inspection: stack order correct, no unintended overlaps found

## Port checks
| Port | Type | P1 | P2 | Intended reference | Visual sanity |
|---|---|---|---|---|---|
| `port1` | Discrete port, S-parameter, 50 Ω | (1.2, 3, cu_top) — on TRACE top surface | (1.2, 3, z_l2_top) — L2 GND top surface | L2 ground plane | red dot on trace, label "1" visible |
| `port2` | Discrete port, S-parameter, 50 Ω | (6.8, 3, cu_top) — on TRACE top surface | (6.8, 3, z_l2_top) — L2 GND top surface | L2 ground plane | red dot on trace, label "2" visible |

Both ports are listed under `Ports` in the navigation tree and are visible in SCREENSHOT_01 and SCREENSHOT_02.

## Stack-up / materials
- JLC04161H-3313 baseline (per package README): L1 Cu 0.035 / 3313 0.0994 / L2 Cu 0.0152 / core 1.265 / L3 Cu 0.0152 / 3313 0.0994 / L4 Cu 0.035 mm
- `er=4.1`, `tanD=0.018`, nominal RF trace width `trace_w=0.1565 mm`
- Copper modeled as PEC in v0.1 (deliberate simplification, documented in the package README)
- No dedicated stack-up section screenshot was captured for this run (see Reviewer questions)

## Warnings / errors
1. **CRITICAL — saved-project integrity (this is why FINAL_STATUS=FAIL).**
   After `File → Save As` and reopening the `.cst`, the ports are absent. In the first-pass
   saves, `Model\3D\Model.mod` contains only the empty 209-byte history header, so there is
   nothing for CST to replay; the PCB geometry survives because it is baked into `Model.dib`.
   Ports and lumped elements are history objects and are lost.
2. Compatibility issue found before this run and fixed: `NewMWS` raised
   `Expecting an existing scalar var. (NewMWS)` inside the DE macro environment
   (external COM-automation method, not an internal command). Patched to `FileNew`.
3. Follow-up fix attempt (run `20260913_115800`): structure macro DID record history
   (`Model.mod` 1,432 B) but reopening failed with
   `CST MICROWAVE STUDIO - History Error: Expecting an existing scalar var. (SetCommonUnitsAndMaterials)`
   because the recorded block contains calls to the macro's private helper subs.

## Compatibility patches
- One line changed in the supplied macro, no RF geometry or parameter touched:
  `NewMWS` → `FileNew` (see `MACRO_DIFF.patch`).
- Reason: `NewMWS` is an external COM-automation method (`CSTStudio.Application.NewMWS`);
  inside a Design Environment macro the interpreter looks for a non-existent variable.
  `FileNew` ("Resets the entire program. A new unnamed project will be opened.") is the
  documented internal equivalent.
- The supplied original is retained in this package as `MACRO_SUPPLIED_ORIGINAL.bas`
  and locally at `builds\original_macros\G0_ENV_PREFLIGHT_BUILD_ONLY.bas.orig`.

## Visual evidence
- `SCREENSHOT_01_OVERVIEW.png` — full model overview: PCB stack, TRACE, both port markers, Parameter List
- `SCREENSHOT_02_PORTS.png` — navigation tree expanded: Components (PCB / Planes / Top), Materials, `Ports → port1, port2`; both ports visible in 3D
- `SCREENSHOT_03_COMPLETION_DIALOG.png` — macro completion MsgBox with the built model (build-only proof)
- `SCREENSHOT_04_SAVED_PROJECT.png` — after `Save As`: title bar `RA_LNA_G0_PREFLIGHT_BUILD`, ports still present in the session

## Reviewer questions / uncertainties
1. Confirm that the save-integrity defect must be fixed (flattened structure macro) and reopen-verified before G0 can be approved; the geometry build itself appears correct.
2. No dedicated stack-up section screenshot was captured; is the parameter/thickness evidence sufficient, or should the re-run capture a section view?
3. `port1`/`port2` are discrete ports on the TRACE→L2 gap at x=1.2 / 6.8 mm. Confirm the intended reference plane (L2 GND) matches the launch modeling intent for G1/G2.

## Conclusion
The G0 build-only execution was clean, the model was visually accepted in-session, and no solver
was started. However, the saved project does not retain its ports on reopen, so this gate is
**not ready for remote approval**. A flattened, replay-safe structure macro re-run is required
(see `docs/V1.0F_CST_SAVE_INTEGRITY_FINDING.md`); this package will be superseded by the new run.
