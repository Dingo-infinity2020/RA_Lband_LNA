#!/usr/bin/env python3
from pathlib import Path
import zipfile, sys

ROOT=Path(__file__).resolve().parents[1]
SRC=Path(sys.argv[1]) if len(sys.argv)>1 else ROOT/'manufacturing'/'RA-LNA-L1_V1.0C_main_Gerbers.zip'
DST=ROOT/'manufacturing'/'V1.0D'
DST.mkdir(parents=True,exist_ok=True)
tmp=ROOT/'source'/'_v1c_extract'
if tmp.exists():
    import shutil; shutil.rmtree(tmp)
tmp.mkdir()
with zipfile.ZipFile(SRC) as z: z.extractall(tmp)

# Patch two real VIN5 copper continuity gaps in V1.0C.
f=tmp/'RA-LNA-L1_V1.0C-F_Cu.gbr'
s=f.read_text()
# J3 +5 V pad begins at y=14.1; bus stopped at y=14.0. Extend by 0.2 mm for 0.1 mm overlap.
s=s.replace('X16800000Y14000000D01*\nX17200000Y14000000D01*',
            'X16800000Y14200000D01*\nX17200000Y14200000D01*')
# C8 VIN pad begins at y=11.325; copper neck stopped at y=11.225. Extend to y=11.425.
s=s.replace('X14300000Y11225000D02*\nX14700000Y11225000D01*\nX14700000Y10975000D01*\nX14300000Y10975000D01*\nX14300000Y11225000D01*',
            'X14300000Y11425000D02*\nX14700000Y11425000D01*\nX14700000Y10975000D01*\nX14300000Y10975000D01*\nX14300000Y11425000D01*')
# Add a tented GND via tongue for the previously via-less J1 upper SMA ground land.
insert='''\nG36*\nX3600000Y11600000D02*\nX4550000Y11600000D01*\nX4550000Y12000000D01*\nX3600000Y12000000D01*\nX3600000Y11600000D01*\nG37*\n'''
s=s.replace('M02*',insert+'M02*')
f.write_text(s)

# Mirror the J1 upper-ground via tongue on bottom copper so the PTH has an annulus on both sides.
b=tmp/'RA-LNA-L1_V1.0C-B_Cu.gbr'
s=b.read_text()
s=s.replace('M02*',insert+'M02*')
b.write_text(s)

# Add a 0.35 mm plated through via at x=4.25, y=11.80 mm.
d=tmp/'RA-LNA-L1_V1.0C-PTH.drl'
s=d.read_text()
needle='T02\n'
if 'X4.250Y11.800' not in s:
    s=s.replace(needle,needle+'X4.250Y11.800\n',1)
d.write_text(s)

mapping={
 'RA-LNA-L1_V1.0C-F_Cu.gbr':'RA-LNA-L1_V1.0D.GTL',
 'RA-LNA-L1_V1.0C-In1_GND.gbr':'RA-LNA-L1_V1.0D.G2L',
 'RA-LNA-L1_V1.0C-In2_GND.gbr':'RA-LNA-L1_V1.0D.G3L',
 'RA-LNA-L1_V1.0C-B_Cu.gbr':'RA-LNA-L1_V1.0D.GBL',
 'RA-LNA-L1_V1.0C-F_Mask.gbr':'RA-LNA-L1_V1.0D.GTS',
 'RA-LNA-L1_V1.0C-B_Mask.gbr':'RA-LNA-L1_V1.0D.GBS',
 'RA-LNA-L1_V1.0C-F_Paste.gbr':'RA-LNA-L1_V1.0D.GTP',
 'RA-LNA-L1_V1.0C-F_Silkscreen.gbr':'RA-LNA-L1_V1.0D.GTO',
 'RA-LNA-L1_V1.0C-Edge_Cuts.gbr':'RA-LNA-L1_V1.0D.GKO',
 'RA-LNA-L1_V1.0C-PTH.drl':'RA-LNA-L1_V1.0D.XLN',
}
attrs={
 '.GTL':['%TF.GenerationSoftware,OpenAI,RA-LNA-L1,V1.0D*%','%TF.FileFunction,Copper,L1,Top*%','%TF.FilePolarity,Positive*%'],
 '.G2L':['%TF.GenerationSoftware,OpenAI,RA-LNA-L1,V1.0D*%','%TF.FileFunction,Copper,L2,Inr*%','%TF.FilePolarity,Positive*%'],
 '.G3L':['%TF.GenerationSoftware,OpenAI,RA-LNA-L1,V1.0D*%','%TF.FileFunction,Copper,L3,Inr*%','%TF.FilePolarity,Positive*%'],
 '.GBL':['%TF.GenerationSoftware,OpenAI,RA-LNA-L1,V1.0D*%','%TF.FileFunction,Copper,L4,Bot*%','%TF.FilePolarity,Positive*%'],
 '.GTS':['%TF.GenerationSoftware,OpenAI,RA-LNA-L1,V1.0D*%','%TF.FileFunction,Soldermask,Top*%'],
 '.GBS':['%TF.GenerationSoftware,OpenAI,RA-LNA-L1,V1.0D*%','%TF.FileFunction,Soldermask,Bot*%'],
 '.GTP':['%TF.GenerationSoftware,OpenAI,RA-LNA-L1,V1.0D*%','%TF.FileFunction,Paste,Top*%'],
 '.GTO':['%TF.GenerationSoftware,OpenAI,RA-LNA-L1,V1.0D*%','%TF.FileFunction,Legend,Top*%'],
 '.GKO':['%TF.GenerationSoftware,OpenAI,RA-LNA-L1,V1.0D*%','%TF.FileFunction,Profile,NP*%'],
}
for src,dst in mapping.items():
    data=(tmp/src).read_text().replace('V1.0C','V1.0D')
    q=DST/dst
    if not dst.endswith('.XLN'):
        lines=data.splitlines()
        lines=[lines[0]]+attrs[Path(dst).suffix.upper()]+lines[1:]
        data='\n'.join(lines)+'\n'
    q.write_text(data)

for fn in ('BOM_JLC.csv','CPL_JLC.csv'):
    src=ROOT/'manufacturing'/'main'/fn
    if src.exists(): (DST/fn).write_bytes(src.read_bytes())

zipout=ROOT/'manufacturing'/'RA-LNA-L1_V1.0D_main_Gerbers.zip'
with zipfile.ZipFile(zipout,'w',zipfile.ZIP_DEFLATED) as z:
    for p in sorted(DST.iterdir()):
        if p.suffix.upper() in {'.GTL','.G2L','.G3L','.GBL','.GTS','.GBS','.GTP','.GTO','.GKO','.XLN'}:
            z.write(p,p.name)
print(zipout)
