@echo off
title metadata
REM owner: Jianning Yan (jasmine.yan@mail.utoronto.ca)

::make a metadata folder if it does not exist
::if the folder exists, ask the user if they want to overwrite the metadata.csv file
if not exist "../metadata" (
	mkdir "../metadata"
) else (
	echo This will overwrite the original metadata.csv!
	echo If you do not want to continue, close the window.
	pause
)

::overwrite the original file, input the filename header
echo filename > ../metadata/metadata.csv

::get the length of the current directory, remove it from the absolute list
setlocal EnableDelayedExpansion
for /L %%n in (1 1 500) do if "!__cd__:~%%n,1!" neq "" set /a "len=%%n+1"
setlocal DisableDelayedExpansion

::write the current folder name
setlocal EnableDelayedExpansion
for %%* in (.) do set "current=%%~nx*"
setlocal DisableDelayedExpansion
echo %current% >> ../metadata/metadata.csv

::write subfolders
for /R /D %%g in ("*.*") do (
  set "absPath=%%g"
  setlocal EnableDelayedExpansion
  ::remove the current directory from the absolute list
  set "relPath=!absPath:~%len%!"
  ::change \ to / and add current directory's name to the relative path
  set "relPath=!relPath:%cd%=!"
  set "relPath=!relPath:\=/!"
  echo(%current%/!relPath!)>> ../metadata/metadata.csv
  endlocal
)

::write subfolder files
for /R . %%g in ("*.*") do (
  set "absPath=%%g"
  setlocal EnableDelayedExpansion
  set "relPath=!absPath:~%len%!"
  set "relPath=!relPath:%cd%=!"
  set "relPath=!relPath:\=/!"
  echo(data/%current%/!relPath!)>> ../metadata/metadata.csv
  endlocal
)

@echo on
@EXIT

REM Important Reference
::basic bash: http://steve-jansen.github.io/guides/windows-batch-scripting/index.html
::relative path: https://stackoverflow.com/questions/8385454/batch-files-list-all-files-in-a-directory-with-relative-paths
::slash change: https://stackoverflow.com/questions/24581094/batch-file-file-path-from-back-slash-to-forward-slash-to
