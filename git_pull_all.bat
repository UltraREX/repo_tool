@echo off

for /D %%i in (
D:\ngame\proto,
) do cd %%i & git pull

pause