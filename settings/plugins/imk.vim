function! IndentMarkdownLivePreview()
python3 << EOF

import vim
import os
import pathlib
import json
import platform
from urllib.parse import urlencode
from urllib.request import Request, urlopen

imkurl = 'http://0.0.0.0:8000'

def add_preview_task(imkpath):
    url = f'{imkurl}/api/add_preview_task'
    data = {
        "fspath": imkpath,
    }
    postdata = urlencode(data).encode()
    headers = { "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8" }
    httprequest = Request(url, method="POST", data=postdata, headers=headers)
    with urlopen(httprequest) as response:
        return response.read().decode()

def open_live_preview(liveid):
    if not str(liveid).isdigit():
        print("[x] Don't be evil ...")
        return

    liveurl = f'"{imkurl}/api/preview/{liveid}"'
    osname = platform.system()
    if osname == 'Windows':
        os.system(f'cmd.exe /c start "" {liveurl}')
    elif osname == 'Darwin':
        os.system(f'open {liveurl}')
    elif osname == 'Linux':
        os.system(f'xdg-open {liveurl}')
    else:
        print(f'[x] IMK vim plugin does not live preview on this platform [{osname}], open {liveurl} manually')

fname = pathlib.Path(vim.eval("expand('%:p')"))
if fname.suffix == ".imk":
    try:
        resp = json.loads(add_preview_task(str(fname)))
        if resp['errcode'] != 0:
            print('[x] failed to parse imk file')
        else:
            open_live_preview(resp['id'])
    except Exception as e:
        print(f'[x] imk request failed with error: {e}')

EOF
endfunction

command! IMK call IndentMarkdownLivePreview()
