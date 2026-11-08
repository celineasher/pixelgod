# PIXEL GOD

Menu for Pixel Basketball: auto green release, auto crossover dribble, auto shoot.
Drag by the header, `RightShift` to hide/show, `X` to close to header.

## Loadstring

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/celineasher/pixelgod/main/pixelgod.lua"))()
```

Cache-busted:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/celineasher/pixelgod/main/pixelgod.lua?t=" .. os.time()))()
```

## Controls

| Control | Action |
| --- | --- |
| AUTO GREEN | Perfect meter release at your GREEN BIAS |
| AUTO DRIBBLE | Crossover on cooldown whenever gas allows |
| AUTO SHOOT | Press shoot when open and within range |
| GREEN BIAS +/- | Shift the release point (0.015 - 0.085) |
| ALL OFF | Disable every assist |

## Notes

- Session is discovered by scanning `getgc(true)` for the live match object; no hooks are installed.
- Reloading is safe: the script disconnects its previous connections and destroys its GUI before rebuilding.
