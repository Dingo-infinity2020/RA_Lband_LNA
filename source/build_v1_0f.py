#!/usr/bin/env python3
"""Derive V1.0F from V1.0E by removing silkscreen features that encroach on SMT solder lands.

V1.0F makes no copper, mask, paste, drill, stack-up, BOM, or placement changes relative to V1.0E.
Only the top legend (.GTO) changes:
  * remove the rectangular shield-can/keepout outline that crosses the C2-side SMT pad region;
  * remove the circular pin-1 legend marker near U1 because it lands too close to/over an exposed pad in JLC preview.
The IN/OUT arrows and +5 V polarity mark remain.
"""
from pathlib import Path
import zipfile, shutil, sys

ROOT = Path(__file__).resolve().parents[1]
SRC = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / 'manufacturing' / 'RA-LNA-L1_V1.0E_main_Gerbers.zip'
DST = ROOT / 'manufacturing' / 'V1.0F'
TMP = ROOT / 'source' / '_v1e_extract'
ZIPOUT = ROOT / 'manufacturing' / 'RA-LNA-L1_V1.0F_main_Gerbers.zip'

if TMP.exists():
    shutil.rmtree(TMP)
TMP.mkdir(parents=True)
DST.mkdir(parents=True, exist_ok=True)
with zipfile.ZipFile(SRC) as z:
    z.extractall(TMP)

for p in TMP.iterdir():
    if p.is_file():
        q = DST / p.name.replace('V1.0E', 'V1.0F')
        q.write_text(p.read_text().replace('V1.0E', 'V1.0F'))

gto = DST / 'RA-LNA-L1_V1.0F.GTO'
s = gto.read_text()
rect = '''D10*\nX5100000Y5200000D02*\nX12600000Y5200000D01*\nD10*\nX12600000Y5200000D02*\nX12600000Y14000000D01*\nD10*\nX12600000Y14000000D02*\nX5100000Y14000000D01*\nD10*\nX5100000Y14000000D02*\nX5100000Y5200000D01*\n'''
if rect not in s:
    raise SystemExit('Expected shield-outline silkscreen block not found')
s = s.replace(rect, '')

marker_start = 'D10*\nX6810000Y9900000D02*\n'
i = s.find(marker_start)
if i < 0:
    raise SystemExit('Expected U1 pin-1 silkscreen marker not found')
j = s.find('M02*', i)
s = s[:i] + s[j:]
gto.write_text(s)

for old in TMP.iterdir():
    if not old.is_file():
        continue
    new = DST / old.name.replace('V1.0E', 'V1.0F')
    if new.suffix.upper() == '.GTO':
        continue
    expected = old.read_text().replace('V1.0E', 'V1.0F')
    if new.read_text() != expected:
        raise SystemExit(f'Unexpected non-silkscreen change: {new.name}')

with zipfile.ZipFile(ZIPOUT, 'w', zipfile.ZIP_DEFLATED) as z:
    for p in sorted(DST.iterdir()):
        if p.suffix.upper() in {'.GTL','.G2L','.G3L','.GBL','.GTS','.GBS','.GTP','.GTO','.GKO','.XLN'}:
            z.write(p, p.name)
print(ZIPOUT)
