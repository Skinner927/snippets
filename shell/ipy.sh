#!/usr/bin/env bash

# This is a roundabout way to start ipython from inside a virtualenv without it being installed
# in that virtualenv. The only caveot is that the "global" python must have ipython installed.
# What this function does that's different than simply calling the global ipython is it ensures to
# call the ipython that is installed for the same major.minor python version as in the virtualenv.
# This is most useful if you use pyenv for example as global python3 could be 3.7 and local
# virtualenv python3 is 3.6.

# This is designed to be dropped into your shell profile (~/.bashrc|~/.zshrc)
unset ipy_lookup
declare -A ipy_lookup
function ipy {
  local PY_BIN
  local IPYTHON
  local PYV
  # This quick way will work if ipython is in the virtualenv
  PY_BIN="$(python -c 'import sys; print(sys.executable)')"
  IPYTHON="$(dirname "$PY_BIN")/ipython"
  if [[ -x "$IPYTHON" ]]; then
    "$IPYTHON"
  else
    # Ask the current python what version it is
    PYV="$(python -c 'import sys; print(".".join(str(i) for i in sys.version_info[:2]))')"
    PY_BIN="${ipy_lookup[$PYV]}"
    if [[ -z "$PY_BIN" ]]; then
      echo "Looking for iPython for Python $PYV"
      # In a new shell (where pyenv should load if equipped) try to find that version
      PY_BIN="$(env -i $SHELL -li -c "which python$PYV")"
      if [[ -x "$PY_BIN" ]]; then
        ipy_lookup[$PYV]="$PY_BIN"
      fi
    fi
    "$PY_BIN" -m IPython
  fi
}
