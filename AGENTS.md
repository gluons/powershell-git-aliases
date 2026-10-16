# AGENTS.md

`git-aliases` — a PowerShell module porting Git aliases from [Oh My Zsh's git plugin](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git). Published to PowerShell Gallery. No build system, no CI.

## Layout

| File | Purpose |
|------|---------|
| `src/git-aliases.psd1` | Module manifest. Bump `ModuleVersion` before any release. |
| `src/git-aliases.psm1` | Root module: dot-sources `aliases.ps1`, exports every alias via the `$FunctionsToExport` array. |
| `src/aliases.ps1` | One `function <alias> { git ... $args }` per Git alias. |
| `src/utils.ps1` | Helpers: `Get-Git-CurrentBranch`, `Get-Git-MainBranch`, `Get-Git-Aliases`, `Write-Host-Deprecated`, `Remove-Alias` shim. |
| `aliases.md` | Documentation table of all aliases. Keep in sync with code. |
| `tests/` | Pester unit tests (`*.Tests.ps1`). No build system needed — run with `Invoke-Pester`. See the test files for what they cover. |

## Verify changes

Run the unit tests, then import the module locally from the repo root and inspect aliases:

```powershell
pwsh -NoProfile -Command "Invoke-Pester tests -Output Minimal"
Import-Module ./src/git-aliases.psd1 -Force -DisableNameChecking
Get-Git-Aliases gst   # print one alias' definition; omit arg for all
```

## Adding or changing an alias — 4 required edits

Upstream source of truth for alias definitions: [`git.plugin.zsh`](https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh) in the Oh My Zsh git plugin.

1. Define/update the function in `src/aliases.ps1`.
2. Add the exact name to `$FunctionsToExport` in `src/git-aliases.psm1` — an alias is invisible until exported here.
3. Update the row in `aliases.md`.
4. Update the expected arguments in `tests/Aliases.Tests.ps1` (data-driven `$cases` tables). Export-consistency tests need no update — they catch a forgotten step 2 automatically.

## Conventions & pitfalls

- Pass user arguments through with `$args`; keep aliases thin wrappers over `git`.
- Never hardcode `master`/`main` — call `Get-Git-MainBranch` (see `gcm`, `gbda`, `glum`).
- Aliases deliberately shadow PowerShell built-ins (`gc`, `gcb`, `gcm`, `gcs`, `gl`, `gm`, `gp`, `gpv`). They are unregistered via `Remove-Alias` at the top of `src/aliases.ps1`; add removals there when introducing a new conflict.
- Non-standard names (`gc!`, `gpf!`, …) require users to import with `-DisableNameChecking` — don't "fix" these names.
- Deprecate by printing `Write-Host-Deprecated "old" "new"` at the top of the old function, then keep it working (see `gup` → `gpr`).
- Support both Windows PowerShell 5.1 and PowerShell 6+/7; guard version-specific behavior with `$PSVersionTable.PSVersion` (see the `Remove-Alias` shim in `src/utils.ps1`).
- Formatting follows `.editorconfig`: tabs in `.ps1`/`.psd1`/`.psm1`; markdown keeps trailing whitespace (two-space line breaks are used in `README.md`).
