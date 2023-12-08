# CONFIG ZONE #
$INCLUDE_PATHS_ARRAY = @(
	"Irvine",
	"C:\uasm\include"
)

# WORKING ZONE #
$SUCCESS = $true

$INCLUDE_FLAGS = @()
$INCLUDE_PATHS_ARRAY | ForEach-Object {
	$INCLUDE_FLAGS += @("-I$_")
}

foreach ($_ in Get-ChildItem ".\src" -recurse -Filter *.asm) {
	$OBJ_FLAG = "-Fo .\obj\" + $_.BaseName + ".obj"
	$ERR_FLAG = "-Fw .\obj\" + $_.BaseName + ".err"
	$ASM_PATH = $_ | Resolve-Path -Relative

	& "uasm64.exe" "-Zi3" "-coff" $INCLUDE_FLAGS $OBJ_FLAG $ERR_FLAG $ASM_PATH
	IF(!$?) {
		Write-Output "Assemble Failed"
		$SUCCESS = $false
		break
	}
}

return $SUCCESS