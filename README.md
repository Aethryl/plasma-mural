# plasma-mural

Wallpaper rotation for the Plasma 6 desktop and lock screen: a panel widget plus the `mural` CLI behind it.

- The bar shows the next wallpaper; the notch shows now-showing, up-next, skip, remove and delete.
- "Manage..." opens a full manager window (`plasmawindowed io.github.aethryl.mural`).
- Images are grouped in collections, fetched from a manifest and kept in `$MURAL_LIBRARY/<collection>/`.

## Install

```sh
git clone git@github.com:Aethryl/plasma-mural.git
cd plasma-mural
./install.sh
gdbus call --session -d org.kde.plasmashell -o /PlasmaShell \
  -m org.kde.PlasmaShell.evaluateScript "$(cat add-to-panel.js)"
mural fetch
```

`install.sh` symlinks `plasmoid/` into `${XDG_DATA_HOME:-~/.local/share}/plasma/plasmoids/io.github.aethryl.mural` and `bin/mural` into `~/.local/bin/mural`, so edits are live. After a QML change run `systemctl --user restart plasma-plasmashell`. Instead of the gdbus call you can add "Mural" through the panel's edit mode.

## CLI

`mural <command>`: `status`, `list`, `next`, `skip`, `resume`, `on`, `off`, `fetch`, `collection <name|all>`, `interval <minutes>`, `lockscreen on|off`, `exclude|include|delete [ids]`, `move <collection> <ids>`, `mkcol`, `rename`, `rmcol [--into <collection>]`. Most print the state as JSON.

| Variable | Default | Meaning |
|---|---|---|
| `MURAL_MANIFEST` | `~/Repos/rice/wallpapers/collection.json` | collection manifest |
| `MURAL_LIBRARY` | `~/Pictures/Wallpapers` | where images are stored, one folder per collection |
| `XDG_STATE_HOME` | `~/.local/state` | state lives in `mural/state.json` |

The default manifest path is the author's private wallpapers repo; set `MURAL_MANIFEST` to your own file. The widget calls `~/.local/bin/mural` (or `mural` on `PATH`), so export the variable where plasmashell sees it, for example in `~/.config/plasma-workspace/env/mural.sh`.

## Manifest format

`collection.json` is a JSON array; `mural fetch` downloads every entry that is not yet in the library.

```json
[
  {
    "id": "mount-fuji-dawn",
    "collection": "landscapes",
    "title": "Mount Fuji at dawn",
    "source": "Jane Doe",
    "page": "https://commons.wikimedia.org/wiki/File:Fuji.jpg",
    "license": "CC BY-SA 4.0",
    "url": "https://upload.wikimedia.org/wikipedia/commons/a/ab/Fuji.jpg"
  },
  {
    "id": "my-own-picture",
    "collection": "mine",
    "title": "My picture",
    "file": "own/mine/picture.png"
  }
]
```

| Field | Required | Meaning |
|---|---|---|
| `id` | yes | unique key, becomes the file name |
| `collection` | yes | folder name (letters, digits, space, `.`, `_`, `-`, max 48 chars; not `all`) |
| `url` | one of url/file | download address |
| `file` | one of url/file | path relative to the manifest's folder, copied instead of downloaded |
| `title` | no | shown in the widget, defaults to `id` |
| `source`, `page`, `license` | no | attribution; `source` and `page` are shown in the widget |

Wikimedia Commons URLs are fetched as 3840 or 2560 px thumbnails when possible. Images below 2560x1440 are rejected; images above 5160 px on the long side are scaled down (pixel-art collections are shrunk with a point filter). `delete`, `move` and `rename` also update the manifest.

## Requirements

- Plasma 6 (tested on 6.7.5)
- `plasma-sdk` for the manager window (`plasmawindowed`)
- Python 3, ImageMagick (`magick`), `gio` or `kioclient`, `plasma-apply-wallpaperimage`, `kwriteconfig6`

## Licence

The code is MIT, see `LICENSE`. No images are shipped; they are fetched at runtime from the URLs in your manifest (the author's use Wikimedia Commons), each under its own licence.
