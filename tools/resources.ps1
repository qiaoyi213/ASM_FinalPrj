windres .\resources\resources.rc -O coff -F pe-i386 .\obj\resources.res

# Remove-Item .\resource.res
# rc .\resource.rc
# cvtres /MACHINE:X86 .\resource.res

return $?