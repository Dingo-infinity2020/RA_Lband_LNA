Option Explicit

' RA-LNA-L1 V1.0F — CST G3 replay-safe BUILD-ONLY structure macro v2
' CST Studio Suite 2022
'
' PURPOSE
'   Build the focused RF_OUT_VDD -> bias/decoupling -> VIN5 network for
'   pre-solver topology and persistence validation.
'
' IMPORTANT
'   * Run ONLY as a CST Structure Macro in a fresh, already-open MWS project.
'   * Do NOT execute from the ordinary VBA Macro Editor.
'   * Do NOT add any project-creation command.
'   * BUILD ONLY: no solver, sweep, optimizer, mesh adaptation, or solve-start command is present.
'   * Deliberately FLAT: Sub Main contains only native CST commands.
'   * No helper procedures, loops, completion dialogs, or user-defined function calls.

Sub Main()

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

    With Units
        .Geometry "mm"
        .Frequency "GHz"
        .Time "ns"
        .Voltage "V"
    End With

    With Material
        .Reset
        .Name "FR4_RA_LNA"
        .Type "Normal"
        .Epsilon "er"
        .Mue "1.0"
        .TanD "tand"
        .Create
    End With

    Solver.FrequencyRange "0.5", "3.0"

    With Brick
        .Reset
        .Name "PP_TOP"
        .Component "PCB"
        .Material "FR4_RA_LNA"
        .Xrange "5.8", "22.0"
        .Yrange "5.0", "17.0"
        .Zrange "-h12", "0"
        .Create
    End With

    With Brick
        .Reset
        .Name "CORE"
        .Component "PCB"
        .Material "FR4_RA_LNA"
        .Xrange "5.8", "22.0"
        .Yrange "5.0", "17.0"
        .Zrange "z_core_bot", "z_l2_bot"
        .Create
    End With

    With Brick
        .Reset
        .Name "PP_BOTTOM"
        .Component "PCB"
        .Material "FR4_RA_LNA"
        .Xrange "5.8", "22.0"
        .Yrange "5.0", "17.0"
        .Zrange "z_bot_pp_bot", "z_l3_bot"
        .Create
    End With

    With Brick
        .Reset
        .Name "L2_GND"
        .Component "Planes"
        .Material "PEC"
        .Xrange "5.8", "22.0"
        .Yrange "5.0", "17.0"
        .Zrange "z_l2_bot", "z_l2_top"
        .Create
    End With

    With Brick
        .Reset
        .Name "L3_GND"
        .Component "Planes"
        .Material "PEC"
        .Xrange "5.8", "22.0"
        .Yrange "5.0", "17.0"
        .Zrange "z_l3_bot", "z_l3_top"
        .Create
    End With

    With Brick
        .Reset
        .Name "L4_GND"
        .Component "Planes"
        .Material "PEC"
        .Xrange "5.8", "22.0"
        .Yrange "5.0", "17.0"
        .Zrange "z_bot_cu_min", "z_bot_cu_max"
        .Create
    End With

    With Brick
        .Reset
        .Name "U1_PIN7_PAD"
        .Component "Top"
        .Material "PEC"
        .Xrange "7.685", "8.115"
        .Yrange "8.875", "9.125"
        .Zrange "0", "cu_top"
        .Create
    End With

    With Brick
        .Reset
        .Name "L1_STUB_H"
        .Component "Top"
        .Material "PEC"
        .Xrange "8.115", "8.50"
        .Yrange "8.90", "9.10"
        .Zrange "0", "cu_top"
        .Create
    End With

    With Brick
        .Reset
        .Name "L1_STUB_V"
        .Component "Top"
        .Material "PEC"
        .Xrange "8.40", "8.60"
        .Yrange "9.0", "9.85"
        .Zrange "0", "cu_top"
        .Create
    End With

    With Brick
        .Reset
        .Name "L1_PAD_RF"
        .Component "Top"
        .Material "PEC"
        .Xrange "8.20", "8.80"
        .Yrange "9.85", "10.40"
        .Zrange "0", "cu_top"
        .Create
    End With

    With Brick
        .Reset
        .Name "L1_PAD_VDD"
        .Component "Top"
        .Material "PEC"
        .Xrange "8.20", "8.80"
        .Yrange "10.70", "11.25"
        .Zrange "0", "cu_top"
        .Create
    End With

    With LumpedElement
        .Reset
        .SetName "L1_18nH"
        .Folder "Lumped"
        .SetType "RLCSerial"
        .SetR "0.138"
        .SetL "18e-9"
        .SetC "0"
        .SetGs "0"
        .SetI0 "0"
        .SetT "0"
        .SetMonitor "True"
        .SetRadius "0.04"
        .CircuitFileName ""
        .CircuitId "1"
        .UseCopyOnly "True"
        .UseRelativePath "False"
        .SetP1 "False", "8.5", "10.40", "cu_top"
        .SetP2 "False", "8.5", "10.70", "cu_top"
        .SetInvert "False"
        .Wire ""
        .Position "end1"
        .Create
    End With

    With Brick
        .Reset
        .Name "VDD_BUS"
        .Component "Top"
        .Material "PEC"
        .Xrange "6.5", "11.30"
        .Yrange "10.85", "11.10"
        .Zrange "0", "cu_top"
        .Create
    End With

    With Brick
        .Reset
        .Name "C5_PAD_VDD"
        .Component "Top"
        .Material "PEC"
        .Xrange "8.4", "9"
        .Yrange "11.30", "11.85"
        .Zrange "0", "cu_top"
        .Create
    End With

    With Brick
        .Reset
        .Name "C5_PAD_GND"
        .Component "Top"
        .Material "PEC"
        .Xrange "8.4", "9"
        .Yrange "12.15", "12.70"
        .Zrange "0", "cu_top"
        .Create
    End With

    With Brick
        .Reset
        .Name "C5_VDD_STUB"
        .Component "Top"
        .Material "PEC"
        .Xrange "8.59", "8.81"
        .Yrange "10.975", "11.725"
        .Zrange "0", "cu_top"
        .Create
    End With

    With Brick
        .Reset
        .Name "C5_GND_STUB"
        .Component "Top"
        .Material "PEC"
        .Xrange "8.575", "8.825"
        .Yrange "12.275", "13.10"
        .Zrange "0", "cu_top"
        .Create
    End With

    With LumpedElement
        .Reset
        .SetName "C5_CAP"
        .Folder "Lumped"
        .SetType "RLCSerial"
        .SetR "0.03"
        .SetL "0"
        .SetC "100e-12"
        .SetGs "0"
        .SetI0 "0"
        .SetT "0"
        .SetMonitor "True"
        .SetRadius "0.04"
        .CircuitFileName ""
        .CircuitId "1"
        .UseCopyOnly "True"
        .UseRelativePath "False"
        .SetP1 "False", "8.7", "11.85", "cu_top"
        .SetP2 "False", "8.7", "12.15", "cu_top"
        .SetInvert "False"
        .Wire ""
        .Position "end1"
        .Create
    End With

    With Cylinder
        .Reset
        .Name "C5_GND_VIA"
        .Component "Vias"
        .Material "PEC"
        .OuterRadius "(0.35)/2"
        .InnerRadius "0"
        .Axis "z"
        .Zrange "z_bot_cu_min", "cu_top"
        .Xcenter "8.7"
        .Ycenter "13.10"
        .Segments "0"
        .Create
    End With

    With Brick
        .Reset
        .Name "C3_PAD_VDD"
        .Component "Top"
        .Material "PEC"
        .Xrange "9.5", "10.1"
        .Yrange "11.30", "11.85"
        .Zrange "0", "cu_top"
        .Create
    End With

    With Brick
        .Reset
        .Name "C3_PAD_GND"
        .Component "Top"
        .Material "PEC"
        .Xrange "9.5", "10.1"
        .Yrange "12.15", "12.70"
        .Zrange "0", "cu_top"
        .Create
    End With

    With Brick
        .Reset
        .Name "C3_VDD_STUB"
        .Component "Top"
        .Material "PEC"
        .Xrange "9.69", "9.91"
        .Yrange "10.975", "11.725"
        .Zrange "0", "cu_top"
        .Create
    End With

    With Brick
        .Reset
        .Name "C3_GND_STUB"
        .Component "Top"
        .Material "PEC"
        .Xrange "9.675", "9.925"
        .Yrange "12.275", "13.10"
        .Zrange "0", "cu_top"
        .Create
    End With

    With LumpedElement
        .Reset
        .SetName "C3_CAP"
        .Folder "Lumped"
        .SetType "RLCSerial"
        .SetR "0.03"
        .SetL "0"
        .SetC "100e-12"
        .SetGs "0"
        .SetI0 "0"
        .SetT "0"
        .SetMonitor "True"
        .SetRadius "0.04"
        .CircuitFileName ""
        .CircuitId "1"
        .UseCopyOnly "True"
        .UseRelativePath "False"
        .SetP1 "False", "9.8", "11.85", "cu_top"
        .SetP2 "False", "9.8", "12.15", "cu_top"
        .SetInvert "False"
        .Wire ""
        .Position "end1"
        .Create
    End With

    With Cylinder
        .Reset
        .Name "C3_GND_VIA"
        .Component "Vias"
        .Material "PEC"
        .OuterRadius "(0.35)/2"
        .InnerRadius "0"
        .Axis "z"
        .Zrange "z_bot_cu_min", "cu_top"
        .Xcenter "9.8"
        .Ycenter "13.10"
        .Segments "0"
        .Create
    End With

    With Brick
        .Reset
        .Name "C4_PAD_VDD"
        .Component "Top"
        .Material "PEC"
        .Xrange "10.6", "11.2"
        .Yrange "11.30", "11.85"
        .Zrange "0", "cu_top"
        .Create
    End With

    With Brick
        .Reset
        .Name "C4_PAD_GND"
        .Component "Top"
        .Material "PEC"
        .Xrange "10.6", "11.2"
        .Yrange "12.15", "12.70"
        .Zrange "0", "cu_top"
        .Create
    End With

    With Brick
        .Reset
        .Name "C4_VDD_STUB"
        .Component "Top"
        .Material "PEC"
        .Xrange "10.79", "11.01"
        .Yrange "10.975", "11.725"
        .Zrange "0", "cu_top"
        .Create
    End With

    With Brick
        .Reset
        .Name "C4_GND_STUB"
        .Component "Top"
        .Material "PEC"
        .Xrange "10.775", "11.025"
        .Yrange "12.275", "13.10"
        .Zrange "0", "cu_top"
        .Create
    End With

    With LumpedElement
        .Reset
        .SetName "C4_CAP"
        .Folder "Lumped"
        .SetType "RLCSerial"
        .SetR "0.03"
        .SetL "0"
        .SetC "1e-6"
        .SetGs "0"
        .SetI0 "0"
        .SetT "0"
        .SetMonitor "True"
        .SetRadius "0.04"
        .CircuitFileName ""
        .CircuitId "1"
        .UseCopyOnly "True"
        .UseRelativePath "False"
        .SetP1 "False", "10.9", "11.85", "cu_top"
        .SetP2 "False", "10.9", "12.15", "cu_top"
        .SetInvert "False"
        .Wire ""
        .Position "end1"
        .Create
    End With

    With Cylinder
        .Reset
        .Name "C4_GND_VIA"
        .Component "Vias"
        .Material "PEC"
        .OuterRadius "(0.35)/2"
        .InnerRadius "0"
        .Axis "z"
        .Zrange "z_bot_cu_min", "cu_top"
        .Xcenter "10.9"
        .Ycenter "13.10"
        .Segments "0"
        .Create
    End With

    With Brick
        .Reset
        .Name "R3_PAD1"
        .Component "Top"
        .Material "PEC"
        .Xrange "11.30", "11.85"
        .Yrange "10.675", "11.275"
        .Zrange "0", "cu_top"
        .Create
    End With

    With Brick
        .Reset
        .Name "R3_PAD2"
        .Component "Top"
        .Material "PEC"
        .Xrange "12.15", "12.70"
        .Yrange "10.675", "11.275"
        .Zrange "0", "cu_top"
        .Create
    End With

    With LumpedElement
        .Reset
        .SetName "R3_0R"
        .Folder "Lumped"
        .SetType "RLCSerial"
        .SetR "0.02"
        .SetL "0"
        .SetC "0"
        .SetGs "0"
        .SetI0 "0"
        .SetT "0"
        .SetMonitor "True"
        .SetRadius "0.04"
        .CircuitFileName ""
        .CircuitId "1"
        .UseCopyOnly "True"
        .UseRelativePath "False"
        .SetP1 "False", "11.85", "10.975", "cu_top"
        .SetP2 "False", "12.15", "10.975", "cu_top"
        .SetInvert "False"
        .Wire ""
        .Position "end1"
        .Create
    End With

    With Brick
        .Reset
        .Name "VIN_H"
        .Component "Top"
        .Material "PEC"
        .Xrange "12.70", "17.0"
        .Yrange "10.775", "11.175"
        .Zrange "0", "cu_top"
        .Create
    End With

    With Brick
        .Reset
        .Name "VIN_V"
        .Component "Top"
        .Material "PEC"
        .Xrange "16.80", "17.20"
        .Yrange "10.975", "14.20"
        .Zrange "0", "cu_top"
        .Create
    End With

    With Brick
        .Reset
        .Name "J3_5V"
        .Component "Top"
        .Material "PEC"
        .Xrange "15.80", "18.20"
        .Yrange "14.10", "16.10"
        .Zrange "0", "cu_top"
        .Create
    End With

    With Brick
        .Reset
        .Name "C8_PAD_VIN"
        .Component "Top"
        .Material "PEC"
        .Xrange "13.875", "15.125"
        .Yrange "11.325", "12.475"
        .Zrange "0", "cu_top"
        .Create
    End With

    With Brick
        .Reset
        .Name "C8_PAD_GND"
        .Component "Top"
        .Material "PEC"
        .Xrange "13.875", "15.125"
        .Yrange "13.125", "14.275"
        .Zrange "0", "cu_top"
        .Create
    End With

    With Brick
        .Reset
        .Name "C8_VIN_STUB"
        .Component "Top"
        .Material "PEC"
        .Xrange "14.30", "14.70"
        .Yrange "10.975", "11.425"
        .Zrange "0", "cu_top"
        .Create
    End With

    With LumpedElement
        .Reset
        .SetName "C8_10uF"
        .Folder "Lumped"
        .SetType "RLCSerial"
        .SetR "0.03"
        .SetL "0"
        .SetC "10e-6"
        .SetGs "0"
        .SetI0 "0"
        .SetT "0"
        .SetMonitor "True"
        .SetRadius "0.04"
        .CircuitFileName ""
        .CircuitId "1"
        .UseCopyOnly "True"
        .UseRelativePath "False"
        .SetP1 "False", "14.5", "12.475", "cu_top"
        .SetP2 "False", "14.5", "13.125", "cu_top"
        .SetInvert "False"
        .Wire ""
        .Position "end1"
        .Create
    End With

    With Brick
        .Reset
        .Name "C8_GND_STUB"
        .Component "Top"
        .Material "PEC"
        .Xrange "14.5", "15.45"
        .Yrange "13.50", "13.90"
        .Zrange "0", "cu_top"
        .Create
    End With

    With Cylinder
        .Reset
        .Name "C8_GND_VIA"
        .Component "Vias"
        .Material "PEC"
        .OuterRadius "(0.35)/2"
        .InnerRadius "0"
        .Axis "z"
        .Zrange "z_bot_cu_min", "cu_top"
        .Xcenter "15.45"
        .Ycenter "13.70"
        .Segments "0"
        .Create
    End With

    With Brick
        .Reset
        .Name "J3_GND"
        .Component "Top"
        .Material "PEC"
        .Xrange "19.30", "21.70"
        .Yrange "14.10", "16.10"
        .Zrange "0", "cu_top"
        .Create
    End With

    With Cylinder
        .Reset
        .Name "J3_GND_V1"
        .Component "Vias"
        .Material "PEC"
        .OuterRadius "(0.35)/2"
        .InnerRadius "0"
        .Axis "z"
        .Zrange "z_bot_cu_min", "cu_top"
        .Xcenter "20.0"
        .Ycenter "15.1"
        .Segments "0"
        .Create
    End With

    With Cylinder
        .Reset
        .Name "J3_GND_V2"
        .Component "Vias"
        .Material "PEC"
        .OuterRadius "(0.35)/2"
        .InnerRadius "0"
        .Axis "z"
        .Zrange "z_bot_cu_min", "cu_top"
        .Xcenter "21.0"
        .Ycenter "15.1"
        .Segments "0"
        .Create
    End With

    With Brick
        .Reset
        .Name "U1_PIN1_PAD"
        .Component "Top"
        .Material "PEC"
        .Xrange "6.285", "6.715"
        .Yrange "9.375", "9.625"
        .Zrange "0", "cu_top"
        .Create
    End With

    With Brick
        .Reset
        .Name "R4_STUB"
        .Component "Top"
        .Material "PEC"
        .Xrange "6.40", "6.60"
        .Yrange "9.625", "9.85"
        .Zrange "0", "cu_top"
        .Create
    End With

    With Brick
        .Reset
        .Name "R4_PAD_LO"
        .Component "Top"
        .Material "PEC"
        .Xrange "6.20", "6.80"
        .Yrange "9.85", "10.40"
        .Zrange "0", "cu_top"
        .Create
    End With

    With Brick
        .Reset
        .Name "R4_PAD_HI"
        .Component "Top"
        .Material "PEC"
        .Xrange "6.20", "6.80"
        .Yrange "10.70", "11.25"
        .Zrange "0", "cu_top"
        .Create
    End With

    With LumpedElement
        .Reset
        .SetName "R4_3k32"
        .Folder "Lumped"
        .SetType "RLCSerial"
        .SetR "3320"
        .SetL "0"
        .SetC "0"
        .SetGs "0"
        .SetI0 "0"
        .SetT "0"
        .SetMonitor "True"
        .SetRadius "0.04"
        .CircuitFileName ""
        .CircuitId "1"
        .UseCopyOnly "True"
        .UseRelativePath "False"
        .SetP1 "False", "6.5", "10.40", "cu_top"
        .SetP2 "False", "6.5", "10.70", "cu_top"
        .SetInvert "False"
        .Wire ""
        .Position "end1"
        .Create
    End With

    With DiscretePort
        .Reset
        .PortNumber "1"
        .Type "SParameter"
        .Impedance "50"
        .SetP1 "False", "7.90", "9", "cu_top"
        .SetP2 "False", "7.90", "9", "z_l2_top"
        .Create
    End With

    With DiscretePort
        .Reset
        .PortNumber "2"
        .Type "SParameter"
        .Impedance "50"
        .SetP1 "False", "17.0", "15.1", "cu_top"
        .SetP2 "False", "17.0", "15.1", "z_l2_top"
        .Create
    End With

    With Boundary
        .Xmin "expanded open"
        .Xmax "expanded open"
        .Ymin "expanded open"
        .Ymax "expanded open"
        .Zmin "expanded open"
        .Zmax "expanded open"
    End With

End Sub
