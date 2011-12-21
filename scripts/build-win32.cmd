cd ..\source
fpc @config.cfg -O3 -Sc -XX main.dpr

upx -9 ..\bin\main.exe
del /q ..\bin\*.o ..\bin\*.ppu ..\bin\*.a ..\bin\*.res ..\bin\*.or

pause