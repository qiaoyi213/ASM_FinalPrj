windres .\resource.rc -O coff -F pe-i386 .\resource.res

# Remove-Item .\resource.res
# rc .\resource.rc
# cvtres /MACHINE:X86 .\resource.res