#!/bin/sh -l
CONFIG_PATH=/luacheck-fivem/.luacheckrc.default
LUACHECK_ARGS="--default-config $CONFIG_PATH -t --formatter JUnit --include-files **/[[]Nabla[]]/**/*.lua --include-files **/Nabla/*.lua --globals NativeUI UIMenuItem BadgeStyle --"
LUACHECK_PATH="."
LUACHECK_CAPTURE_OUTFILE="$GITHUB_WORKSPACE/junit.xml"

# extra luacheck definitions
# if [[ ! -z "$5" ]]; then
  OLD_DIR=$(pwd)
  # regenerate with extras
  cd /luacheck-fivem/
  yarn build "mysql"
  # go back
  cd $OLD_DIR
# fi

EXIT_CODE=0

cd $GITHUB_WORKSPACE

echo "outfile => $LUACHECK_CAPTURE_OUTFILE"

if [[ ! -z "$LUACHECK_CAPTURE_OUTFILE" ]]; then
  echo "exec => luacheck $LUACHECK_ARGS $LUACHECK_PATH 2>>$LUACHECK_CAPTURE_OUTFILE"
  luacheck $LUACHECK_ARGS $LUACHECK_PATH >$LUACHECK_CAPTURE_OUTFILE 2>&1 || true

  echo "exec => luacheck $LUACHECK_ARGS --formatter default $LUACHECK_PATH"
  luacheck $LUACHECK_ARGS --formatter default $LUACHECK_PATH || EXIT_CODE=$?
else
  echo "exec => luacheck $LUACHECK_ARGS $LUACHECK_PATH"
  luacheck $LUACHECK_ARGS $LUACHECK_PATH || EXIT_CODE=$?
fi

echo "exit => $EXIT_CODE"
if [ $EXIT_CODE -ge 2 ]; then
 exit $EXIT_CODE
fi
