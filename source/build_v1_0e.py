#!/usr/bin/env python3
from pathlib import Path
import zipfile, tempfile, shutil

ROOT = Path(__file__).resolve().parents[1]
SRC_ZIP = ROOT / 'manufacturing' / 'RA-LNA-L1_V1.0D_main_Gerbers.zip'
DST = ROOT / 'manufacturing' / 'V1.0E'
DST.mkdir(parents=True, exist_ok=True)

with tempfile.TemporaryDirectory() as td:
    td = Path(td)
    with zipfile.ZipFile(SRC_ZIP) as z:
        z.extractall(td)
    for src in td.iterdir():
        if not src.is_file():
            continue
        out = DST / src.name.replace('V1.0D', 'V1.0E')
        text = src.read_text().replace('V1.0D', 'V1.0E')
        if out.suffix.upper() == '.XLN':
            lines = [ln for ln in text.splitlines()
                     if ln not in {'X3.700Y7.550', 'X22.700Y7.550'}]
            text = '\n'.join(lines) + '\n'
        out.write_text(text)

for fn in ('BOM_JLC.csv', 'CPL_JLC.csv', 'LAYER_MAP.md'):
    src = ROOT / 'manufacturing' / 'V1.0D' / fn
    if src.exists():
        dst = DST / fn
        if src.suffix == '.md':
            dst.write_text(src.read_text().replace('V1.0D', 'V1.0E'))
        else:
            shutil.copy2(src, dst)

zipout = ROOT / 'manufacturing' / 'RA-LNA-L1_V1.0E_main_Gerbers.zip'
with zipfile.ZipFile(zipout, 'w', zipfile.ZIP_DEFLATED) as z:
    for p in sorted(DST.glob('RA-LNA-L1_V1.0E.*')):
        if p.suffix.upper() in {'.GTL','.G2L','.G3L','.GBL','.GTS','.GBS','.GTP','.GTO','.GKO','.XLN'}:
            z.write(p, p.name)
print(zipout)
