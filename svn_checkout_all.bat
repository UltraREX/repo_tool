@echo off

rem 查找 TortoiseProc
set ProcPath="C:\Program Files\TortoiseSVN\bin\TortoiseProc.exe"

setlocal EnableDelayedExpansion
if not exist %ProcPath% (    
    for /f "usebackq skip=2 tokens=1,2*" %%a in (`reg query "HKEY_LOCAL_MACHINE\SOFTWARE\TortoiseSVN" /v ProcPath 2^>nul`) do (
        set ProcPath="%%C"
    )
)

if not exist !ProcPath! (
    echo not found TortoiseProc 
    pause 
    exit
)


rem 设置根目录
set rootPath=ngame
if exist %rootPath% (
    echo %rootPath% already exist
) else (
    md %rootPath%
)

rem 仓库列表
for %%i in (
http://svn.lovengame.com:58080/svn/zgame_unity/,
http://svn.lovengame.com:58080/svn/zgame_ui/ssrFGUI工程/,
) do (    
   call :checkout %%i
)

goto :eof


:checkout
set url=%1
set str=%1

:split_url
for /f "tokens=1,* delims=/" %%j in ("!str!") do (
  set dirName=%%j
  set str=%%k
)

echo %str% | findstr "[/]" >nul
if %errorlevel% equ 0 (
  goto split_url
)

if exist %rootPath%/%dirName% (
  %ProcPath% /command:update /path:%rootPath%/%dirName%  /closeonend:2
) else (
  %ProcPath% /command:checkout /url:%url% /path:%rootPath%/%dirName%  /closeonend:2
)
