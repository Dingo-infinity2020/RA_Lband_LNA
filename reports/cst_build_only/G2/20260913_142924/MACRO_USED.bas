Option Explicit

' RA-LNA-L1 V1.0F — CST G2 replay-safe BUILD-ONLY structure macro v2
' CST Studio Suite 2022
'
' PURPOSE
'   Build U1 Pin-7 output path, C2, long 50-ohm line, output SMA launch,
'   and the nominal output-bias branch loading.
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
        .Xrange "6.6", "26"
        .Yrange "3.8", "17.0"
        .Zrange "-h12", "0"
        .Create
    End With
    With Brick
        .Reset
        .Name "CORE"
        .Component "PCB"
        .Material "FR4_RA_LNA"
        .Xrange "6.6", "26"
        .Yrange "3.8", "17.0"
        .Zrange "z_core_bot", "z_l2_bot"
        .Create
    End With
    With Brick
        .Reset
        .Name "PP_BOTTOM"
        .Component "PCB"
        .Material "FR4_RA_LNA"
        .Xrange "6.6", "26"
        .Yrange "3.8", "17.0"
        .Zrange "z_bot_pp_bot", "z_l3_bot"
        .Create
    End With
    With Brick
        .Reset
        .Name "L2_GND"
        .Component "Planes"
        .Material "PEC"
        .Xrange "6.6", "26"
        .Yrange "3.8", "17.0"
        .Zrange "z_l2_bot", "z_l2_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "L3_GND"
        .Component "Planes"
        .Material "PEC"
        .Xrange "6.6", "26"
        .Yrange "3.8", "17.0"
        .Zrange "z_l3_bot", "z_l3_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "L4_GND"
        .Component "Planes"
        .Material "PEC"
        .Xrange "6.6", "26"
        .Yrange "3.8", "17.0"
        .Zrange "z_bot_cu_min", "z_bot_cu_max"
        .Create
    End With

    With Brick
        .Reset
        .Name "J2_SIG"
        .Component "Top"
        .Material "PEC"
        .Xrange "22.19", "26"
        .Yrange "8.40", "9.60"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "J2_TAPER_0"
        .Component "Top"
        .Material "PEC"
        .Xrange "21.65", "21.68375"
        .Yrange "9-(trace_w+1*(1.20-trace_w)/16)/2", "9+(trace_w+1*(1.20-trace_w)/16)/2"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "J2_TAPER_1"
        .Component "Top"
        .Material "PEC"
        .Xrange "21.68375", "21.7175"
        .Yrange "9-(trace_w+2*(1.20-trace_w)/16)/2", "9+(trace_w+2*(1.20-trace_w)/16)/2"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "J2_TAPER_2"
        .Component "Top"
        .Material "PEC"
        .Xrange "21.7175", "21.75125"
        .Yrange "9-(trace_w+3*(1.20-trace_w)/16)/2", "9+(trace_w+3*(1.20-trace_w)/16)/2"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "J2_TAPER_3"
        .Component "Top"
        .Material "PEC"
        .Xrange "21.75125", "21.785"
        .Yrange "9-(trace_w+4*(1.20-trace_w)/16)/2", "9+(trace_w+4*(1.20-trace_w)/16)/2"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "J2_TAPER_4"
        .Component "Top"
        .Material "PEC"
        .Xrange "21.785", "21.81875"
        .Yrange "9-(trace_w+5*(1.20-trace_w)/16)/2", "9+(trace_w+5*(1.20-trace_w)/16)/2"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "J2_TAPER_5"
        .Component "Top"
        .Material "PEC"
        .Xrange "21.81875", "21.8525"
        .Yrange "9-(trace_w+6*(1.20-trace_w)/16)/2", "9+(trace_w+6*(1.20-trace_w)/16)/2"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "J2_TAPER_6"
        .Component "Top"
        .Material "PEC"
        .Xrange "21.8525", "21.88625"
        .Yrange "9-(trace_w+7*(1.20-trace_w)/16)/2", "9+(trace_w+7*(1.20-trace_w)/16)/2"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "J2_TAPER_7"
        .Component "Top"
        .Material "PEC"
        .Xrange "21.88625", "21.92"
        .Yrange "9-(trace_w+8*(1.20-trace_w)/16)/2", "9+(trace_w+8*(1.20-trace_w)/16)/2"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "J2_TAPER_8"
        .Component "Top"
        .Material "PEC"
        .Xrange "21.92", "21.95375"
        .Yrange "9-(trace_w+9*(1.20-trace_w)/16)/2", "9+(trace_w+9*(1.20-trace_w)/16)/2"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "J2_TAPER_9"
        .Component "Top"
        .Material "PEC"
        .Xrange "21.95375", "21.9875"
        .Yrange "9-(trace_w+10*(1.20-trace_w)/16)/2", "9+(trace_w+10*(1.20-trace_w)/16)/2"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "J2_TAPER_10"
        .Component "Top"
        .Material "PEC"
        .Xrange "21.9875", "22.02125"
        .Yrange "9-(trace_w+11*(1.20-trace_w)/16)/2", "9+(trace_w+11*(1.20-trace_w)/16)/2"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "J2_TAPER_11"
        .Component "Top"
        .Material "PEC"
        .Xrange "22.02125", "22.055"
        .Yrange "9-(trace_w+12*(1.20-trace_w)/16)/2", "9+(trace_w+12*(1.20-trace_w)/16)/2"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "J2_TAPER_12"
        .Component "Top"
        .Material "PEC"
        .Xrange "22.055", "22.08875"
        .Yrange "9-(trace_w+13*(1.20-trace_w)/16)/2", "9+(trace_w+13*(1.20-trace_w)/16)/2"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "J2_TAPER_13"
        .Component "Top"
        .Material "PEC"
        .Xrange "22.08875", "22.1225"
        .Yrange "9-(trace_w+14*(1.20-trace_w)/16)/2", "9+(trace_w+14*(1.20-trace_w)/16)/2"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "J2_TAPER_14"
        .Component "Top"
        .Material "PEC"
        .Xrange "22.1225", "22.15625"
        .Yrange "9-(trace_w+15*(1.20-trace_w)/16)/2", "9+(trace_w+15*(1.20-trace_w)/16)/2"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "J2_TAPER_15"
        .Component "Top"
        .Material "PEC"
        .Xrange "22.15625", "22.19"
        .Yrange "9-(trace_w+16*(1.20-trace_w)/16)/2", "9+(trace_w+16*(1.20-trace_w)/16)/2"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "J2_GND_LO"
        .Component "Top"
        .Material "PEC"
        .Xrange "22.19", "26"
        .Yrange "4.85", "7.55"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "J2_GND_HI"
        .Component "Top"
        .Material "PEC"
        .Xrange "22.19", "26"
        .Yrange "10.45", "13.15"
        .Zrange "0", "cu_top"
        .Create
    End With

    With Cylinder
        .Reset
        .Name "J2_V1"
        .Component "Vias"
        .Material "PEC"
        .OuterRadius "(0.35)/2"
        .InnerRadius "0"
        .Axis "z"
        .Zrange "z_bot_cu_min", "cu_top"
        .Xcenter "23.6"
        .Ycenter "7.9"
        .Segments "0"
        .Create
    End With
    With Cylinder
        .Reset
        .Name "J2_V2"
        .Component "Vias"
        .Material "PEC"
        .OuterRadius "(0.35)/2"
        .InnerRadius "0"
        .Axis "z"
        .Zrange "z_bot_cu_min", "cu_top"
        .Xcenter "23.6"
        .Ycenter "10.1"
        .Segments "0"
        .Create
    End With
    With Cylinder
        .Reset
        .Name "J2_V3"
        .Component "Vias"
        .Material "PEC"
        .OuterRadius "(0.35)/2"
        .InnerRadius "0"
        .Axis "z"
        .Zrange "z_bot_cu_min", "cu_top"
        .Xcenter "24.9"
        .Ycenter "7.9"
        .Segments "0"
        .Create
    End With
    With Cylinder
        .Reset
        .Name "J2_V4"
        .Component "Vias"
        .Material "PEC"
        .OuterRadius "(0.35)/2"
        .InnerRadius "0"
        .Axis "z"
        .Zrange "z_bot_cu_min", "cu_top"
        .Xcenter "24.9"
        .Ycenter "10.1"
        .Segments "0"
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
        .Xrange "8.40", "9.00"
        .Yrange "11.30", "11.85"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "C5_PAD_GND"
        .Component "Top"
        .Material "PEC"
        .Xrange "8.40", "9.00"
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
        .Xrange "9.50", "10.10"
        .Yrange "11.30", "11.85"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "C3_PAD_GND"
        .Component "Top"
        .Material "PEC"
        .Xrange "9.50", "10.10"
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
        .Xrange "10.60", "11.20"
        .Yrange "11.30", "11.85"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "C4_PAD_GND"
        .Component "Top"
        .Material "PEC"
        .Xrange "10.60", "11.20"
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

    With Brick
        .Reset
        .Name "RF_OUT_PRE_C2"
        .Component "Top"
        .Material "PEC"
        .Xrange "8.115", "8.90"
        .Yrange "9-trace_w/2", "9+trace_w/2"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "C2_PAD1"
        .Component "Top"
        .Material "PEC"
        .Xrange "8.90", "9.45"
        .Yrange "8.70", "9.30"
        .Zrange "0", "cu_top"
        .Create
    End With
    With Brick
        .Reset
        .Name "C2_PAD2"
        .Component "Top"
        .Material "PEC"
        .Xrange "9.75", "10.30"
        .Yrange "8.70", "9.30"
        .Zrange "0", "cu_top"
        .Create
    End With
    With LumpedElement
        .Reset
        .SetName "C2_100pF"
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
        .SetP1 "False", "9.45", "9", "cu_top"
        .SetP2 "False", "9.75", "9", "cu_top"
        .SetInvert "False"
        .Wire ""
        .Position "end1"
        .Create
    End With
    With Brick
        .Reset
        .Name "RF_OUT_LINE"
        .Component "Top"
        .Material "PEC"
        .Xrange "10.30", "22.80"
        .Yrange "9-trace_w/2", "9+trace_w/2"
        .Zrange "0", "cu_top"
        .Create
    End With

    With Cylinder
        .Reset
        .Name "GF_L1"
        .Component "Vias"
        .Material "PEC"
        .OuterRadius "(0.35)/2"
        .InnerRadius "0"
        .Axis "z"
        .Zrange "z_bot_cu_min", "cu_top"
        .Xcenter "10.8"
        .Ycenter "7.55"
        .Segments "0"
        .Create
    End With
    With Cylinder
        .Reset
        .Name "GF_L2"
        .Component "Vias"
        .Material "PEC"
        .OuterRadius "(0.35)/2"
        .InnerRadius "0"
        .Axis "z"
        .Zrange "z_bot_cu_min", "cu_top"
        .Xcenter "12.5"
        .Ycenter "7.55"
        .Segments "0"
        .Create
    End With
    With Cylinder
        .Reset
        .Name "GF_L3"
        .Component "Vias"
        .Material "PEC"
        .OuterRadius "(0.35)/2"
        .InnerRadius "0"
        .Axis "z"
        .Zrange "z_bot_cu_min", "cu_top"
        .Xcenter "14.3"
        .Ycenter "7.55"
        .Segments "0"
        .Create
    End With
    With Cylinder
        .Reset
        .Name "GF_L4"
        .Component "Vias"
        .Material "PEC"
        .OuterRadius "(0.35)/2"
        .InnerRadius "0"
        .Axis "z"
        .Zrange "z_bot_cu_min", "cu_top"
        .Xcenter "16.1"
        .Ycenter "7.55"
        .Segments "0"
        .Create
    End With
    With Cylinder
        .Reset
        .Name "GF_L5"
        .Component "Vias"
        .Material "PEC"
        .OuterRadius "(0.35)/2"
        .InnerRadius "0"
        .Axis "z"
        .Zrange "z_bot_cu_min", "cu_top"
        .Xcenter "17.9"
        .Ycenter "7.55"
        .Segments "0"
        .Create
    End With
    With Cylinder
        .Reset
        .Name "GF_L6"
        .Component "Vias"
        .Material "PEC"
        .OuterRadius "(0.35)/2"
        .InnerRadius "0"
        .Axis "z"
        .Zrange "z_bot_cu_min", "cu_top"
        .Xcenter "19.7"
        .Ycenter "7.55"
        .Segments "0"
        .Create
    End With
    With Cylinder
        .Reset
        .Name "GF_L7"
        .Component "Vias"
        .Material "PEC"
        .OuterRadius "(0.35)/2"
        .InnerRadius "0"
        .Axis "z"
        .Zrange "z_bot_cu_min", "cu_top"
        .Xcenter "21.5"
        .Ycenter "7.55"
        .Segments "0"
        .Create
    End With
    With Cylinder
        .Reset
        .Name "GF_U1"
        .Component "Vias"
        .Material "PEC"
        .OuterRadius "(0.35)/2"
        .InnerRadius "0"
        .Axis "z"
        .Zrange "z_bot_cu_min", "cu_top"
        .Xcenter "15.8"
        .Ycenter "10.25"
        .Segments "0"
        .Create
    End With
    With Cylinder
        .Reset
        .Name "GF_U2"
        .Component "Vias"
        .Material "PEC"
        .OuterRadius "(0.35)/2"
        .InnerRadius "0"
        .Axis "z"
        .Zrange "z_bot_cu_min", "cu_top"
        .Xcenter "17.6"
        .Ycenter "10.25"
        .Segments "0"
        .Create
    End With
    With Cylinder
        .Reset
        .Name "GF_U3"
        .Component "Vias"
        .Material "PEC"
        .OuterRadius "(0.35)/2"
        .InnerRadius "0"
        .Axis "z"
        .Zrange "z_bot_cu_min", "cu_top"
        .Xcenter "19.4"
        .Ycenter "10.25"
        .Segments "0"
        .Create
    End With
    With Cylinder
        .Reset
        .Name "GF_U4"
        .Component "Vias"
        .Material "PEC"
        .OuterRadius "(0.35)/2"
        .InnerRadius "0"
        .Axis "z"
        .Zrange "z_bot_cu_min", "cu_top"
        .Xcenter "21.2"
        .Ycenter "10.25"
        .Segments "0"
        .Create
    End With
    With Cylinder
        .Reset
        .Name "GF_U5"
        .Component "Vias"
        .Material "PEC"
        .OuterRadius "(0.35)/2"
        .InnerRadius "0"
        .Axis "z"
        .Zrange "z_bot_cu_min", "cu_top"
        .Xcenter "22.7"
        .Ycenter "10.25"
        .Segments "0"
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
        .SetP1 "False", "25.75", "9", "cu_top"
        .SetP2 "False", "25.75", "9", "z_l2_top"
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
