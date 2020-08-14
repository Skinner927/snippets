@ECHO OFF
REM Sometimes figuring out if you're properly quoting arguments in cmd is
REM difficult. This script is a poor-man's attempt at checking arguments.
setlocal enabledelayedexpansion
echo Arguments wil be surrounded by backticks simply to show any whitespace.
set I=1
for %%A in (%*) DO (
  echo !I!: `%%A`
  set /A I=I+1
)
