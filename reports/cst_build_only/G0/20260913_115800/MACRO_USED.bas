Option Explicit

' RA-LNA-L1 V1.0F pre-fabrication CST gate ??BUILD ONLY
' CST Studio Suite 2022 VBA macro.
'
' HARD RULE:
'   This macro MUST NOT start any solver, parameter sweep, optimizer, or simulation.
'   It only builds geometry/materials/ports and sets a nominal frequency range.
'
' Stack-up baseline: JLC04161H-3313
' L1 Cu 0.035 mm / 3313 0.0994 mm / L2 Cu 0.0152 mm /
' core 1.265 mm / L3 Cu 0.0152 mm / 3313 0.0994 mm / L4 Cu 0.035 mm.
'
' Coordinate convention:
'   PCB x: 0..26 mm, y: 0..18 mm.
'   top dielectric surface z=0; top copper occupies z=0..cu_top.
'
' Connector model:
'   PCB-side CON-SMA-EDGE-S launch surrogate only.
'   The vendor coax body is intentionally NOT invented in this model.

' G0: environment/API preflight. This is deliberately tiny.
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

    SetCommonUnitsAndMaterials
    Solver.FrequencyRange "0.5", "3.0"
    BuildStack "0", "8", "0", "6"
    AddBrickPEC "TRACE", "Top", "1", "7", "3-trace_w/2", "3+trace_w/2", "0", "cu_top"
    AddDiscretePortToL2 1, "1.2", "3"
    AddDiscretePortToL2 2, "6.8", "3"
    SetOpenBoundaries
    MsgBox "G0 BUILD ONLY complete. Do not solve yet. Confirm geometry, ports and stack-up."
End Sub

Private Sub SetCommonUnitsAndMaterials()
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
End Sub

Private Sub SetOpenBoundaries()
    With Boundary
        .Xmin "expanded open"
        .Xmax "expanded open"
        .Ymin "expanded open"
        .Ymax "expanded open"
        .Zmin "expanded open"
        .Zmax "expanded open"
    End With
End Sub

Private Sub AddBrickPEC(ByVal nm As String, ByVal comp As String, _
                        ByVal x1 As String, ByVal x2 As String, _
                        ByVal y1 As String, ByVal y2 As String, _
                        ByVal z1 As String, ByVal z2 As String)
    With Brick
        .Reset
        .Name nm
        .Component comp
        .Material "PEC"
        .Xrange x1, x2
        .Yrange y1, y2
        .Zrange z1, z2
        .Create
    End With
End Sub

Private Sub AddBrickFR4(ByVal nm As String, _
                        ByVal x1 As String, ByVal x2 As String, _
                        ByVal y1 As String, ByVal y2 As String, _
                        ByVal z1 As String, ByVal z2 As String)
    With Brick
        .Reset
        .Name nm
        .Component "PCB"
        .Material "FR4_RA_LNA"
        .Xrange x1, x2
        .Yrange y1, y2
        .Zrange z1, z2
        .Create
    End With
End Sub

Private Sub AddVia(ByVal nm As String, ByVal x As String, ByVal y As String, ByVal dia As String)
    With Cylinder
        .Reset
        .Name nm
        .Component "Vias"
        .Material "PEC"
        .OuterRadius "(" & dia & ")/2"
        .InnerRadius "0"
        .Axis "z"
        .Zrange "z_bot_cu_min", "cu_top"
        .Xcenter x
        .Ycenter y
        .Segments "0"
        .Create
    End With
End Sub

Private Sub AddDiscretePortToL2(ByVal pn As Integer, ByVal x As String, ByVal y As String)
    With DiscretePort
        .Reset
        .PortNumber CStr(pn)
        .Type "SParameter"
        .Impedance "50"
        .SetP1 "False", x, y, "cu_top"
        .SetP2 "False", x, y, "z_l2_top"
        .Create
    End With
End Sub

Private Sub AddSeriesLumped(ByVal nm As String, ByVal rSI As String, ByVal lSI As String, ByVal cSI As String, _
                            ByVal x1 As String, ByVal y1 As String, ByVal z1 As String, _
                            ByVal x2 As String, ByVal y2 As String, ByVal z2 As String)
    With LumpedElement
        .Reset
        .SetName nm
        .Folder "Lumped"
        .SetType "RLCSerial"
        .SetR rSI
        .SetL lSI
        .SetC cSI
        .SetGs "0"
        .SetI0 "0"
        .SetT "0"
        .SetMonitor "True"
        .SetRadius "0.04"
        .CircuitFileName ""
        .CircuitId "1"
        .UseCopyOnly "True"
        .UseRelativePath "False"
        .SetP1 "False", x1, y1, z1
        .SetP2 "False", x2, y2, z2
        .SetInvert "False"
        .Wire ""
        .Position "end1"
        .Create
    End With
End Sub

Private Sub BuildStack(ByVal x1 As String, ByVal x2 As String, ByVal y1 As String, ByVal y2 As String)
    ' Dielectric regions.
    AddBrickFR4 "PP_TOP", x1, x2, y1, y2, "-h12", "0"
    AddBrickFR4 "CORE", x1, x2, y1, y2, "z_core_bot", "z_l2_bot"
    AddBrickFR4 "PP_BOTTOM", x1, x2, y1, y2, "z_bot_pp_bot", "z_l3_bot"

    ' Continuous ground planes L2/L3 and bottom ground.
    AddBrickPEC "L2_GND", "Planes", x1, x2, y1, y2, "z_l2_bot", "z_l2_top"
    AddBrickPEC "L3_GND", "Planes", x1, x2, y1, y2, "z_l3_bot", "z_l3_top"
    AddBrickPEC "L4_GND", "Planes", x1, x2, y1, y2, "z_bot_cu_min", "z_bot_cu_max"
End Sub

Private Sub AddLeftLaunch()
    ' Signal contact land and 16-step taper.
    AddBrickPEC "J1_SIG", "Top", "0", "3.81", "8.40", "9.60", "0", "cu_top"
    Dim k As Integer
    Dim xa As Double, xb As Double, ww As Double, tw As Double
    tw = RestoreDoubleParameter("trace_w")
    For k = 0 To 15
        xa = 3.81 + k*(0.54/16)
        xb = 3.81 + (k+1)*(0.54/16)
        ww = 1.20 - (k+1)*(1.20-tw)/16
        AddBrickPEC "J1_TAPER_" & CStr(k), "Top", CStr(xa), CStr(xb), _
                    CStr(9-ww/2), CStr(9+ww/2), "0", "cu_top"
    Next k
    AddBrickPEC "J1_GND_LO", "Top", "0", "3.81", "4.85", "7.55", "0", "cu_top"
    AddBrickPEC "J1_GND_HI", "Top", "0", "3.81", "10.45", "13.15", "0", "cu_top"
    AddVia "J1_V1", "1.1", "7.9", "0.35"
    AddVia "J1_V2", "1.1", "10.1", "0.35"
    AddVia "J1_V3", "2.4", "7.9", "0.35"
    AddVia "J1_V4", "2.4", "10.1", "0.35"
End Sub

Private Sub AddRightLaunch()
    AddBrickPEC "J2_SIG", "Top", "22.19", "26", "8.40", "9.60", "0", "cu_top"
    Dim k As Integer
    Dim xa As Double, xb As Double, ww As Double, tw As Double
    tw = RestoreDoubleParameter("trace_w")
    For k = 0 To 15
        xa = 21.65 + k*(0.54/16)
        xb = 21.65 + (k+1)*(0.54/16)
        ww = tw + (k+1)*(1.20-tw)/16
        AddBrickPEC "J2_TAPER_" & CStr(k), "Top", CStr(xa), CStr(xb), _
                    CStr(9-ww/2), CStr(9+ww/2), "0", "cu_top"
    Next k
    AddBrickPEC "J2_GND_LO", "Top", "22.19", "26", "4.85", "7.55", "0", "cu_top"
    AddBrickPEC "J2_GND_HI", "Top", "22.19", "26", "10.45", "13.15", "0", "cu_top"
    AddVia "J2_V1", "23.6", "7.9", "0.35"
    AddVia "J2_V2", "23.6", "10.1", "0.35"
    AddVia "J2_V3", "24.9", "7.9", "0.35"
    AddVia "J2_V4", "24.9", "10.1", "0.35"
End Sub

