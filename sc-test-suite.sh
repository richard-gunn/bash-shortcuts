#!/bin/bash

#
# BASH Shortcuts - TEST SUITE
#
# This file is part of BASH Shortcuts.
#
# <http://sourceforge.net/projects/bash-shortcuts/>
#
# Copyright (C) 2010, 2011 Richard Gunn
#
# BASH Shortcuts is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# BASH Shortcuts is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with BASH Shortcuts.  If not, see <http://www.gnu.org/licenses/>.
#

#
# _exec_null - Execute commands and redirect STDOUT and STDERR to null device
#
function _exec_null
{
  echo "$( _log_time ) : $@" >> "$SC_LOG_OUTPUT"
  eval "$@" >> "$SC_LOG_OUTPUT" 2>&1
}

#
# _init_logs - Initialise test logs
#
function _init_logs
{
  SC_DIR_LOGS='./tests/logs'
  SC_DIR_LOGS_ARCHIVE="${SC_DIR_LOGS}/archive"

  # Create logs directory
  if [ ! -d "${SC_DIR_LOGS}" ]; then
    mkdir "${SC_DIR_LOGS}"
    if [ ! "$?" -eq 0 ]; then
      echo "Could not create logs directory [${SC_DIR_LOGS}]"
      exit 1
    fi
  fi

  # Create archive directory
  if [ ! -d "${SC_DIR_LOGS_ARCHIVE}" ]; then
    mkdir "${SC_DIR_LOGS_ARCHIVE}"
    if [ ! "$?" -eq 0 ]; then
      echo "Could not create logs archive directory [${SC_DIR_LOGS_ARCHIVE}]"
      exit 1
    fi
  fi

  local DATETIME=( $( date +'%Y %m %d %H %M %S' ) )

  local YEAR=${DATETIME[0]}
  local MONTH=${DATETIME[1]}
  local DAY=${DATETIME[2]}
  local HOUR=${DATETIME[3]}
  local MIN=${DATETIME[4]}
  local SEC=${DATETIME[5]}

  SC_LOG_DATETIME="${YEAR}${MONTH}${DAY}-${HOUR}${MIN}${SEC}"

  local LOG_DATETIME="${YEAR}-${MONTH}-${DAY} ${HOUR}:${MIN}:${SEC}"

  #SC_LOG_DATETIME=$( date +%Y%m%d-%H%M )
  SC_LOG_TEST="${SC_DIR_LOGS_ARCHIVE}/${SC_LOG_DATETIME}-test.log"
  SC_LOG_FAIL="${SC_DIR_LOGS_ARCHIVE}/${SC_LOG_DATETIME}-fail.log"
  SC_LOG_OUTPUT="${SC_DIR_LOGS_ARCHIVE}/${SC_LOG_DATETIME}-output.log"
  SC_LOG_SUMMARY="${SC_DIR_LOGS_ARCHIVE}/${SC_LOG_DATETIME}-summary.log"

  # Write header to each log
  echo "Bash Shortcuts - Test Output Log - $LOG_DATETIME" > $SC_LOG_TEST
  echo "Using sc version [$SC_VERSION]" >> $SC_LOG_TEST
  echo '' >> $SC_LOG_TEST
  echo "Bash Shortcuts - Fail Output Log - $LOG_DATETIME" > $SC_LOG_FAIL
  echo "Using sc version [$SC_VERSION]" >> $SC_LOG_FAIL
  echo '' >> $SC_LOG_FAIL
  echo "Bash Shortcuts - Command Output Log - $LOG_DATETIME" > $SC_LOG_OUTPUT
  echo "Using sc version [$SC_VERSION]" >> $SC_LOG_OUTPUT
  echo '' >> $SC_LOG_OUTPUT
  echo "Bash Shortcuts - Summary Output Log - $LOG_DATETIME" > $SC_LOG_SUMMARY
  echo "Using sc version [$SC_VERSION]" >> $SC_LOG_SUMMARY
  echo '' >> $SC_LOG_SUMMARY

  SC_LOG_START_TIME=$(($(date +%s%N)/1000000))

  # Delete previous 'latest' logs
  _exec_null rm "${SC_DIR_LOGS}/latest-test.log"
  _exec_null rm "${SC_DIR_LOGS}/latest-fail.log"
  _exec_null rm "${SC_DIR_LOGS}/latest-output.log"
  _exec_null rm "${SC_DIR_LOGS}/latest-summary.log"
}

#
# _finalise_logs - Create 'latest' copies of logs
#
function _finalise_logs
{
  _exec_null cp "$SC_LOG_TEST" "${SC_DIR_LOGS}/latest-test.log"
  _exec_null cp "$SC_LOG_FAIL" "${SC_DIR_LOGS}/latest-fail.log"
  _exec_null cp "$SC_LOG_OUTPUT" "${SC_DIR_LOGS}/latest-output.log"
  _exec_null cp "$SC_LOG_SUMMARY" "${SC_DIR_LOGS}/latest-summary.log"
}


#
# _log_time - Get current log time in millisecs
#
function _log_time
{
  local MARK_TIME=$(($(date +%s%N)/1000000))
  local ELAPSED=$(( $MARK_TIME - $SC_LOG_START_TIME ))
  printf '%08d' $ELAPSED
}


#
# Write to test log
#
# $1 - Output
# $2 - Y=write to fail log as well as test log
#
function _log
{
  echo "$1" >> "$SC_LOG_TEST"

  if [ "$2" == 'Y' ];then
    echo "$1" >> "$SC_LOG_FAIL"
  fi
}

#
# Write to log and echo
#
# $1 - Output
#
function _log_echo
{
  echo "$1"
  _log "$1"
}

#
# _log_series - Create a header in the log for a series of tests
#
#   $1 - Series number
#   $2 - Loop number (optional)
#   $3 - Command (optional)
#
function _log_series
{

  _log
  _log '===================================================================='

  if [ $# -eq 1 ]; then
    _log "Series $1"
  elif [ $# -eq 2 ]; then
    _log "Series $1 (Loop $2)"
  elif [ $# -eq 3 ]; then
    _log "Series $1 (Loop $2) - Using [$3] command"
  fi

  _log '===================================================================='
}


#
# _log_summary - Write to summary log
#
#   $1 - Output
#
function _log_summary
{
  echo "$1" >> "$SC_LOG_SUMMARY"
}

#
# _log_summary_totals
#   $1 - Summary Title
#
function _log_summary_totals
{
  local THIS_SUCCESS=$(( $CNT_SUCCESS - $SC_LAST_CNT_SUCCESS ))
  local THIS_FAIL=$(( $CNT_FAIL - $SC_LAST_CNT_FAIL ))

  _log_summary "===== $1 ====="

  if [ "$THIS_FAIL" -gt 0 ];then
    _log_summary "Success = $THIS_SUCCESS / FAIL = ### $THIS_FAIL ###"
  else
    _log_summary "Success = $THIS_SUCCESS / Fail = $THIS_FAIL"
  fi
  _log_summary ''

  SC_LAST_CNT_SUCCESS=$CNT_SUCCESS
  SC_LAST_CNT_FAIL=$CNT_FAIL
}

#
# _log_final_totals
#
function _log_final_totals
{
  _log_summary "===== Final Suite Totals ====="

  if [ "$CNT_FAIL" -gt 0 ];then
    _log_summary "Success = $CNT_SUCCESS / FAIL = ### $CNT_FAIL ###"
  else
    _log_summary "Success = $CNT_SUCCESS / Fail = $CNT_FAIL"
  fi
  _log_summary ''
}

#
# $1 - Test Number
# $2 - Expected Output
# $3 - Actual Output
# $4 - Result
# $5 - Write to fail log?
#
function _log_test
{
  _log "===== $( _log_time ) Test: $1 =====" $5
  _log '' $5
  _log '--- Expected Output ---' $5
  _log "$2" $5
  _log '--- Expected End ---' $5
  _log '' $5
  _log '--- Actual Output ---' $5
  _log "$3" $5
  _log '--- Actual End ---' $5
  _log '' $5
  _log "--- Result: $4 ---" $5
  _log '' $5
}


#
# $1 - Test Number
# $2 - Loop
# $3 - Assertion
# $4 - Node type F/D/L
# $5 - Node Path
# $6 - Result 0=fail, 1=success
#
function _log_node_assertion
{
  local TESTNO="$1"
  local LOOP="$2"
  local ASSERTION="$3"
  local NODE_TYPE="$4"
  local NODE_PATH="$5"
  local RESULT="$6"

  if [ "$RESULT" -eq 0 ];then
    local FAIL='Y'
  fi


  if [ "$NODE_TYPE" == 'F' ];then
    local NODE_TYPE='file'

  elif [  "$NODE_TYPE" == 'D' ];then
    local NODE_TYPE='directory'

  elif [  "$NODE_TYPE" == 'L' ];then
    local NODE_TYPE='link'

  else
    echo "Invalid node type [$NODE_TYPE]"
    exit 1
  fi

  if [ "$LOOP" -gt 0 ];then
    _log "===== $( _log_time ) Test: $1 - (Loop $LOOP) =====" $FAIL
  else
    _log "===== $( _log_time ) Test: $1 =====" $FAIL
  fi

  _log '' $FAIL

  if [ "$ASSERTION" == 'Y' ]; then
    _log "Assert $NODE_TYPE exists - $NODE_PATH" $FAIL
  else
    _log "Assert $NODE_TYPE is absent - $NODE_PATH" $FAIL
  fi

  _log '' $FAIL

  if [ "$RESULT" == '1' ]; then
    CNT_SUCCESS=$((CNT_SUCCESS+1))
    _log "--- Result: Success ---" $FAIL
    echo "LP [$LOOP] TST [$TESTNO] - Success!"
  else
    CNT_FAIL=$((CNT_FAIL+1))
    _log "--- Result: ## FAIL ##  ---" $FAIL
    echo "LP [$LOOP] TST [$TESTNO] - ## FAIL! ##"
  fi
  _log '' $FAIL
}

#
# Assert that node is absent
#
# $1 - Node type F=file, D=directory, L=link
# $2 - File path
# $3 - Assertion Y=exists, N=absent
# $4 - Loop
# $n - Test numbers
#
function _assert_file_node
{

  local NODE_TYPE="$1"
  local NODE_PATH="$2"
  local ASSERTION="$3"
  local LOOP="$4"
  shift 4

  # Create a test number from the remaining params
  local TEST_NO=$( echo "$*" | tr ' ' '.' )

  local EXISTS=0

  if [ "$NODE_TYPE" == "F" ]; then
    if [ -f "$NODE_PATH" ];then
      local EXISTS=1
    fi

  elif [ "$NODE_TYPE" == "D" ];then
    if [ -d "$NODE_PATH" ];then
      local EXISTS=1
    fi

  elif [  "$NODE_TYPE" == "L"  ];then
    if [ -L "$NODE_PATH" ];then
      local EXISTS=1
    fi

  else
    echo "Invalid node type [$NODE_TYPE]"
  fi

  if [ "$ASSERTION" == "Y" ] && [ "$EXISTS" == 1 ]; then
    _log_node_assertion $TEST_NO $LOOP $ASSERTION $NODE_TYPE $NODE_PATH 1
  elif [ "$ASSERTION" == "N" ] && [ "$EXISTS" == 0 ]; then
    _log_node_assertion $TEST_NO $LOOP $ASSERTION $NODE_TYPE $NODE_PATH 1
  else
    _log_node_assertion $TEST_NO $LOOP $ASSERTION $NODE_TYPE $NODE_PATH 0
  fi
}

#
# $1 - Path to link
#
function _get_shortcut_target
{
  if [ -f "$1" ]; then
    echo $( cat "$1" )
  else
    echo '[ ERROR ]'
  fi
}

#
# $1 - Shortcut name
#
function _get_shortcut_label
{
  echo $( cat "${SC_DIR_LABELS}/$1" )
}

#
# _name_label - Create name for label
#   $n - Param
#
function _name_label
{
  local PARAMS=$( echo "$*" | tr ' ' '.' )
  echo "Label $PARAMS"
}

#
# _name_shortcut - Create name for shortcut
#   $n - Param
#
function _name_shortcut
{
  local PARAMS=$( echo "$*" | tr ' ' '-' )
  echo "shortcut-$PARAMS"
}

#
# _name_target - Create name for target directory
#   $n - Param
#
function _name_target
{
  local PARAMS=$( echo "$*" | tr ' ' '-' )
  echo "${SC_DIR_TEST}/target-$PARAMS"
}

function _clear_shortcuts
{
  _exec_null rm -v "${SC_DIR_SHORTCUTS}/list.txt"
  _exec_null rm -v "$SC_DIR_TARGETS/*"
  _exec_null rm -v "$SC_DIR_LABELS/*"
}

#
# _test_output - Revised test function
#   $1 - Expected output
#   $2 - Actual output
#   $3 - Loop number
#   $4 - Test level 1
#   $5 - Test level 2
#   $n - Test level 2+n (optional)
#
function _test_output
{
  # Loop number and test level 1 is required
  if [ $# -lt 5 ]; then
    _log_echo "_test_output - wrong number of params [$#]"
    exit 1
  fi

  local EXP=$1
  local ACT=$2
  local LOOP=$3
  shift 3

  # Create a test number from the remaining params
  local TESTNO=$( echo "$*" | tr ' ' '.' )

  # Expected output should not be set to an empty string
  if [ "$EXP" == '' ]; then
    local EXP='[ ERROR ]'
  fi

  if [ "$ACT" == '' ]; then
    local ACT='[ NULL ]'
  fi

  if [ "$ACT" == "$EXP" ]; then
    local RESULT='Success!'
    echo "LP [$LOOP] TST [$TESTNO] - Success!"
    CNT_SUCCESS=$((CNT_SUCCESS+1))
  else
    local RESULT='## FAIL! ##'
    echo "LP [$LOOP] TST [$TESTNO] - ## FAIL! ##"
    CNT_FAIL=$((CNT_FAIL+1))
    local FAIL='Y'
  fi

  _log ''
  if [ "$LOOP" -eq 0 ];then
    _log_test "$TESTNO" "$EXP" "$ACT" "$RESULT" $FAIL
  else
    _log_test "$TESTNO - (Loop $LOOP)" "$EXP" "$ACT" "$RESULT" $FAIL
  fi
}

#
# _log_pass_fail - Write a test pass or fail to test log
#
#   $1 - Test number
#   $2 - Message
#   $3 - Result
#   $4 - Write to fail log?
#
function _log_pass_fail
{
  _log "===== $( _log_time ) Test: $1 =====" $4
  _log '' $4
  _log "--- Message: $2 ---" $4
  _log '' $4
  _log "--- Result: $3 ---" $4
  _log '' $4
}

#
# _log_pass - Log a test pass
#
#   $1 - Message
#   $2 - Loop number
#   $n - Test level n (optional)
#
function _log_pass
{
  local MESSAGE=$1
  local LOOP=$2
  shift 2

  # Create a test number from the remaining params
  local TESTNO=$( echo "$*" | tr ' ' '.' )

  local RESULT='Success!'
  echo "LP [$LOOP] TST [$TESTNO] - Success!"
  CNT_SUCCESS=$((CNT_SUCCESS+1))

  if [ "$LOOP" -eq 0 ];then
    _log_pass_fail "$TESTNO" "$MESSAGE" "$RESULT" 'N'
  else
    _log_pass_fail "$TESTNO - (Loop $LOOP)" "$MESSAGE" "$RESULT" 'N'
  fi
}

#
# _log_fail - Log a test fail
#
#   $1 - Message
#   $2 - Loop number
#   $n - Test level n (optional)
#
function _log_fail
{
  local MESSAGE=$1
  local LOOP=$2
  shift 2

  # Create a test number from the remaining params
  local TESTNO=$( echo "$*" | tr ' ' '.' )

  local RESULT='## FAIL! ##'
  echo "LP [$LOOP] TST [$TESTNO] - ## FAIL! ##"
  CNT_FAIL=$((CNT_FAIL+1))

  if [ "$LOOP" -eq 0 ];then
    _log_pass_fail "$TESTNO" "$MESSAGE" "$RESULT" 'Y'
  else
    _log_pass_fail "$TESTNO - (Loop $LOOP)" "$MESSAGE" "$RESULT" 'Y'
  fi
}


#
# Test results comparison
#
# $1    - Level 1 test number
# $2    - Level 2 test number
# [$3]  - Level 3 test
# $3|$4 - Expected output
# $4|$5 - Actual output
# $5|$6 - Loop number
#
function _test
{
  _log ''

  if [ $# -eq 4 ]; then

    _log_test "$1.$2" "$3" "$4"

    if [ "$3" == "$4" ]; then
      _log_echo "TST: ${1}.${2} - Success!"
      CNT_SUCCESS=$((CNT_SUCCESS+1))
    else
      _log_echo "TST: ${1}.${2} - ## FAIL! ##"
      CNT_FAIL=$((CNT_FAIL+1))
    fi

  elif [ $# -eq 5 ]; then

   _log_test "$1.$2 - (Loop $5)" "$3" "$4"

    if [ "$3" == "$4" ]; then
      _log_echo "TST: $1.$2 - Success!"
      CNT_SUCCESS=$((CNT_SUCCESS+1))
    else
      _log_echo "TST: $1.$2 - ## FAIL! ##"
      CNT_FAIL=$((CNT_FAIL+1))
    fi

  elif [ $# -eq 6 ]; then

   _log_test "$1.$2.$3 - (Loop $6)" "$4" "$5"

    if [ "$4" == "$5" ]; then
      _log_echo "TST: $1.$2.$3 - Success!"
      CNT_SUCCESS=$((CNT_SUCCESS+1))
    else
      _log_echo "TST: $1.$2.$3 - ## FAIL! ##"
      CNT_FAIL=$((CNT_FAIL+1))
    fi

  else
      echo "Test - wrong number of params [$#]"
      exit 1
  fi
}

#
#   $1 - series number
#   $2 - loop
#   $3 - command
#
function _series
{
  local SERIES=$1
  local LOOP=$2
  local CMD=$3

  _log_series $SERIES $LOOP "$CMD"

  eval "series_${SERIES}" $LOOP "$CMD"

  # Log Summary totals
  _log_summary_totals "Series $SERIES Loop $LOOP"

}

#
#   $1 - Shortcut name
#   $2 - Target directory or ''
#   $3 - Label text or ''
#   $4 - Loop
#   $5 - Test number level 1
#   $6 - Test number level 2 - start
#
function _verify_shortcut
{
  local SHORTCUT=$1
  local TARGET=$2
  local LABEL=$3
  local LOOP=$4

  shift 4

  # Create a test number from the remaining params
  local TESTNO=$( echo "$*" | tr ' ' '.' )

  ## 10 - Check that shortcut file does exist ##
  _assert_file_node 'F' "${SC_DIR_TARGETS}/$SHORTCUT" 'Y' $LOOP $TESTNO 10

  ## 20 - Check the shortcut target ##
  if [ "$TARGET" != '' ];then
    local SC_EXP=$TARGET
    local SC_ACT=$( _get_shortcut_target "${SC_DIR_TARGETS}/$SHORTCUT" )
    _test_output "$SC_EXP" "$SC_ACT" $LOOP $TESTNO 20
  fi

  ## 30 - Check that the existence of the shortcut label ##
  if [ "$LABEL" == '' ];then
    _assert_file_node 'F' "${SC_DIR_LABELS}/$SHORTCUT" 'N' $LOOP $TESTNO 30
  else
    _assert_file_node 'F' "${SC_DIR_LABELS}/$SHORTCUT" 'Y' $LOOP $TESTNO 30
  fi

  ## 40 - Check the shortcut label ##
  if [ "$LABEL" != '' ];then
    local SC_EXP=$LABEL
    local SC_ACT=$( _get_shortcut_label "$SHORTCUT" )
    _test_output "$SC_EXP" "$SC_ACT" $LOOP $TESTNO 40
  fi
}


#
# _assert_shortcut_absent - Test that a shortcut does not exist
#
#   $1 - Shortcut name
#   $2 - Loop
#   $n - Test number level n
#
function _assert_shortcut_absent
{
  local SHORTCUT=$1
  local LOOP=$2
  shift 2

  # Create a test number from the remaining params
  local TESTNO=$( echo "$*" | tr ' ' '.' )

  ## 10 - Check for the existence of the shortcut link ##
  _assert_file_node 'L' "${SC_DIR_TARGETS}/$SHORTCUT" 'N' $LOOP $TESTNO 10

  ## 20 - Check for the existence of the shortcut label ##
  _assert_file_node 'F' "${SC_DIR_LABELS}/$SHORTCUT" 'N' $LOOP $TESTNO 20
}


# Load test series

. ./tests/sc-tests-series-00.sh
. ./tests/sc-tests-series-10.sh
. ./tests/sc-tests-series-20.sh
. ./tests/sc-tests-series-30.sh
. ./tests/sc-tests-series-40.sh
. ./tests/sc-tests-series-50.sh
. ./tests/sc-tests-series-60.sh
. ./tests/sc-tests-series-70.sh
. ./tests/sc-tests-series-80.sh
. ./tests/sc-tests-series-90.sh
. ./tests/sc-tests-series-100.sh
. ./tests/sc-tests-series-110.sh
. ./tests/sc-tests-series-120.sh

#
# [$1] - Tests to perform
#
function run_tests
{
  CNT_FAIL=0
  CNT_SUCCESS=0

  SC_LAST_CNT_SUCCESS=0
  SC_LAST_CNT_FAIL=0

  if [ '' == "$1" ]; then
    TESTS=(00 10 20 30 40 50 60 70 80 90 100 110 120)
  else
    TEST=$1
  fi

  for TEST in "${TESTS[@]}"; do

    if [ '00' == "$TEST" ]; then
      # Series 00 - Test internal functions
      _series 00

    elif [ '10' == "$TEST" ]; then
      # Series 10 - Test configuration / initialisation
      _series 10

    elif [ '20' == "$TEST" ]; then
      # Series 20 - Add shortcut
      _series 20 1 "'sc -a'"
      _series 20 2 "'sc --add'"
      _series 20 3 "'scadd'"

    elif [ '30' == "$TEST" ]; then
      # Series 30 - Update shortcut
      _series 30 1 "'sc -u'"
      _series 30 2 "'sc --update'"
      _series 30 3 "'scupdate'"

    elif [ '40' == "$TEST" ]; then
      # Series 40 - Delete shortcut
      _series 40 1 "'sc -d'"
      _series 40 2 "'sc --delete'"
      _series 40 3 "'scdelete'"

    elif [ '50' == "$TEST" ]; then
      # Series 50 - Label shortcut
      _series 50 1 "'sc -l'"
      _series 50 2 "'sc --label'"
      _series 50 3 "'sclabel'"

    elif [ '60' == "$TEST" ]; then
      # Series 60 - Rename shortcut
      _series 60 1 "'sc -r'"
      _series 60 2 "'sc --rename'"
      _series 60 3 "'screname'"

    elif [ '70' == "$TEST" ]; then
      # Series 70 - Get shortcut
      _series 70 1 "'sc -g'"
      _series 70 2 "'sc --get'"
      _series 70 3 "'scget'"

    elif [ '80' == "$TEST" ]; then
      # Series 80 - List shortcuts
      _series 80 1 "'sc'"

    elif [ '90' == "$TEST" ]; then
      # Series 90 - Export shortcuts
      _series 90 1 "'sc -e'"
      _series 90 2 "'sc --export'"
      _series 90 3 "'scexport'"

    elif [ '100' == "$TEST" ]; then
      # Series 100 - Change theme
      _series 100 1 "'sc -t'"
      _series 100 2 "'sc --theme'"
      _series 100 3 "'sctheme'"

    elif [ '110' == "$TEST" ]; then
      # Series 110 - Get version info
      _series 110 1 "'sc -v'"
      _series 110 2 "'sc --version'"
      _series 110 3 "'scversion'"

    elif [ '120' == "$TEST" ]; then
      # Series 110 - Get version info
      _series 120 1 "'sc -h'"
      _series 120 2 "'sc --help'"
      _series 120 3 "'schelp'"

    fi

  done

  _log_echo ''
  _log_echo "SUCCESS=$CNT_SUCCESS"
  _log_echo "FAIL=$CNT_FAIL"
  _log_echo ''
  _log_echo "Time=$SECONDS seconds"

  _log_final_totals

  # Finalise logs
  _finalise_logs
}


# INITIALISE ###

SC_TEST='Y'

# Turn on message param debugging
SC_DEBUG='Y'

# Define default paths
. ./sc-paths.sh

SC_DIR_TEST='/tmp/sc'

# Initialise logs
_init_logs

_exec_null rm -r "$SC_DIR_TEST"
_exec_null mkdir "$SC_DIR_TEST"
_exec_null mkdir "${SC_DIR_TEST}/config"
_exec_null cp -r "${PWD}/help" "${SC_DIR_TEST}/help"
_exec_null cp -r "${PWD}/themes" "${SC_DIR_TEST}/themes"

# Clear down test directorys
if [ -d "$SC_DIR_SHORTCUTS" ]; then
  rm -r "$SC_DIR_SHORTCUTS"
fi

_exec_null mkdir "${SC_DIR_SHORTCUTS}"
_exec_null mkdir "${SC_DIR_TARGETS}"
_exec_null mkdir "${SC_DIR_LABELS}"

SC_FILE="./sc.sh"

# Load sc command functions
. $SC_FILE


# RUN TESTS ###

TESTS=(00 10 20 30 40 50 60 70 80 90 100 110 120)

run_tests $TESTS

