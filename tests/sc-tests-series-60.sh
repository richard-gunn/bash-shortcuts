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
# Series 60 - Rename shortcut
#
# $1 - Command ( sc -r | sc --rename | screname )
#
function series_60
{
  # EXP = Expected output from command
  # ACT = Actual output captured from command

  local SERIES=60
  local LOOP=$1
  local CMD=$2

  _clear_shortcuts

  ### 60.10 - Rename shortcut ###

    local TEST_LVL1=10
    local TESTNO="${SERIES}.${TEST_LVL1}"

    local SHORTCUT1=$( _name_shortcut $SERIES $TEST_LVL1 1 )
    local SHORTCUT2=$( _name_shortcut $SERIES $TEST_LVL1 2 )
    local TARGET=$( _name_target $SERIES $TEST_LVL1 )
    local LABEL=$( _name_label $SERIES $TEST_LVL1 )

    # Create a shortcut

      _exec_null mkdir "$TARGET"
      _exec_null scadd "$SHORTCUT1" "$TARGET" "'$LABEL'"

    ## 60.10.10 - Assert shortcut exists

      _verify_shortcut "$SHORTCUT1" "$TARGET" "$LABEL" $LOOP $TESTNO 10

    ## 60.10.20 - Rename shortcut

      local EXP=$( _sc_message 'I' 60 10 "$SHORTCUT1" "$SHORTCUT2" )
      local ACT=$( eval "$CMD" "$SHORTCUT1" "$SHORTCUT2" )
      # Test expected output
      _test_output "$EXP" "$ACT" $LOOP $TESTNO 20

    ## 60.10.30 - Assert new shortcut exists

      _verify_shortcut "$SHORTCUT2" "$TARGET" "$LABEL" $LOOP $TESTNO 30

    ## 60.10.40 - Assert old shortcut deleted

      _assert_shortcut_absent "$SHORTCUT1" $LOOP $TESTNO 40

  ### 60.20 - Rename shortcut - new name already exists ###

    local TEST_LVL1=20
    local TESTNO="${SERIES}.${TEST_LVL1}"

    local SHORTCUT1=$( _name_shortcut $SERIES $TEST_LVL1 1 )
    local TARGET1=$( _name_target $SERIES $TEST_LVL1 1 )
    local LABEL1=$( _name_label $SERIES $TEST_LVL1 1 )
    local SHORTCUT2=$( _name_shortcut $SERIES $TEST_LVL1 2 )
    local TARGET2=$( _name_target $SERIES $TEST_LVL1 2 )
    local LABEL2=$( _name_label $SERIES $TEST_LVL1 2 )

    # Create target directories

      _exec_null mkdir "$TARGET1"
      _exec_null mkdir "$TARGET2"

    # Create shortcuts

      _exec_null scadd "$SHORTCUT1" "$TARGET1" "'$LABEL1'"
      _exec_null scadd "$SHORTCUT2" "$TARGET2" "'$LABEL2'"

    ## 60.20.10 - Verify shortcut 1

      _verify_shortcut "$SHORTCUT1" "$TARGET1" "$LABEL1" $LOOP $TESTNO 10

    ## 60.20.20 - Verify shortcut 2

      _verify_shortcut "$SHORTCUT2" "$TARGET2" "$LABEL2" $LOOP $TESTNO 20

    ## 60.20.30 - Rename shortcut

      local EXP=$( _sc_message 'E' 60 20 "$SHORTCUT1" "$SHORTCUT2" )
      local ACT=$( eval "$CMD" "$SHORTCUT1" "$SHORTCUT2" )
      # Test expected output
      _test_output "$EXP" "$ACT" $LOOP $TESTNO 30

    ## 60.20.40 - Verify shortcut 1 is unchanged

      _verify_shortcut "$SHORTCUT1" "$TARGET1" "$LABEL1" $LOOP $TESTNO 40

    ## 60.20.50 - Verify shortcut 2 is unchanged

      _verify_shortcut "$SHORTCUT2" "$TARGET2" "$LABEL2" $LOOP $TESTNO 50

  ### 60.30 - Rename shortcut - could not rename label file ###

    local TEST_LVL1=30
    local TESTNO="${SERIES}.${TEST_LVL1}"

    local SHORTCUT1=$( _name_shortcut $SERIES $TEST_LVL1 1 )
    local SHORTCUT2=$( _name_shortcut $SERIES $TEST_LVL1 2 )
    local TARGET=$( _name_target $SERIES $TEST_LVL1 )
    local LABEL=$( _name_label $SERIES $TEST_LVL1 )

    # Create a shortcut

      _exec_null mkdir "$TARGET"
      _exec_null scadd "$SHORTCUT1" "$TARGET" "'$LABEL'"

    ## 60.30.10 - verify shortcut

      _verify_shortcut "$SHORTCUT1" "$TARGET" "$LABEL" $LOOP $TESTNO 10

    # Remove write permissions on labels directory

      _exec_null chmod -w "$SC_DIR_LABELS"

    ## 60.30.20 - rename shortcut

      local EXP=$( _sc_message 'E' 60 30 "$SHORTCUT1" "$SHORTCUT2" )
      local ACT=$( eval "$CMD" "$SHORTCUT1" "$SHORTCUT2" )
      # Test expected output
      _test_output "$EXP" "$ACT" $LOOP $TESTNO 20

    # Restore write permissions on labels directory

      _exec_null chmod +w "$SC_DIR_LABELS"

    ## 60.30.30 - Check that the original shortcut is unchanged

      _verify_shortcut "$SHORTCUT1" "$TARGET" "$LABEL" $LOOP $TESTNO 30

    ## 60.30.40 - Check that the new shortcut was not created

      _assert_shortcut_absent "$SHORTCUT2" $LOOP $TESTNO 40

  ### 60.40 - Rename shortcut - could not create new shortcut ###

    local TEST_LVL1=40
    local TESTNO="${SERIES}.${TEST_LVL1}"

    local SHORTCUT1=$( _name_shortcut $SERIES $TEST_LVL1 1 )
    local SHORTCUT2=$( _name_shortcut $SERIES $TEST_LVL1 2 )
    local TARGET=$( _name_target $SERIES $TEST_LVL1 )
    local LABEL=$( _name_label $SERIES $TEST_LVL1 )

    # Create a shortcut

      _exec_null mkdir "$TARGET"
      _exec_null scadd "$SHORTCUT1" "$TARGET" "'$LABEL'"

    ## 60.40.10 - check shortcut

      _verify_shortcut "$SHORTCUT1" "$TARGET" "$LABEL" $LOOP $TESTNO 10

    # Remove write permissions on links directory

      _exec_null chmod -w "$SC_DIR_TARGETS"

    ## 60.40.20 - Rename shortcut

      local EXP=$( _sc_message 'E' 60 40 "$SHORTCUT1" "$SHORTCUT2" )
      local ACT=$( eval "$CMD" "$SHORTCUT1" "$SHORTCUT2" )
      # Test expected output
      _test_output "$EXP" "$ACT" $LOOP $TESTNO 20

      # Restore write permissions on links directory
      _exec_null chmod +w "$SC_DIR_TARGETS"

    ## 60.40.30 - Check that the original shortcut is unchanged

      _verify_shortcut "$SHORTCUT1" "$TARGET" "$LABEL" $LOOP $TESTNO 30

    ## 60.40.40 - Check that the new shortcut was not created

      _assert_shortcut_absent "$SHORTCUT2" $LOOP $TESTNO 40

  ### 60.50 - Rename shortcut - shortcut not found ###

    local TEST_LVL1=50
    local TESTNO="${SERIES}.${TEST_LVL1}"

    local SHORTCUT1=$( _name_shortcut $SERIES $TEST_LVL1 1 )
    local SHORTCUT2=$( _name_shortcut $SERIES $TEST_LVL1 2 )

    # Don't create a shortcut

    ## 60.50.10

      local EXP=$( _sc_message 'E' 60 50 "$SHORTCUT1" "$SHORTCUT2" )
      local ACT=$( eval "$CMD" "$SHORTCUT1" "$SHORTCUT2" )
      # Test expected output
      _test_output "$EXP" "$ACT" $LOOP $TESTNO 10

    ## 60.50.20 - Check that the new shortcut was not created

      _assert_shortcut_absent "$SHORTCUT2" $LOOP $TESTNO 20
}
