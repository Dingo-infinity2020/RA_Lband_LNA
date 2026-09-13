Option Explicit

' RA-LNA-L1 V1.0F — CST G0 replay-safe BUILD-ONLY structure macro v2
' CST Studio Suite 2022
'
' PURPOSE
'   Validate that a saved CST project survives close/reopen with geometry AND ports intact.
'
' IMPORTANT
'   * Run this ONLY as a CST Structure Macro in a fresh, already-open MWS project.
'   * Do NOT execute from the ordinary VBA Macro Editor.
'   * Do NOT add FileNew/NewMWS here.
'   * BUILD ONLY: no solver, sweep, optimizer, mesh adaptation, or solve command is present.
'   * This macro is deliberately FLAT: Sub Main contains only native CST commands.
'     No helper subs, loops, MsgBox, or user-defined function calls are used.

Sub Main()

    ' ----------------------------
    ' Project parameters / stackup
    ' ----------------------------
    StoreParameter "er", 4.1
    StoreParameter "tand", 0.018
    StoreParameter "cu_top", 0.035
    StoreParameter "cu_inner", 0.0152
    StoreParameter "h12", 0.0994
    StoreParameter "core_h", 1.265
    StoreParameter "h34", 0.0994
    StoreParameter "trace_w", 0.1565

    StoreParameter "z_l2_top", "-h12"
    StoreParameter "z_l2_bot", "-h12-cu_inner"
    StoreParameter "z_core_bot", "-h12-cu_inner-core_h"
    StoreParameter "z_l3_top", "-h12-cu_inner-core_h"
    StoreParameter "z_l3_bot", "-h12-cu_inner-core_h-cu_inner"
    StoreParameter "z_bot_pp_bot", "-h12-cu_inner-core_h-cu_inner-h34"
    StoreParameter "z_bot_cu_max", "-h12-cu_inner-core_h-cu_inner-h34"
    StoreParameter "z_bot_cu_min", "-h12-cu_inner-core_h-cu_inner-h34-cu_top"

    ' -----
    ' Units
    ' -----
    With Units
        .Geometry "mm"
        .Frequency "GHz"
        .Time "ns"
        .Voltage "V"
    End With

    ' -----------------
    ' Dielectric material
    ' -----------------
    With Material
        .Reset
        .Name "FR4_RA_LNA"
        .Type "Normal"
        .Epsilon "er"
        .Mue "1.0"
        .TanD "tand"
        .Create
    End With

    ' Frequency range only — DOES NOT start a solver.
    Solver.FrequencyRange "0.5", "3.0"

    ' ------------------
    ' Dielectric regions
    ' ------------------
    With Brick
        .Reset
        .Name "PP_TOP"
        .Component "PCB"
        .Material "FR4_RA_LNA"
        .Xrange "0", "8"
        .Yrange "0", "6"
        .Zrange "-h12", "0"
        .Create
    End With

    With Brick
        .Reset
        .Name "CORE"
        .Component "PCB"
        .Material "FR4_RA_LNA"
        .Xrange "0", "8"
        .Yrange "0", "6"
        .Zrange "z_core_bot", "z_l2_bot"
        .Create
    End With

    With Brick
        .Reset
        .Name "PP_BOTTOM"
        .Component "PCB"
        .Material "FR4_RA_LNA"
        .Xrange "0", "8"
        .Yrange "0", "6"
        .Zrange "z_bot_pp_bot", "z_l3_bot"
        .Create
    End With

    ' ---------------------
    ' L2/L3/L4 ground copper
    ' ---------------------
    With Brick
        .Reset
        .Name "L2_GND"
        .Component "Planes"
        .Material "PEC"
        .Xrange "0", "8"
        .Yrange "0", "6"
        .Zrange "z_l2_bot", "z_l2_top"
        .Create
    End With

    With Brick
        .Reset
        .Name "L3_GND"
        .Component "Planes"
        .Material "PEC"
        .Xrange "0", "8"
        .Yrange "0", "6"
        .Zrange "z_l3_bot", "z_l3_top"
        .Create
    End With

    With Brick
        .Reset
        .Name "L4_GND"
        .Component "Planes"
        .Material "PEC"
        .Xrange "0", "8"
        .Yrange "0", "6"
        .Zrange "z_bot_cu_min", "z_bot_cu_max"
        .Create
    End With

    ' ----------------
    ' Top microstrip line
    ' ----------------
    With Brick
        .Reset
        .Name "TRACE"
        .Component "Top"
        .Material "PEC"
        .Xrange "1", "7"
        .Yrange "3-trace_w/2", "3+trace_w/2"
        .Zrange "0", "cu_top"
        .Create
    End With

    ' -----------------------------
    ' Two 50-ohm discrete S-ports
    ' Top trace -> L2 ground reference
    ' -----------------------------
    With DiscretePort
        .Reset
        .PortNumber "1"
        .Type "SParameter"
        .Impedance "50"
        .SetP1 "False", "1.2", "3", "cu_top"
        .SetP2 "False", "1.2", "3", "z_l2_top"
        .Create
    End With

    With DiscretePort
        .Reset
        .PortNumber "2"
        .Type "SParameter"
        .Impedance "50"
        .SetP1 "False", "6.8", "3", "cu_top"
        .SetP2 "False", "6.8", "3", "z_l2_top"
        .Create
    End With

    ' ----------
    ' Boundaries
    ' ----------
    With Boundary
        .Xmin "expanded open"
        .Xmax "expanded open"
        .Ymin "expanded open"
        .Ymax "expanded open"
        .Zmin "expanded open"
        .Zmax "expanded open"
    End With

End Sub
