Option Explicit

' RA-LNA-L1 V1.0F — CST G1 replay-safe BUILD-ONLY structure macro v2
' CST Studio Suite 2022
'
' PURPOSE
'   Build the input SMA PCB-side launch, C1, local U1 input reference geometry, and two ports.
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
        .Xrange "0", "7.8"
        .Yrange "3.8", "14.2"
        .Zrange "-h12", "0"
        .Create
    End With
    With Brick
        .Reset
        .Name "CORE"
        .Component "PCB"
        .Material "FR4_RA_LNA"
        .Xrange "0", "7.8"
        .Yrange "3.8", "14.2"
        .Zrange "z_core_bot", "z_l2_bot"
        .Create
    End With
    With Brick
        .Reset
        .Name "PP_BOTTOM"
        .Component "PCB"
        .Material "FR4_RA_LNA"
        .Xrange "0", "7.8"
        .Yrange "3.8", "14.2"
        .Zrange "z_bot_pp_bot", "z_l3_bot"
        .Create
    End With
    With Brick
        .Reset
        .Name "L2_GND"
        .Component "Planes"
        .Material "PEC"
        .Xrange "0", "7.8"
        .Yrange "3.8", "14.2"
        .Zrange "z_l2_bot", "z_l2_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "L3_GND"
        .Component "Planes"
        .Material "PEC"
        .Xrange "0", "7.8"
        .Yrange "3.8", "14.2"
        .Zrange "z_l3_bot", "z_l3_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "L4_GND"
        .Component "Planes"
        .Material "PEC"
        .Xrange "0", "7.8"
        .Yrange "3.8", "14.2"
        .Zrange "z_bot_cu_min", "z_bot_cu_max"
        .Create
    End With

    With Brick
        .Reset
        .Name "J1_SIG"
        .Component "Top"
        .Material "PEC"
        .Xrange "0", "3.81"
        .Yrange "8.40", "9.60"
        .Zrange "0", "cu_top"
        .Create
    End With

    With Brick
        .Reset
        .Name "J1_TAPER_0"
        .Component "Top"
        .Material "PEC"
        .Xrange "3.81", "3.84375"
        .Yrange "9-(1.20-1*(1.20-trace_w)/16)/2", "9+(1.20-1*(1.20-trace_w)/16)/2"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "J1_TAPER_1"
        .Component "Top"
        .Material "PEC"
        .Xrange "3.84375", "3.8775"
        .Yrange "9-(1.20-2*(1.20-trace_w)/16)/2", "9+(1.20-2*(1.20-trace_w)/16)/2"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "J1_TAPER_2"
        .Component "Top"
        .Material "PEC"
        .Xrange "3.8775", "3.91125"
        .Yrange "9-(1.20-3*(1.20-trace_w)/16)/2", "9+(1.20-3*(1.20-trace_w)/16)/2"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "J1_TAPER_3"
        .Component "Top"
        .Material "PEC"
        .Xrange "3.91125", "3.945"
        .Yrange "9-(1.20-4*(1.20-trace_w)/16)/2", "9+(1.20-4*(1.20-trace_w)/16)/2"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "J1_TAPER_4"
        .Component "Top"
        .Material "PEC"
        .Xrange "3.945", "3.97875"
        .Yrange "9-(1.20-5*(1.20-trace_w)/16)/2", "9+(1.20-5*(1.20-trace_w)/16)/2"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "J1_TAPER_5"
        .Component "Top"
        .Material "PEC"
        .Xrange "3.97875", "4.0125"
        .Yrange "9-(1.20-6*(1.20-trace_w)/16)/2", "9+(1.20-6*(1.20-trace_w)/16)/2"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "J1_TAPER_6"
        .Component "Top"
        .Material "PEC"
        .Xrange "4.0125", "4.04625"
        .Yrange "9-(1.20-7*(1.20-trace_w)/16)/2", "9+(1.20-7*(1.20-trace_w)/16)/2"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "J1_TAPER_7"
        .Component "Top"
        .Material "PEC"
        .Xrange "4.04625", "4.08"
        .Yrange "9-(1.20-8*(1.20-trace_w)/16)/2", "9+(1.20-8*(1.20-trace_w)/16)/2"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "J1_TAPER_8"
        .Component "Top"
        .Material "PEC"
        .Xrange "4.08", "4.11375"
        .Yrange "9-(1.20-9*(1.20-trace_w)/16)/2", "9+(1.20-9*(1.20-trace_w)/16)/2"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "J1_TAPER_9"
        .Component "Top"
        .Material "PEC"
        .Xrange "4.11375", "4.1475"
        .Yrange "9-(1.20-10*(1.20-trace_w)/16)/2", "9+(1.20-10*(1.20-trace_w)/16)/2"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "J1_TAPER_10"
        .Component "Top"
        .Material "PEC"
        .Xrange "4.1475", "4.18125"
        .Yrange "9-(1.20-11*(1.20-trace_w)/16)/2", "9+(1.20-11*(1.20-trace_w)/16)/2"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "J1_TAPER_11"
        .Component "Top"
        .Material "PEC"
        .Xrange "4.18125", "4.215"
        .Yrange "9-(1.20-12*(1.20-trace_w)/16)/2", "9+(1.20-12*(1.20-trace_w)/16)/2"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "J1_TAPER_12"
        .Component "Top"
        .Material "PEC"
        .Xrange "4.215", "4.24875"
        .Yrange "9-(1.20-13*(1.20-trace_w)/16)/2", "9+(1.20-13*(1.20-trace_w)/16)/2"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "J1_TAPER_13"
        .Component "Top"
        .Material "PEC"
        .Xrange "4.24875", "4.2825"
        .Yrange "9-(1.20-14*(1.20-trace_w)/16)/2", "9+(1.20-14*(1.20-trace_w)/16)/2"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "J1_TAPER_14"
        .Component "Top"
        .Material "PEC"
        .Xrange "4.2825", "4.31625"
        .Yrange "9-(1.20-15*(1.20-trace_w)/16)/2", "9+(1.20-15*(1.20-trace_w)/16)/2"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "J1_TAPER_15"
        .Component "Top"
        .Material "PEC"
        .Xrange "4.31625", "4.35"
        .Yrange "9-(1.20-16*(1.20-trace_w)/16)/2", "9+(1.20-16*(1.20-trace_w)/16)/2"
        .Zrange "0", "cu_top"
        .Create
    End With

    With Brick
        .Reset
        .Name "J1_GND_LO"
        .Component "Top"
        .Material "PEC"
        .Xrange "0", "3.81"
        .Yrange "4.85", "7.55"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "J1_GND_HI"
        .Component "Top"
        .Material "PEC"
        .Xrange "0", "3.81"
        .Yrange "10.45", "13.15"
        .Zrange "0", "cu_top"
        .Create
    End With

    With Cylinder
        .Reset
        .Name "J1_V1"
        .Component "Vias"
        .Material "PEC"
        .OuterRadius "(0.35)/2"
        .InnerRadius "0"
        .Axis "z"
        .Zrange "z_bot_cu_min", "cu_top"
        .Xcenter "1.1"
        .Ycenter "7.9"
        .Segments "0"
        .Create
    End With
    With Cylinder
        .Reset
        .Name "J1_V2"
        .Component "Vias"
        .Material "PEC"
        .OuterRadius "(0.35)/2"
        .InnerRadius "0"
        .Axis "z"
        .Zrange "z_bot_cu_min", "cu_top"
        .Xcenter "1.1"
        .Ycenter "10.1"
        .Segments "0"
        .Create
    End With
    With Cylinder
        .Reset
        .Name "J1_V3"
        .Component "Vias"
        .Material "PEC"
        .OuterRadius "(0.35)/2"
        .InnerRadius "0"
        .Axis "z"
        .Zrange "z_bot_cu_min", "cu_top"
        .Xcenter "2.4"
        .Ycenter "7.9"
        .Segments "0"
        .Create
    End With
    With Cylinder
        .Reset
        .Name "J1_V4"
        .Component "Vias"
        .Material "PEC"
        .OuterRadius "(0.35)/2"
        .InnerRadius "0"
        .Axis "z"
        .Zrange "z_bot_cu_min", "cu_top"
        .Xcenter "2.4"
        .Ycenter "10.1"
        .Segments "0"
        .Create
    End With

    With Brick
        .Reset
        .Name "RF_IN_1"
        .Component "Top"
        .Material "PEC"
        .Xrange "4.35", "4.40"
        .Yrange "9-trace_w/2", "9+trace_w/2"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "C1_PAD1"
        .Component "Top"
        .Material "PEC"
        .Xrange "4.40", "4.95"
        .Yrange "8.70", "9.30"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "C1_PAD2"
        .Component "Top"
        .Material "PEC"
        .Xrange "5.25", "5.80"
        .Yrange "8.70", "9.30"
        .Zrange "0", "cu_top"
        .Create
    End With

    With LumpedElement
        .Reset
        .SetName "C1_100pF"
        .Folder "Lumped"
        .SetType "RLCSerial"
        .SetR "0"
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
        .SetP1 "False", "4.95", "9", "cu_top"
        .SetP2 "False", "5.25", "9", "cu_top"
        .SetInvert "False"
        .Wire ""
        .Position "end1"
        .Create
    End With

    With Brick
        .Reset
        .Name "RF_IN_2"
        .Component "Top"
        .Material "PEC"
        .Xrange "5.35", "6.285"
        .Yrange "9-trace_w/2", "9+trace_w/2"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "U1_PIN2_PAD"
        .Component "Top"
        .Material "PEC"
        .Xrange "6.285", "6.715"
        .Yrange "8.875", "9.125"
        .Zrange "0", "cu_top"
        .Create
    End With

    With Cylinder
        .Reset
        .Name "U1_GND34"
        .Component "Vias"
        .Material "PEC"
        .OuterRadius "(0.35)/2"
        .InnerRadius "0"
        .Axis "z"
        .Zrange "z_bot_cu_min", "cu_top"
        .Xcenter "5.65"
        .Ycenter "8.25"
        .Segments "0"
        .Create
    End With
    With Brick
        .Reset
        .Name "U1_EP"
        .Component "Top"
        .Material "PEC"
        .Xrange "6.81", "7.59"
        .Yrange "7.95", "9.55"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Cylinder
        .Reset
        .Name "U1_EP_A"
        .Component "Vias"
        .Material "PEC"
        .OuterRadius "(0.30)/2"
        .InnerRadius "0"
        .Axis "z"
        .Zrange "z_bot_cu_min", "cu_top"
        .Xcenter "7.2"
        .Ycenter "8.35"
        .Segments "0"
        .Create
    End With
    With Cylinder
        .Reset
        .Name "U1_EP_B"
        .Component "Vias"
        .Material "PEC"
        .OuterRadius "(0.30)/2"
        .InnerRadius "0"
        .Axis "z"
        .Zrange "z_bot_cu_min", "cu_top"
        .Xcenter "7.2"
        .Ycenter "9.15"
        .Segments "0"
        .Create
    End With

    With DiscretePort
        .Reset
        .PortNumber "1"
        .Type "SParameter"
        .Impedance "50"
        .SetP1 "False", "0.25", "9", "cu_top"
        .SetP2 "False", "0.25", "9", "z_l2_top"
        .Create
    End With
    With DiscretePort
        .Reset
        .PortNumber "2"
        .Type "SParameter"
        .Impedance "50"
        .SetP1 "False", "6.50", "9", "cu_top"
        .SetP2 "False", "6.50", "9", "z_l2_top"
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
