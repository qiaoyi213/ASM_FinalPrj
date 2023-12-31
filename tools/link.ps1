# CONFIG ZONE #
$LIBRARY_DIRS_ARRAY = @(
	"Irvine",
	"C:\UASM\lib"
)

$LIBRARY_NAME_ARRAY = @(
	"Irvine32",
	"Kernel32",
	"User32",
	"gdi32",
	"gdiplus",
	"WinMM"
)

# WORKING ZONE #

$OBJ_PATHS = @(".\obj\main.obj")	# to keep main at first
Get-ChildItem ".\obj" -Filter *.obj | ForEach-Object {
	IF($_.Name -ne "main.obj") {
		$OBJ_PATHS += @(".\obj\" + $_.Name)
	}
}

$LIBRARY_FALGS = @()
$LIBRARY_DIRS_ARRAY | ForEach-Object {
	$LIBRARY_FALGS += @("-L$_")
}
$LIBRARY_NAME_ARRAY | ForEach-Object {
	$LIBRARY_FALGS += @("-l$_")
}
Write-Output $OBJ_PATHS

& "ld.exe" "--enable-stdcall-fixup" "-A" "i386:x86_64" "-m" "i386pe" "-s" "-o" ".\build\main.exe" $OBJ_PATHS $LIBRARY_FALGS
return $?