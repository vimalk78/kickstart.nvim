# Go Cheatsheet

Editor keys (Neovim, gopls) and Go reference. See [cheatsheet.md](cheatsheet.md) for the full keymap list.

Your gopls is configured with build tags `bcc,libbpf,gpu,vimal` (`GOFLAGS` in `init.lua`). Run commands with the same tags so results match the editor:

```sh
export GOFLAGS=-tags=bcc,libbpf,gpu,vimal
```

## Neovim Keys (gopls)

| Action | How |
|--------|-----|
| Find all callers / usages | `grr` |
| Jump to definition | `grd` |
| Jump to interface implementation | `gri` on the interface method |
| Type definition | `grt` |
| Rename across package | `grn` |
| Code action (fill struct, organize imports, generate stubs) | `gra` |
| Format | `<leader>F` |
| Diagnostics list | `<leader>q` |
| Docs under cursor | `K` |
| Symbols in file / workspace | `gO` / `gW` |

## Terminal Commands

| Command | What it does |
|---------|--------------|
| `go build ./...` | Compile everything |
| `go run ./cmd/app` | Run a main package |
| `go test ./...` | Run all tests |
| `go test -run TestName -v ./pkg/x` | Run one test verbosely |
| `go test -race ./...` | Race detector |
| `go test -cover ./...` | Coverage summary |
| `go vet ./...` | Static checks |
| `gofmt -l -w .` | Format in place (lists changed files) |
| `go mod tidy` | Sync `go.mod` / `go.sum` |
| `go doc fmt.Printf` | Docs for a symbol |
| `go list -deps ./...` | Dependency graph |

## Language Reference

### Errors

```go
f, err := os.Open(path)
if err != nil {
    return fmt.Errorf("open %s: %w", path, err) // %w keeps the chain
}
defer f.Close()
```

- Check `err` immediately after the call.
- `errors.Is(err, fs.ErrNotExist)` and `errors.As(err, &target)` inspect wrapped errors.

### Structs and methods

```go
type Point struct {
    X, Y int
}

func (p Point) Dist2() int { return p.X*p.X + p.Y*p.Y } // value receiver
func (p *Point) Move(dx, dy int) { p.X += dx; p.Y += dy } // pointer receiver
```

- Use a pointer receiver if the method mutates or the struct is large.
- Mixing receiver kinds on one type is allowed but usually avoid it.

### Interfaces

```go
type Reader interface {
    Read(p []byte) (n int, err error)
}
```

- Interfaces are satisfied implicitly. Keep them small, define them where they're consumed.
- Type assertion: `v, ok := x.(T)`. Type switch: `switch v := x.(type) { ... }`.

### Slices and maps

```go
s := make([]int, 0, 16)     // len 0, cap 16
s = append(s, 1, 2, 3)
m := map[string]int{"a": 1}
v, ok := m["b"]             // ok is false if missing
delete(m, "a")
```

- Use `slices` and `maps` packages (Go 1.21+) for `Sort`, `Contains`, `Keys`, etc.
- `for i := range 10 { ... }` (Go 1.22+).

### Concurrency

```go
ch := make(chan int)
var wg sync.WaitGroup
for _, job := range jobs {
    wg.Add(1)
    go func() {
        defer wg.Done()
        ch <- process(job)
    }()
}
go func() { wg.Wait(); close(ch) }()
for r := range ch { fmt.Println(r) }
```

- Pass `context.Context` as the first argument to anything that can block or be cancelled.
- `select` with `ctx.Done()` for cancellation.
- Run `go test -race` whenever you touch goroutines.

### Testing

```go
func TestAdd(t *testing.T) {
    tests := []struct {
        name string
        a, b int
        want int
    }{
        {"pos", 1, 2, 3},
        {"neg", -1, -2, -3},
    }
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            if got := Add(tt.a, tt.b); got != tt.want {
                t.Errorf("Add(%d,%d) = %d, want %d", tt.a, tt.b, got, tt.want)
            }
        })
    }
}
```

- Table-driven tests with `t.Run` give per-case names: `go test -run TestAdd/neg`.
- `t.Helper()` in helper functions; `t.TempDir()` for scratch dirs.

### Gotchas

- Loop variables: fixed per-iteration since Go 1.22, but check your `go.mod` `go` directive.
- A nil interface is not the same as an interface holding a nil pointer.
- `defer` inside a loop runs at function end, not iteration end.
- Maps are not safe for concurrent writes; guard with `sync.Mutex` or use `sync.Map`.
- `:=` in an inner scope shadows the outer variable; `go vet -shadow` can catch it.
