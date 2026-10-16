<#
.SYNOPSIS
	Unit tests for the manifest and the exported functions of the
	git-aliases module (src/git-aliases.psd1, src/git-aliases.psm1,
	src/aliases.ps1).

.DESCRIPTION
	These tests keep the module sources consistent:
	- every alias defined in aliases.ps1 is exported in FunctionsToExport,
	- every exported name resolves to a function of the module,
	- the built-in PowerShell aliases that the module shadows are removed.

	Note on scoping: Pester evaluates Describe bodies and -TestCases data
	during discovery (plain local variables are visible there, $script:
	variables are not), while It bodies and BeforeAll run in the test
	file scope ($script: is visible there, plain variables are not).
	Each fixture is therefore stored in both forms: plain for discovery
	and $script: for the tests themselves.
#>

Describe 'Module manifest and exports' {
	# --- Discovery data (plain variables, used by -TestCases) ---
	$SrcDir = Join-Path (Join-Path $PSScriptRoot '..') 'src'
	$ManifestPath = Join-Path $SrcDir 'git-aliases.psd1'
	$RootModulePath = Join-Path $SrcDir 'git-aliases.psm1'
	$AliasesPath = Join-Path $SrcDir 'aliases.ps1'

	$rootModuleText = Get-Content $RootModulePath -Raw
	$exportArrayText = [regex]::Match($rootModuleText, '\$FunctionsToExport\s*=\s*@\((?s)(.*?)\)').Groups[1].Value
	$ExportList = [regex]::Matches($exportArrayText, "'([^']*)'") | ForEach-Object { $_.Groups[1].Value }

	$aliasesText = Get-Content $AliasesPath -Raw
	$AliasNames = [regex]::Matches($aliasesText, '(?m)^\s*function\s+([^\s{]+)') | ForEach-Object { $_.Groups[1].Value }

	$ConflictNames = @('gc', 'gcb', 'gcm', 'gcs', 'gl', 'gm', 'gp', 'gpv')

	$ExportCases = @($ExportList | ForEach-Object { @{ Name = $_ } })
	$ConflictCases = @($ConflictNames | ForEach-Object { @{ Name = $_ } })

	# --- Runtime data and module import ---
	BeforeAll {
		$SrcDir = Join-Path (Join-Path $PSScriptRoot '..') 'src'
		$script:ManifestPath = Join-Path $SrcDir 'git-aliases.psd1'
		$RootModulePath = Join-Path $SrcDir 'git-aliases.psm1'
		$AliasesPath = Join-Path $SrcDir 'aliases.ps1'

		$rootModuleText = Get-Content $RootModulePath -Raw
		$exportArrayText = [regex]::Match($rootModuleText, '\$FunctionsToExport\s*=\s*@\((?s)(.*?)\)').Groups[1].Value
		$script:ExportList = @([regex]::Matches($exportArrayText, "'([^']*)'") | ForEach-Object { $_.Groups[1].Value })

		$aliasesText = Get-Content $AliasesPath -Raw
		$script:AliasNames = @([regex]::Matches($aliasesText, '(?m)^\s*function\s+([^\s{]+)') | ForEach-Object { $_.Groups[1].Value })

		# Helper functions dot-sourced from utils.ps1 that are exported too.
		$script:ExportedHelpers = @(
			'Get-Git-CurrentBranch',
			'Get-Git-Aliases',
			'Get-Git-MainBranch'
		)

		{ Import-Module $script:ManifestPath -Force -DisableNameChecking -ErrorAction Stop } | Should -Not -Throw
	}

	AfterAll {
		Remove-Module git-aliases -Force -ErrorAction SilentlyContinue
	}

	It 'manifest is valid and named git-aliases' {
		$manifest = Test-ModuleManifest -Path $script:ManifestPath
		$manifest.Name | Should -Be 'git-aliases'
	}

	It 'FunctionsToExport list is not empty' {
		@($script:ExportList).Count | Should -BeGreaterThan 0
	}

	It 'parsed functions of aliases.ps1 is not empty' {
		@($script:AliasNames).Count | Should -BeGreaterThan 0
	}

	It 'module exports the FunctionsToExport list (count)' {
		$module = Get-Module git-aliases
		$module | Should -Not -BeNullOrEmpty
		$module.ExportedFunctions.Count | Should -Be @($script:ExportList).Count
	}

	It '<Name> resolves to an exported function of the module' -TestCases $ExportCases {
		param($Name)

		$command = Get-Command $Name -ErrorAction SilentlyContinue
		$command | Should -Not -BeNullOrEmpty -Because "name '$Name' must resolve after importing the module"
		$command.ModuleName | Should -Be 'git-aliases'
		$command.CommandType | Should -Be 'Function'
	}

	It 'FunctionsToExport covers every function defined in aliases.ps1' {
		$missing = @($script:AliasNames | Where-Object { $_ -notin $script:ExportList })
		$missing | Should -BeNullOrEmpty -Because 'every alias defined in aliases.ps1 must be added to $FunctionsToExport'
	}

	It 'FunctionsToExport does not contain stale entries' {
		$stale = @($script:ExportList | Where-Object { $_ -notin $script:AliasNames -and $_ -notin $script:ExportedHelpers })
		$stale | Should -BeNullOrEmpty -Because 'every exported name must be defined in aliases.ps1 or utils.ps1'
	}

	It 'built-in alias <Name> is removed, not shadowed, after import' -TestCases $ConflictCases {
		param($Name)

		Get-Alias -Name $Name -ErrorAction SilentlyContinue | Should -BeNullOrEmpty
	}
}
