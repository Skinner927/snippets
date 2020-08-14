# Powershell has a hard time erroring on bad commands/processes because it
# treats external binaries differently than powershell commands.
#
# This wrapper function is an attempt to fix that. It runs a script block
# which should only contain a single command. If it contains more than one
# command, only the last command's $LASTEXITCODE will be checked.
#
# Inspired by Bash's `set -e`
#
# Example:
#
#   bail {
#     docker run --rm -ti ubuntu "bash -c 'echo `"Hello World`"'"
#   } "Could not run 'Hello World' in docker"

function bail {
  [CmdletBinding()]
  param(
    [Parameter(Position=0,Mandatory=1)][scriptblock]$cmd,
    [Parameter(Position=1,Mandatory=0)][string]$errorMessage = $null,
  )
  if (-not $errorMessage) {
    $errorMessage = ("Error executing command {0}" -f $cmd)
  }
  # Powershell 2.0 workaround
  $global:LASTEXITCODE = 0
  try {
    & $cmd
  } catch {
    Write-Host "Exception:"
    Write-Host $_
    throw $errorMessage
  }
  if ((-not $?) -or ($LASTEXITCODE -ne 0)) { throw $errorMessage }
}
