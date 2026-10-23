<#
.SYNOPSIS
	Get current git branch.
#>
function Get-Git-CurrentBranch {
	git symbolic-ref --quiet HEAD *> $null

	if ($LASTEXITCODE -eq 0) {
		return git rev-parse --abbrev-ref HEAD
	} else {
		return
	}
}

function Get-Git-MainBranch {
	git rev-parse --git-dir *> $null

	if ($LASTEXITCODE -ne 0) {
		return
	}

	$branches = @('main', 'trunk')

	foreach ($branch in $branches) {
		& git show-ref -q --verify refs/heads/$branch

		if ($LASTEXITCODE -eq 0) {
			return $branch
		}
	}

	return 'master'
}

function Get-Git-DevelopBranch {
	git rev-parse --git-dir *> $null
	if ($LASTEXITCODE -ne 0) {
		return
	}

	$branches = @("dev", "devel", "develop", "development")

	foreach ($branch in $branches) {
		& git show-ref -q --verify "refs/heads/$branch" *> $null
		if ($LASTEXITCODE -eq 0) {
			return $branch
		}
	}

	return "develop"
}

# Don't add `Remove-Alias` on PowerShell >= 6.
# PowerShell >= 6 already has built-in `Remove-Alias`.
# Let use built-in `Remove-Alias` on PowerShell >= 6.
if ($PSVersionTable.PSVersion.Major -le 5) {
	function Remove-Alias ([string] $AliasName) {
		while (Test-Path Alias:$AliasName) {
			Remove-Item Alias:$AliasName -Force 2> $null
		}
	}
}

function Format-AliasDefinition {
	param (
		[Parameter(Mandatory = $true)][string] $Definition
	)

	$definitionLines = $Definition.Trim() -split "`n" | ForEach-Object {
		$line = $_.TrimEnd()

		# Trim 1 indent
		if ($_ -match "^`t") {
			return $line.Substring(1)
		}
		elseif ($_ -match '^    ') {
			return $line.Substring(4)
		}

		return $line

	}

	return $definitionLines -join "`n"
}

<#
.SYNOPSIS
	Output type of `Get-Git-Aliases` when listing all aliases.
.DESCRIPTION
	Keeps the pipeline data for each alias (Name and Definition)
	and provides a clean, single-line string representation for
	text tools such as `Select-String`:
	`gc: git commit -v $args`
#>
class GitAliasInfo {
	[string] $Name
	[string] $Definition

	[string] ToString() {
		$oneLineDefinition = $this.Definition -replace '\s*\r?\n\s*', ' '
		return ('{0}: {1}' -f $this.Name, $oneLineDefinition)
	}
}

<#
.SYNOPSIS
	Get git aliases' definition.
.DESCRIPTION
	Get definition of all git aliases or specific alias.
.EXAMPLE
	PS C:\> Get-Git-Aliases
	Get definition of all git aliases.
.EXAMPLE
	PS C:\> Get-Git-Aliases -Alias gst
	Get definition of `gst` alias.
.EXAMPLE
	PS C:\> Get-Git-Aliases | Select-String commit
	List aliases whose pipe-friendly text contains `commit`.
#>
function Get-Git-Aliases ([string] $Alias) {
	$Alias = $Alias.Trim()
	$blacklist = @(
		'Get-Git-CurrentBranch',
		'Remove-Alias',
		'Format-AliasDefinition',
		'Get-Git-Aliases',
		'Write-Host-Deprecated'
	)
	$aliases = Get-Command -Module git-aliases | Where-Object { $_ -notin $blacklist }

	if (-not ([string]::IsNullOrEmpty($Alias))) {
		$foundAliases = $aliases | Where-Object -Property Name -Value $Alias -EQ

		if ($foundAliases -is [array]) {
			return Format-AliasDefinition($foundAliases[0].Definition)
		}
		else {
			return Format-AliasDefinition($foundAliases.Definition)
		}
	}

	return $aliases | ForEach-Object {
		return [GitAliasInfo]@{
			Name       = $_.Name
			Definition = Format-AliasDefinition $_.Definition
		}
	}
}

<#
.SYNOPSIS
	Print deprecated message.
.DESCRIPTION
	Print a colored message telling that a specific alias ($previous)
	is deprecated, suggesting the use of another alias ($next).
.EXAMPLE
	PS C:\> Write-Host-Deprecated "gup" "gpr"
	[git-aliases] gup is a deprecated alias, use "gpr" instead.
#>
function Write-Host-Deprecated {
	param (
		[Parameter(Mandatory = $true)][string] $previous,
		[Parameter(Mandatory = $true)][string] $next
	)

	Write-Host "[git-aliases] " -ForegroundColor Yellow -NoNewLine
	Write-Host "${previous}" -ForegroundColor Red -NoNewLine
	Write-Host " is a deprecated alias, use " -ForegroundColor Yellow -NoNewLine
	Write-Host """${next}""" -ForegroundColor Green -NoNewLine
	Write-Host " instead.`n" -ForegroundColor Yellow
}
