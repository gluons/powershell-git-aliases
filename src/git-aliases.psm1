. $PSScriptRoot\aliases.ps1

$FunctionsToExport = @(
	'Get-Git-CurrentBranch',
	'Get-Git-Aliases',
	'Get-Git-MainBranch',
	'g',
	'ga',
	'gaa',
	'gapa',
	'gau',
	'gb',
	'gba',
	'gbd',
	'gbda',
	'gbl',
	'gbnm',
	'gbr',
	'gbs',
	'gbsb',
	'gbsg',
	'gbsr',
	'gbss',
	'gc',
	'gc!',
	'gcn!',
	'gca',
	'gcam',
	'gca!',
	'gcan!',
	'gcans!',
	'gcb',
	'gcf',
	'gcl',
	'gclean',
	'gcm',
	'gcd',
	'gcmsg',
	'gco',
	'gcount',
	'gcp',
	'gcpa',
	'gcpc',
	'gcs',
	'gd',
	'gds',
	'gdca',
	'gdt',
	'gdw',
	'gf',
	'gfa',
	'gfo',
	'gg',
	'gga',
	'ggf',
	'ggfl',
	'ghh',
	'ggsup',
	'gpsup',
	'gignore',
	'gignored',
	'gl',
	'glg',
	'glgg',
	'glgga',
	'glgm',
	'glgp',
	'glo',
	'glog',
	'gloga',
	'glol',
	'glola',
	'gm',
	'gmom',
	'gmt',
	'gmtvim',
	'gmum',
	'gp',
	'gpd',
	'gpf',
	'gpf!',
	'gpoat',
	'gpr',
	'gpra',
	'gpristine',
	'gprv',
	'gpu',
	'gpv',
	'gr',
	'gra',
	'grb',
	'grba',
	'grbc',
	'grbi',
	'grbm',
	'grbs',
	'grh',
	'grhh',
	'grmv',
	'groh',
	'grrm',
	'grset',
	'grs',
	'grst',
	'grt',
	'gru',
	'grup',
	'grv',
	'gsb',
	'gsd',
	'gsh',
	'gsi',
	'gsps',
	'gsr',
	'gss',
	'gst',
	'gsta',
	'gstaa',
	'gstd',
	'gstl',
	'gstp',
	'gstc',
	'gsts',
	'gsu',
	'gsw',
	'gswm',
	'gswd',
	'gts',
	'gunignore',
	'gunwip',
	'gup',
	'gupa',
	'gupv',
	'glum',
	'gvt',
	'gwch',
	'gwip',
	'ggl',
	'ggp',
	'ggpnp',
	'gprom'
)

Export-ModuleMember -Function $FunctionsToExport
