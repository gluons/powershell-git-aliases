# Git aliases for PowerShell
[![license](https://img.shields.io/github/license/gluons/powershell-git-aliases.svg?style=flat-square)](./LICENSE)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/git-aliases.svg?style=flat-square)](https://www.powershellgallery.com/packages/git-aliases/)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/git-aliases.svg?style=flat-square)](https://www.powershellgallery.com/packages/git-aliases/)
[![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/gluons/powershell-git-aliases/test.yml?style=flat-square)](https://github.com/gluons/powershell-git-aliases/actions/workflows/test.yml)

A [PowerShell](https://microsoft.com/powershell) module that provide partial **[Git](https://git-scm.com/)** aliases from [Oh My Zsh](https://github.com/robbyrussell/oh-my-zsh)'s [git plugin](https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/git/).

> ℹ️ This module will replace some built-in PowerShell aliases with our Git aliases to **prevent** [conflict](https://github.com/gluons/powershell-git-aliases/issues?utf8=%E2%9C%93&q=is%3Aissue+label%3Aconflict).

## ⚙️ Installation

Install from [PowerShell Gallery](https://www.powershellgallery.com/packages/git-aliases/)

```powershell
Install-Module git-aliases -Scope CurrentUser -AllowClobber
```

Or from [Scoop](https://github.com/ScoopInstaller/Extras/blob/master/bucket/git-aliases.json)

```powershell
scoop bucket add extras
scoop install git-aliases
```

---

⚠️ If you haven't allowed script execution policy, set your script execution policy to `RemoteSigned` or `Unrestricted`.

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## 🛂 Usage

You have to import the module to use `git-aliases`.

Add below command into your PowerShell profile.

```powershell
Import-Module git-aliases -DisableNameChecking
```

Then restart your PowerShell.
Now you can use Git aliases.

---

⚠️ If you don't have PowerShell profile yet, create it with below command!

```powershell
New-Item -ItemType File $profile
```

## 📖 Aliases

See [aliases.md](./aliases.md) for the full list of available aliases and what each one does.

You can also inspect them from PowerShell with `Get-Git-Aliases`.

### `Get-Git-Aliases`

Prints the definition of every Git alias in the module, or the definition of a single alias.

| Parameter | Type | Description |
|-----------|------|-------------|
| `-Alias`  | `String` | Optional. Name of the alias to inspect (e.g. `gst`). When omitted, all aliases are listed in a table. |

Show all aliases:

```powershell
Get-Git-Aliases
```

Show the definition of a single alias:

```powershell
Get-Git-Aliases -Alias gst
```

The output is the alias' function body, so it shows exactly which `git` command the alias runs:

```powershell
git status $args
```

Passing an unknown alias name throws an error.
