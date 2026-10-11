# Python Cheatsheet

Editor keys (Neovim, pyright + ruff) and Python reference. See [cheatsheet.md](cheatsheet.md) for the full keymap list.

## Neovim Keys

| Action | How |
|--------|-----|
| Fill required constructor args | `<C-l>` in insert mode inside `Foo(|)`, or `<leader>fa` in normal mode |
| Find all usages | `grr` |
| Jump to definition | `grd` |
| Symbols in file / project | `gO` / `gW` |
| Type / docs under cursor | `K` (pyright; ruff hover is disabled) |
| Rename | `grn` |
| Code action (incl. ruff fixes) | `gra` |
| Format | `<leader>F` (ruff) |
| Diagnostics list | `<leader>q` |
| Signature help | `<C-k>` in insert mode (blink.cmp) |

## Tooling (terminal)

| Command | What it does |
|---------|--------------|
| `uv run python -m pytest -q` | Run tests in the project venv |
| `uv run pytest -k name -x` | Run tests matching `name`, stop at first failure |
| `uv run pytest --pdb` | Drop into debugger on failure |
| `ruff check --fix .` | Lint and auto-fix |
| `ruff format .` | Format |
| `pyright` | Full type check |
| `uv add pkg` / `uv sync` | Add dependency / sync venv from lock file |
| `python -m http.server 8000` | Quick static file server |

## Language Reference

### Dataclasses

```python
from dataclasses import dataclass, field

@dataclass(frozen=True, slots=True)
class Point:
    x: int
    y: int
    tags: list[str] = field(default_factory=list)  # mutable default
```

- `frozen=True` makes instances immutable and hashable.
- `slots=True` (3.10+) reduces memory and blocks typo'd attributes.
- Use `field(default_factory=...)` for mutable defaults, never `= []`.
- `dataclasses.replace(p, x=5)` returns a modified copy.
- `dataclasses.asdict(p)` converts to a dict.

### Typing

```python
def load(path: str | None = None) -> dict[str, int]: ...
```

- Builtin generics: `list[int]`, `dict[str, Any]` (no `typing.List` needed on 3.9+).
- Unions: `int | None` (3.10+).
- `Protocol` for structural typing; `TypedDict` for dict shapes.
- `from __future__ import annotations` defers annotation evaluation.

### Common idioms

```python
from pathlib import Path

text = Path("notes.txt").read_text()          # pathlib over os.path
for i, line in enumerate(lines, start=1): ... # enumerate
for a, b in zip(xs, ys): ...                  # zip
counts = {k: counts.get(k, 0) + 1 for k in ks} # dict comprehension
with open(p) as f: data = f.read()             # context managers
name = d.get("name", "default")               # dict.get with default
print(f"{value=:.2f}")                         # f-string with = debug
```

### Errors

```python
try:
    value = int(s)
except ValueError as exc:
    raise RuntimeError(f"bad input: {s!r}") from exc
```

- Use `raise ... from exc` to keep the cause chain.
- Catch the narrowest exception you can.

### Pattern matching (3.10+)

```python
match command:
    case {"action": "move", "dx": dx, "dy": dy}:
        move(dx, dy)
    case str() as s if s.startswith("#"):
        pass
    case _:
        raise ValueError(command)
```

### Async

```python
import asyncio

async def main() -> None:
    results = await asyncio.gather(fetch(a), fetch(b))

asyncio.run(main())
```

### Gotchas

- Mutable default args are shared across calls: `def f(x=[])` — use `None` and create inside.
- `is` compares identity; use `==` for values (`is None` is the exception).
- Late-binding closures in loops: `lambda: i` captures the variable, not the value; use `lambda i=i: i`.
- `dict` and `set` iteration order is insertion order, but don't mutate while iterating.
