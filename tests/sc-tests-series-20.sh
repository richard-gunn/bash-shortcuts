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
# 20.10.10 - Add new shortcut - no params ###
#
#   $1 - Loop
#   $2 - Command ( sc -a | sc --add | scadd )
#
function _series_20_10_10
{
  # Command - scadd (no parameters)

  # New shortcut should point to current working directory and have the same
  # name as the directory (sanitized).

  local LOOP=$1
  local CMD=$2
  local SERIES=20
  local TEST_LVL1=10
  local TEST_LVL2=10
  local TESTNO="${SERIES}.${TEST_LVL1}.${TEST_LVL2}"

  local SHORTCUT=$( basename "$PWD" )
  local SANE_NAME=$( _sc_sanitise_name "$SHORTCUT" )

  ## 10 - Check that shortcut file does not exist ##

    _assert_file_node 'F' "${SC_DIR_TARGETS}/$SANE_NAME" 'N'  $LOOP $TESTNO 10

  ## 20 - Verify output from sc command ##

    # Check to see if shortcut name needs sanitising
    if [ "$SHORTCUT" != "$SANE_NAME" ]; then
      # Expected output will have message about sanitised shortcut name
      local EXP1=$( _sc_message 'I' 20 05 "$SHORTCUT" "$SANE_NAME" )
      local SHORTCUT=$SANE_NAME
      local EXP2=$( _sc_message 'I' 20 10 "$SHORTCUT" "$PWD" )
      local EXP=$( echo -e "$EXP1\n$EXP2" )
    else
      local EXP=$( _sc_message 'I' 20 10 "$SHORTCUT" "$PWD" )
    fi

    local ACT=$( eval "$CMD" )
    # Test expected output
    _test_output "$EXP" "$ACT" $LOOP $TESTNO 20

  ## 30 - Check that shortcut file has been created ##

    _assert_file_node 'F' "${SC_DIR_TARGETS}/$SANE_NAME" 'Y' $LOOP $TESTNO 30

  ## 40 - Check shortcut link target ##

    local EXP=$PWD
    local ACT=$( _get_shortcut_target "$SC_DIR_TARGETS/$SANE_NAME" )
    # Test expected output
    _test_output "$EXP" "$ACT" $LOOP $TESTNO 40
}

#
# 20.10.20 - Add new shortcut - name but no target ###
#
#   $1 - Loop
#   $2 - Command ( sc -a | sc --add | scadd )
#
function _series_20_10_20
{
  # Command - scadd <shortcut name>

  # New shortcut should point to current working directory and have the
  # specified shortcut name

  local LOOP=$1
  local CMD=$2
  local SERIES=20
  local TEST_LVL1=10
  local TEST_LVL2=20
  local TESTNO="${SERIES}.${TEST_LVL1}.${TEST_LVL2}"

  local SHORTCUT=$( _name_shortcut $SERIES $TEST_LVL1 $TEST_LVL2 )

  ## 10 - Check that shortcut file does not exist ##

    _assert_file_node 'F' "${SC_DIR_TARGETS}/$SHORTCUT" 'N'  $LOOP $TESTNO 10

  ## 20 - Add new shortcut - name but no target ##

    local EXP=$( _sc_message 'I' 20 10 "$SHORTCUT" "$PWD" )
    local ACT=$( eval "$CMD" "$SHORTCUT" )
    # Test expected output
    _test_output "$EXP" "$ACT" $LOOP $TESTNO 20

  ## 30 - Check that shortcut file has been created ##

    _assert_file_node 'F' "${SC_DIR_TARGETS}/$SHORTCUT" 'Y' $LOOP $TESTNO 30

  ## 40 - Check shortcut link target ##

    local EXP=$PWD
    local ACT=$( _get_shortcut_target "$SC_DIR_TARGETS/$SHORTCUT" )
    # Test expected output
    _test_output "$EXP" "$ACT" $LOOP $TESTNO 40
}

#
# 20.10.30 - Add new shortcut - name and PWD target ###
# 20.10.40 - Add new shortcut - name and target ###
#
#   $1 - Loop
#   $2 - Command ( sc -a | sc --add | scadd )
#   $3 - Test Level 2 (30|40)
#
function _series_20_10_30_or_40
{
  # Command - scadd <shortcut name> .

  # New shortcut should point to current working directory and have the
  # specified shortcut name

  local LOOP=$1
  local CMD=$2
  local SERIES=20
  local TEST_LVL1=10
  local TEST_LVL2=$3
  local TESTNO="${SERIES}.${TEST_LVL1}.${TEST_LVL2}"

  local SHORTCUT=$( _name_shortcut $SERIES $TEST_LVL1 $TEST_LVL2 )

  # Use PWD if test-level2 is 30 otherwise create a new target dir
  if [ "$TEST_LVL2" -eq 30 ];then
    local TARGET=$PWD
  else
    local TARGET=$( _name_target $SERIES $TEST_LVL1 $TEST_LVL2 )
    _exec_null mkdir $TARGET
  fi

  ## 10 - Check that shortcut file does not exist ##

    _assert_file_node 'F' "${SC_DIR_TARGETS}/$SHORTCUT" 'N'  $LOOP $TESTNO 10

  ## 20 - Add new shortcut - name and PWD or target ##

    local EXP=$( _sc_message 'I' 20 10 "$SHORTCUT" "$TARGET" )

    if [ "$TEST_LVL2" -eq 30 ];then
      local ACT=$( eval "$CMD" "$SHORTCUT" . )
    else
      local ACT=$( eval "$CMD" "$SHORTCUT" "$TARGET" )
    fi

    # Test expected output
    _test_output "$EXP" "$ACT" $LOOP $TESTNO 20

  ## 30 - Check that shortcut file has been created ##

    _assert_file_node 'F' "${SC_DIR_TARGETS}/$SHORTCUT" 'Y' $LOOP $TESTNO 30

  ## 40 - Check shortcut link target ##

    if [ "$TEST_LVL2" -eq 30 ];then
      local EXP=$PWD
    else
      local EXP=$TARGET
    fi

    local ACT=$( _get_shortcut_target "$SC_DIR_TARGETS/$SHORTCUT" )
    # Test expected output
    _test_output "$EXP" "$ACT" $LOOP $TESTNO 40
}

#
# 20.10.50 - Add new shortcut - name, PWD and label ###
# 20.10.60 - Add new shortcut - name, target and label ###
#
#   $1 - Loop
#   $2 - Command ( sc -a | sc --add | scadd )
#   $3 - Test Level 2 (50|60)
#
function _series_20_10_50_or_60
{
  # Command - scadd <shortcut name> . <label>

  # New shortcut should point to specified target and have the specified
  # shortcut name

  local LOOP=$1
  local CMD=$2
  local SERIES=20
  local TEST_LVL1=10
  local TEST_LVL2=$3
  local TESTNO="${SERIES}.${TEST_LVL1}.${TEST_LVL2}"

  local SHORTCUT=$( _name_shortcut $SERIES $TEST_LVL1 $TEST_LVL2 )

  # Use PWD if test-level2 is 50 otherwise create a new target dir
  if [ "$TEST_LVL2" -eq 50 ];then
    local TARGET=$PWD
  else
    local TARGET=$( _name_target $SERIES $TEST_LVL1 $TEST_LVL2 )
    _exec_null mkdir $TARGET
  fi

  local LABEL=$( _name_label $SERIES $TEST_LVL1 $TEST_LVL2 )

  ## 10 - Check that shortcut file does not exist ##

    _assert_file_node 'F' "${SC_DIR_TARGETS}/$SHORTCUT" 'N'  $LOOP $TESTNO 10

  ## 20 - Add new shortcut - with target and label ##

    local EXP1=$( _sc_message 'I' 20 10 "$SHORTCUT" "$TARGET" )
    local EXP2=$( _sc_message 'I' 50 10 "$SHORTCUT" "$LABEL" )
    local EXP=$( echo -e "${EXP1}\n${EXP2}" )

    if [ "$TEST_LVL2" -eq 50 ];then
      # Target is PWD
      local ACT=$( eval "$CMD" "$SHORTCUT" . "'$LABEL'" )
    else
      local ACT=$( eval "$CMD" "$SHORTCUT" "$TARGET" "'$LABEL'" )
    fi

    # Test expected output
    _test_output "$EXP" "$ACT" $LOOP $TESTNO 20

  ## 30 - Check that shortcut file has been created ##

    _assert_file_node 'F' "${SC_DIR_TARGETS}/$SHORTCUT" 'Y' $LOOP $TESTNO 30

  ## 40 - Check shortcut link target ##

    local EXP=$TARGET
    local ACT=$( _get_shortcut_target "$SC_DIR_TARGETS/$SHORTCUT" )
    # Test expected output
    _test_output "$EXP" "$ACT" $LOOP $TESTNO 40

  ## 50 - Check that shortcut label has been created ##

    _assert_file_node 'F' "${SC_DIR_LABELS}/$SHORTCUT" 'Y' $LOOP $TESTNO 50

  ## 60 - Check label text ##

    local EXP=$LABEL
    local ACT=$( _get_shortcut_label "$SHORTCUT" )
    # Test expected output
    _test_output "$EXP" "$ACT" $LOOP $TESTNO 60
}

#
# 20.20.10 - Add new shortcut - no params - shortcut exists ###
#
#   $1 - Loop
#   $2 - Command ( sc -a | sc --add | scadd )
#
function _series_20_20_10
{
  # Command - scadd (no parameters)

  # New shortcut should point to current working directory and have the same
  # name as the directory (sanitized).

  local LOOP=$1
  local CMD=$2
  local SERIES=20
  local TEST_LVL1=20
  local TEST_LVL2=10
  local TESTNO="${SERIES}.${TEST_LVL1}.${TEST_LVL2}"

  local SHORTCUT=$( basename $PWD )
  local SHORTCUT_SANE=$( _sc_sanitise_name $SHORTCUT )
  local TARGET=$( _name_target $SERIES $TEST_LVL1 $TEST_LVL2 )
  local LABEL=$( _name_label $SERIES $TEST_LVL1 $TEST_LVL2 )

  _clear_shortcuts

  # Create shortcut

    _exec_null mkdir "$TARGET"
    _exec_null scadd "$SHORTCUT" "$TARGET" "'$LABEL'"

  ## 10 - Verify shortcut details

    _verify_shortcut "$SHORTCUT_SANE" "$TARGET" "$LABEL" $LOOP $TESTNO 10

  ## 20 - Verify output from sc command ##

    # Check to see if shortcut name needs sanitising
    if [ "$SHORTCUT" != "$SHORTCUT_SANE" ]; then
      # Expected output will have message about sanitised shortcut name
      local EXP1=$( _sc_message 'I' 20 05 "$SHORTCUT" "$SHORTCUT_SANE" )
      local EXP2=$( _sc_message 'E' 20 20 "$SHORTCUT_SANE" )
      local EXP=$( echo -e "$EXP1\n$EXP2" )
    else
      local EXP=$( _sc_message 'I' 20 10 "$SHORTCUT" )
    fi

    local ACT=$( eval "$CMD" )
    # Test expected output
    _test_output "$EXP" "$ACT" $LOOP $TESTNO 20

  ## 30 - Verify shortcut details

    _verify_shortcut "$SHORTCUT_SANE" "$TARGET" "$LABEL" $LOOP $TESTNO 30
}

#
# 20.20.20 - Add new shortcut - name but no target - shortcut exists ###
#
#   $1 - Loop
#   $2 - Command ( sc -a | sc --add | scadd )
#
function _series_20_20_20
{
  # Command - scadd <shortcut name>

  # New shortcut should point to current working directory and have the same
  # name as the directory (sanitized).

  local LOOP=$1
  local CMD=$2
  local SERIES=20
  local TEST_LVL1=20
  local TEST_LVL2=20
  local TESTNO="${SERIES}.${TEST_LVL1}.${TEST_LVL2}"

  local SHORTCUT=$( _name_shortcut $SERIES $TEST_LVL1 $TEST_LVL2 )
  local TARGET=$( _name_target $SERIES $TEST_LVL1 $TEST_LVL2 )
  local LABEL=$( _name_label $SERIES $TEST_LVL1 $TEST_LVL2 )

  _clear_shortcuts

  # Create shortcut

    _exec_null mkdir "$TARGET"
    _exec_null scadd "$SHORTCUT" "$TARGET" "'$LABEL'"

  ## 10 - Verify shortcut details

    _verify_shortcut "$SHORTCUT" "$TARGET" "$LABEL" $LOOP $TESTNO 10

  ## 20 - Verify output from sc command ##

    local EXP=$( _sc_message 'E' 20 20 "$SHORTCUT" )
    local ACT=$( eval "$CMD" "$SHORTCUT" )
    # Test expected output
    _test_output "$EXP" "$ACT" $LOOP $TESTNO 20

  ## 20 - Verify shortcut details

    _verify_shortcut "$SHORTCUT" "$TARGET" "$LABEL" $LOOP $TESTNO 30
}

#
# 20.20.30 - Add new shortcut - name with PWD target - shortcut exists ###
#
#   $1 - Loop
#   $2 - Command ( sc -a | sc --add | scadd )
#
function _series_20_20_30
{
  # Command - scadd <shortcut name> .

  # New shortcut should point to current working directory and have the same
  # name as the directory (sanitized).

  local LOOP=$1
  local CMD=$2
  local SERIES=20
  local TEST_LVL1=20
  local TEST_LVL2=30
  local TESTNO="${SERIES}.${TEST_LVL1}.${TEST_LVL2}"

  local SHORTCUT=$( _name_shortcut $SERIES $TEST_LVL1 $TEST_LVL2 )
  local TARGET=$( _name_target $SERIES $TEST_LVL1 $TEST_LVL2 )
  local LABEL=$( _name_label $SERIES $TEST_LVL1 $TEST_LVL2 )

  _clear_shortcuts

  # Create shortcut

    _exec_null mkdir "$TARGET"
    _exec_null scadd "$SHORTCUT" "$TARGET" "'$LABEL'"

  ## 10 - Verify shortcut details

    _verify_shortcut "$SHORTCUT" "$TARGET" "$LABEL" $LOOP $TESTNO 10

  ## 20 - Verify output from sc command ##

    local EXP=$( _sc_message 'E' 20 20 "$SHORTCUT" )
    local ACT=$( eval "$CMD" "$SHORTCUT" . )
    # Test expected output
    _test_output "$EXP" "$ACT" $LOOP $TESTNO 20

  ## 30 - Verify shortcut details

    _verify_shortcut "$SHORTCUT" "$TARGET" "$LABEL" $LOOP $TESTNO 30
}

#
# 20.20.40 - Add new shortcut - name with target - shortcut exists ###
#
#   $1 - Loop
#   $2 - Command ( sc -a | sc --add | scadd )
#
function _series_20_20_40
{
  # Command - scadd <shortcut name> <target dir>

  # New shortcut should point to current working directory and have the same
  # name as the directory (sanitized).

  local LOOP=$1
  local CMD=$2
  local SERIES=20
  local TEST_LVL1=20
  local TEST_LVL2=40
  local TESTNO="${SERIES}.${TEST_LVL1}.${TEST_LVL2}"

  local SHORTCUT=$( _name_shortcut $SERIES $TEST_LVL1 $TEST_LVL2 )
  local TARGET1=$( _name_target $SERIES $TEST_LVL1 $TEST_LVL2 1 )
  local TARGET2=$( _name_target $SERIES $TEST_LVL1 $TEST_LVL2 2 )
  local LABEL=$( _name_label $SERIES $TEST_LVL1 $TEST_LVL2 )

  _clear_shortcuts

  _exec_null mkdir "$TARGET1"
  _exec_null mkdir "$TARGET2"

  # Create shortcut

    _exec_null scadd "$SHORTCUT" "$TARGET1" "'$LABEL'"

  ## 10 - Verify shortcut details

    _verify_shortcut "$SHORTCUT" "$TARGET1" "$LABEL" $LOOP $TESTNO 10

  ## 20 - Verify output from sc command ##

    local EXP=$( _sc_message 'E' 20 20 "$SHORTCUT" )
    local ACT=$( eval "$CMD" "$SHORTCUT" "$TARGET2" )
    # Test expected output
    _test_output "$EXP" "$ACT" $LOOP $TESTNO 20

  ## 30 - Verify shortcut details

    _verify_shortcut "$SHORTCUT" "$TARGET1" "$LABEL" $LOOP $TESTNO 30
}

#
# 20.20.50 - Add new shortcut - name, PWD target and label - shortcut exists ###
#
#   $1 - Loop
#   $2 - Command ( sc -a | sc --add | scadd )
#
function _series_20_20_50
{
  # Command - scadd <shortcut name> . <label>

  # New shortcut should point to current working directory and have the same
  # name as the directory (sanitized).

  local LOOP=$1
  local CMD=$2
  local SERIES=20
  local TEST_LVL1=20
  local TEST_LVL2=50
  local TESTNO="${SERIES}.${TEST_LVL1}.${TEST_LVL2}"

  local SHORTCUT=$( _name_shortcut $SERIES $TEST_LVL1 $TEST_LVL2 )
  local TARGET1=$( _name_target $SERIES $TEST_LVL1 $TEST_LVL2 1 )
  local LABEL1=$( _name_label $SERIES $TEST_LVL1 $TEST_LVL2 1 )
  local LABEL2=$( _name_label $SERIES $TEST_LVL1 $TEST_LVL2 2 )

  _clear_shortcuts

  # Create shortcut

    _exec_null mkdir "$TARGET1"
    _exec_null scadd "$SHORTCUT" "$TARGET1" "'$LABEL1'"

  ## 10 - Verify shortcut details

    _verify_shortcut "$SHORTCUT" "$TARGET1" "$LABEL1" $LOOP $TESTNO 10

  ## 20 - Verify output from sc command ##

    local EXP=$( _sc_message 'E' 20 20 "$SHORTCUT" )
    local ACT=$( eval "$CMD" "$SHORTCUT" . "$LABEL2" )
    # Test expected output
    _test_output "$EXP" "$ACT" $LOOP $TESTNO 20

  ## 30 - Verify shortcut details

    _verify_shortcut "$SHORTCUT" "$TARGET1" "$LABEL1" $LOOP $TESTNO 30
}

#
# 20.20.60 - Add new shortcut - name, target and label - shortcut exists ###
#
#   $1 - Loop
#   $2 - Command ( sc -a | sc --add | scadd )
#
function _series_20_20_60
{
  # Command - scadd <shortcut name> <target dir> <label>

  # New shortcut should point to current working directory and have the same
  # name as the directory (sanitized).

  local LOOP=$1
  local CMD=$2
  local SERIES=20
  local TEST_LVL1=20
  local TEST_LVL2=60
  local TESTNO="${SERIES}.${TEST_LVL1}.${TEST_LVL2}"

  local SHORTCUT=$( _name_shortcut $SERIES $TEST_LVL1 $TEST_LVL2 )
  local TARGET1=$( _name_target $SERIES $TEST_LVL1 $TEST_LVL2 1 )
  local TARGET2=$( _name_target $SERIES $TEST_LVL1 $TEST_LVL2 2 )
  local LABEL1=$( _name_label $SERIES $TEST_LVL1 $TEST_LVL2 1 )
  local LABEL2=$( _name_label $SERIES $TEST_LVL1 $TEST_LVL2 2 )

  _clear_shortcuts

  _exec_null mkdir "$TARGET1"
  _exec_null mkdir "$TARGET2"

  # Create shortcut

    _exec_null scadd "$SHORTCUT" "$TARGET1" "'$LABEL1'"

  ## 10 - Verify shortcut details

    _verify_shortcut "$SHORTCUT" "$TARGET1" "$LABEL1" $LOOP $TESTNO 10

  ## 20 - Verify output from sc command ##

    local EXP=$( _sc_message 'E' 20 20 "$SHORTCUT" )
    local ACT=$( eval "$CMD" "$SHORTCUT" "$TARGET2" "$LABEL2" )
    # Test expected output
    _test_output "$EXP" "$ACT" $LOOP $TESTNO 20

  ## 30 - Verify shortcut details

    _verify_shortcut "$SHORTCUT" "$TARGET1" "$LABEL1" $LOOP $TESTNO 30
}

#
# Series 20 - Add shortcut ###
#
# $1 - Loop
# $2 - Command ( sc -a | sc --add | scadd )
#
function series_20
{
  # EXP = Expected output from command
  # ACT = Actual output captured from command

  local SERIES=20
  local LOOP=$1
  local CMD=$2

  _clear_shortcuts

  ### 20.10 - Add new shortcut

    # 20.10.10 - Add new shortcut - no params ###

      _series_20_10_10 $LOOP "$CMD"

    # 20.10.20 - Add new shortcut - name but no target ###

      _series_20_10_20 $LOOP "$CMD"

    # 20.10.30 - Add new shortcut - name with PWD target ###

      _series_20_10_30_or_40 $LOOP "$CMD" 30

    # 20.10.40 - Add new shortcut - name with target ###

      _series_20_10_30_or_40 $LOOP "$CMD" 40

    # 20.10.50 - Add new shortcut - name with PWD and label ###

      _series_20_10_50_or_60 $LOOP "$CMD" 50

    # 20.10.60 - Add new shortcut - name with target and label ###

      _series_20_10_50_or_60 $LOOP "$CMD" 60

  ### 20.20 - Add new shortcut / shortcut exists ###

    # 20.20.10 - Add new shortcut - no params ###

      _series_20_20_10 $LOOP "$CMD"

    # 20.20.20 - Add new shortcut - name but no target ###

      _series_20_20_20 $LOOP "$CMD"

    # 20.20.30 - Add new shortcut - name with PWD target ###

      _series_20_20_30 $LOOP "$CMD"

    # 20.20.40 - Add new shortcut - name with target ###

      _series_20_20_40 $LOOP "$CMD"

    # 20.20.50 - Add new shortcut - name with PWD target and label ###

      _series_20_20_50 $LOOP "$CMD"

    # 20.20.60 - Add new shortcut - name with target and label ###

      _series_20_20_60 $LOOP "$CMD"

  ### 20.30 - Add new shortcut / cannot create link ###

    local TESTNO=30
    local SHORTCUT=$( _name_shortcut $SERIES $TESTNO )

    # Remove write privilege from shortcuts links directory
    _exec_null chmod -w "${SC_DIR_TARGETS}"

    # Run test
    local EXP=$( _sc_message 'E' $SERIES 30 "$SHORTCUT" )
    local ACT=$( eval "$CMD" "$SHORTCUT" "${SC_DIR_SHORTCUTS}" )
    _test_output "$EXP" "$ACT" $LOOP $SERIES $TESTNO

    # Restore write privilege from shortcuts links directory
    _exec_null chmod +w "${SC_DIR_TARGETS}"

  ### 20.40 - Add new shortcut / target directory not found ###

    local TESTNO=40
    local SHORTCUT=$( _name_shortcut $SERIES $TESTNO )
    local TARGET='/non/existent/directory'

    # Run test
    local EXP=$( _sc_message 'E' $SERIES 40 "$SHORTCUT" "$TARGET")
    local ACT=$( eval "$CMD" $SHORTCUT "$TARGET" )
    _test_output "$EXP" "$ACT" $LOOP $SERIES $TESTNO
}
