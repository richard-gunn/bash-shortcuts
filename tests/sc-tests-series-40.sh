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
# Series 40 - Delete shortcut
#
# $1 - Command ( sc -d | sc --delete | scdelete )
#
function series_40
{
  # EXP = Expected output from command
  # ACT = Actual output captured from command

  local SERIES=40
  local LOOP=$1
  local CMD=$2

  ### 40.10 - Delete a shortcut - no label ###

    local TEST_LVL1=10
    local TESTNO="${SERIES}.${TEST_LVL1}"

    local SHORTCUT1=$( _name_shortcut $SERIES $TEST_LVL1 1 )
    local TARGET1=$( _name_target $SERIES $TEST_LVL1 1 )

    local SHORTCUT2=$( _name_shortcut $SERIES $TEST_LVL1 2 )
    local TARGET2=$( _name_target $SERIES $TEST_LVL1 2 )

    # Create two shortcuts

      _exec_null mkdir $TARGET1
      _exec_null mkdir $TARGET2
      _exec_null scadd "$SHORTCUT1" "$TARGET1"
      _exec_null scadd "$SHORTCUT2" "$TARGET2"

    ## 40.10.10 - Assert that first shortcut exists

      _verify_shortcut "$SHORTCUT1" "$TARGET1" '' $LOOP $TESTNO 10

    ## 40.10.20 - Assert that second shortcut exists

      _verify_shortcut "$SHORTCUT1" "$TARGET1" '' $LOOP $TESTNO 20

    ## 40.10.30 - Delete second shortcut

      local EXP=$( _sc_message 'I' 40 10 "$SHORTCUT2" )
      local ACT=$( eval "$CMD" "$SHORTCUT2" )
      # Text expected output
      _test_output "$EXP" "$ACT" $LOOP $TESTNO 30

    ## 40.10.40 - Assert that first shortcut is untouched

      _verify_shortcut "$SHORTCUT1" "$TARGET1" '' $LOOP $TESTNO 40

    ## 40.10.50 - Assert that second shortcut has been deleted

      _assert_shortcut_absent "$SHORTCUT2" $LOOP $TESTNO 50

  ### 40.20 - Delete a shortcut - label ###

    local TEST_LVL1=20
    local TESTNO="${SERIES}.${TEST_LVL1}"

    local SHORTCUT1=$( _name_shortcut $SERIES $TEST_LVL1 1 )
    local TARGET1=$( _name_target $SERIES $TEST_LVL1 1 )
    local LABEL1=$( _name_label $SERIES $TEST_LVL1 1 )

    local SHORTCUT2=$( _name_shortcut $SERIES $TEST_LVL1 2 )
    local TARGET2=$( _name_target $SERIES $TEST_LVL1 2 )
    local LABEL2=$( _name_label $SERIES $TEST_LVL1 2 )

    # Create two shortcuts

      _exec_null mkdir $TARGET1
      _exec_null mkdir $TARGET2
      _exec_null scadd "$SHORTCUT1" "$TARGET1" "'$LABEL1'"
      _exec_null scadd "$SHORTCUT2" "$TARGET2" "'$LABEL2'"

    ## 40.20.10 - Assert that first shortcut exists

      _verify_shortcut "$SHORTCUT1" "$TARGET1" "$LABEL1" $LOOP $TESTNO 10

    ## 40.20.20 - Assert that second shortcut exists

      _verify_shortcut "$SHORTCUT1" "$TARGET1" "$LABEL1" $LOOP $TESTNO 20

    ## 40.20.30 - Delete second shortcut

      local EXP1=$( _sc_message 'I' 40 20 "$SHORTCUT2" )
      local EXP2=$( _sc_message 'I' 40 10 "$SHORTCUT2" )
      local EXP=$( echo -e "${EXP1}\n${EXP2}" )
      local ACT=$( eval "$CMD" "$SHORTCUT2" )
      # Text expected output
      _test_output "$EXP" "$ACT" $LOOP $TESTNO 30

    ## 40.20.40 - Assert that first shortcut is untouched

      _verify_shortcut "$SHORTCUT1" "$TARGET1" "$LABEL1" $LOOP $TESTNO 40

    ## 40.20.50 - Assert that second shortcut has been deleted

      _assert_shortcut_absent "$SHORTCUT2" $LOOP $TESTNO 50

  ### 40.30 - Delete a shortcut - Not deleted ###

    local TEST_LVL1=30
    local TESTNO="${SERIES}.${TEST_LVL1}"

    local SHORTCUT=$( _name_shortcut $SHORTCUT $TEST_LVL1 )

    # Create shortcut

      _exec_null scadd "$SHORTCUT"

    # 40.30.10 - Assert shortcut exists

      _verify_shortcut "$SHORTCUT" '' '' $LOOP $TESTNO 10

    # Remove write permissions to links directory

      _exec_null chmod -w "$SC_DIR_TARGETS"

    # 40.30.20 - Run test

      local EXP=$( _sc_message 'E' 40 30 "$SHORTCUT" )
      local ACT=$( eval "$CMD" "$SHORTCUT" )
      _test_output "$EXP" "$ACT" $LOOP $TESTNO 20

    # Restore write permissions to links directory

      _exec_null chmod +w "$SC_DIR_TARGETS"

    # 40.30.30 - Assert shortcut still exists

      _verify_shortcut "$SHORTCUT" '' '' $LOOP $TESTNO 30

  ### 40.40 - Delete a shortcut - Not found ###

    local TEST_LVL1=40
    local TESTNO="${SERIES}.${TEST_LVL1}"

    local SHORTCUT=$( _name_shortcut $SERIES $TEST_LVL1 )

    ## 40.40.10 - Assert that second shortcut has been deleted

      _assert_shortcut_absent "$SHORTCUT2" $LOOP $TESTNO 10

    ## 40.40.20 - Try to delete shortcut

      local EXP=$( _sc_message 'E' 40 40 "$SHORTCUT" )
      local ACT=$( eval "$CMD" "$SHORTCUT" )
      # Test expected output
      _test_output "$EXP" "$ACT" $LOOP $TESTNO 20

  ### 40.50 - Delete a shortcut - Cannot delete label ###

    local TEST_LVL1=50
    local TESTNO="${SERIES}.${TEST_LVL1}"

    local SHORTCUT=$( _name_shortcut $SERIES $TEST_LVL1 )
    local TARGET=$( _name_target $SERIES $TEST_LVL1 )
    local LABEL=$( _name_label $SERIES $TEST_LVL1 )

    # Create shortcut with label

      _exec_null mkdir "$TARGET"
      _exec_null scadd "$SHORTCUT" "$TARGET" "'$LABEL'"

    ## 40.50.10 - Assert that shortcut exists

      _verify_shortcut "$SHORTCUT" "$TARGET" "$LABEL" $LOOP $TESTNO 10

    # Remove write permissions to labels directory

      _exec_null chmod -w "$SC_DIR_LABELS"

    ## 40.50.20 - Attempt to delete shortcut

      local EXP=$( _sc_message 'E' 40 50 "$SHORTCUT" )
      local ACT=$( eval "$CMD" "$SHORTCUT" )
      _test_output "$EXP" "$ACT" $LOOP $TESTNO 20

    # Restore write permissions to labels directory

      _exec_null chmod +w "$SC_DIR_LABELS"

    ## 40.50.30 - Assert that second shortcut exists

      _verify_shortcut "$SHORTCUT" "$TARGET" "$LABEL" $LOOP $TESTNO 30
}
