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

function Remove-Alias ([string] $AliasName) {
	while (Test-Path Alias:$AliasName) {
		Remove-Item Alias:$AliasName -Force 2> $null
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
	Get git aliases' definition.
.DESCRIPTION
	Get definition of all git aliases or specific alias.
.EXAMPLE
	PS C:\> Get-Git-Aliases
	Get definition of all git aliases.
.EXAMPLE
	PS C:\> Get-Git-Aliases -Alias gst
	Get definition of `gst` alias.
#>
function Get-Git-Aliases ([string] $Alias) {
	$esc = [char] 27
	$green = 32
	$magenta = 35

	$Alias = $Alias.Trim()
	$aliases = Get-Command -Module git-aliases

	if (-not ([string]::IsNullOrEmpty($Alias))) {
		$foundAliases = $aliases | Where-Object -Property Name -Value $Alias -EQ

		if ($foundAliases -is [array]) {
			return Format-AliasDefinition($foundAliases[0].Definition)
		}
		else {
			return Format-AliasDefinition($foundAliases.Definition)
		}
	}

	$aliases = $aliases | ForEach-Object {
		$name = $_.Name
		$definition = Format-AliasDefinition($_.Definition)
		$definition = "$definition`n" # Add 1 line break for some row space

		return [PSCustomObject]@{
			Name       = $name
			Definition = $definition
		}
	}

	$cols = @(
		@{
			Name       = 'Name'
			Expression = {
				# Print alias name in green
				"$esc[$($green)m$($_.Name)$esc[0m"
			}
		},
		@{
			Name       = 'Definition'
			Expression = {
				# Print alias definition in yellow
				"$esc[$($magenta)m$($_.Definition)$esc[0m"
			}
		}
	)

	return Format-Table -InputObject $aliases -AutoSize -Wrap -Property $cols
}
