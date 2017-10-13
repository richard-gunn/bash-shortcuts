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
# Series 80 - List shortcuts ###
#
# $1 - Loop
# $2 - Command ( sc )
#
function series_80
{
  # EXP = Expected output from command
  # ACT = Actual output captured from command

  local SERIES=80
  local LOOP=$1
  local CMD=$2

  _clear_shortcuts

  ### 80.10 - List shortcuts - sc ###

  local TEST_LVL1=10
  local TESTNO="${SERIES}.${TEST_LVL1}"

    ## 80.10.10 - List shortcuts - none defined ###

      # Run test
      local EXP=$( _sc_message 'I' 80 10 )
      local ACT=$( eval "$CMD" )
      _test_output "$EXP" "$ACT" $LOOP $TESTNO 10

    ## 80.10.20 - List shortcuts - one defined ###

      local SHORTCUT1="mm-$( _name_shortcut $SERIES $TEST_LVL1 2 )"
      local LABEL1=$( _name_label $SERIES $TEST_LVL1 2 )
      local TARGET1=$( _name_target $SERIES $TEST_LVL1 2 )

      # Create target directory
      _exec_null mkdir "$TARGET1"

      # Create shortcut with label
      _exec_null scadd "$SHORTCUT1" "$TARGET1" "'$LABEL1'"

      # Run test
      local EXP1=$( _sc_message 'D' 80 20 )
      local EXP2=$( _sc_message 'D' 80 30 "$SHORTCUT1" "$LABEL1" )
      local EXP3=$( _sc_message 'D' 80 40 )
      local EXP=$( echo -e "${EXP1}\n\n${EXP2}\n${EXP3}" )
      local ACT=$( "$CMD" )
      _test_output "$EXP" "$ACT" $LOOP $TESTNO 20

    ## 80.10.30 - List shortcuts - several defined ###

      local SHORTCUT2="aa-$( _name_shortcut $SERIES $TEST_LVL1 2 )"
      local TARGET2=$( _name_target $SERIES $TEST_LVL1 2 )

      # Create target directory
      _exec_null mkdir "$TARGET2"

      # Create shortcut without label
      _exec_null scadd "$SHORTCUT2" "$TARGET2"

      # Run test
      local EXP1=$( _sc_message 'D' 80 20 )
      local EXP2=$( _sc_message 'D' 80 35 "$SHORTCUT2" "$TARGET2" )
      local EXP3=$( _sc_message 'D' 80 30 "$SHORTCUT1" "$LABEL1" )
      local EXP4=$( _sc_message 'D' 80 40 )
      local EXP=$( echo -e "${EXP1}\n\n${EXP2}\n${EXP3}\n${EXP4}" )
      local ACT=$( "$CMD" )
      # Test expected output
      _test_output "$EXP" "$ACT" $LOOP $TESTNO 30

  ### 80.20 - Use shortcut - sc <shortcut name> ###

    local TEST_LVL1=20
    local TESTNO="${SERIES}.${TEST_LVL1}"

    local SHORTCUT=$( _name_shortcut $SERIES $TEST_LVL1 )
    local TARGET=$( _name_target $SERIES $TEST_LVL1 )

    ## 80.20.10 - create shortcut

      _exec_null mkdir "$TARGET"
      _exec_null scadd "$SHORTCUT" "$TARGET"
      _verify_shortcut "$SHORTCUT" "$TARGET" '' $LOOP $TESTNO 10

    ## 80.20.20 - use shortcut - check output

      local EXP='[ NULL ]'
      local ACT=$( $CMD "$SHORTCUT" )
      # Test expected output
      _test_output "$EXP" "$ACT" $LOOP $TESTNO 20

    ## 80.20.30 - use shortcut - check directory

      # Save current working directory
      local CWD=$( pwd )

      # Use the shortcut
      _exec_null $CMD "$SHORTCUT"

      local ACT=$( pwd )
      local EXP="$TARGET"

      # Restore current working directory
      cd $CWD

      # Test expected output
      _test_output "$EXP" "$ACT" $LOOP $TESTNO 30

  ### 80.30 - Use shortcut - sc <partial shortcut name> ###

    local TEST_LVL1=30
    local TESTNO="${SERIES}.${TEST_LVL1}"

    local SHORTCUT1=$( _name_shortcut $SERIES $TEST_LVL1 1 )
    local TARGET1=$( _name_target $SERIES $TEST_LVL1 1 )
    local SHORTCUT2=$( _name_shortcut $SERIES $TEST_LVL1 2 )
    local TARGET2=$( _name_target $SERIES $TEST_LVL1 2 )
    local SHORTCUT3=$( _name_shortcut $SERIES $TEST_LVL1 3 )
    local TARGET3=$( _name_target $SERIES $TEST_LVL1 3 )

    ## 80.30.05 - Create shortcuts

      _exec_null mkdir "$TARGET1"
      _exec_null mkdir "$TARGET2"
      _exec_null mkdir "$TARGET3"
      _exec_null scadd "$SHORTCUT1" "$TARGET1"
      _exec_null scadd "$SHORTCUT2" "$TARGET2"
      _verify_shortcut  "$SHORTCUT1" "$TARGET1" '' $LOOP $TESTNO 05 10
      _verify_shortcut  "$SHORTCUT2" "$TARGET2" '' $LOOP $TESTNO 05 20

    ## 80.30.10 - No match ##

      local EXP1=$( _sc_message 'I' 80 50 "$SHORTCUT3" )
      local EXP2=$( _sc_message 'I' 80 60 "$SHORTCUT3" )
      local EXP=$( echo -e "${EXP1}\n${EXP2}" )
      local ACT=$( $CMD "$SHORTCUT3" )
      # Test expected output
      _test_output "$EXP" "$ACT" $LOOP $TESTNO 10

    ## 80.30.20 - Partial shortcut name - Single match ##

      ## 80.30.20.10 - Test output ##

        local SUFFIX1="${SERIES}-${TEST_LVL1}-1"
        local EXP1=$( _sc_message 'I' 80 50 "$SUFFIX1" )
        local EXP2=$( _sc_message 'I' 80 70 "$SUFFIX1" "$SHORTCUT1" )
        local EXP=$( echo -e "${EXP1}\n${EXP2}" )
        local ACT=$( $CMD "$SUFFIX1" )
        # Test expected output
        _test_output "$EXP" "$ACT" $LOOP $TESTNO 20 10

      ## 80.30.20.20 - Test changed directory ##

        # Save current working directory
        local CWD=$( pwd )

        # Use the partial shortcut name
        _exec_null $CMD "$SUFFIX1"

        local ACT=$( pwd )
        local EXP="$TARGET1"

        # Restore current working directory
        cd $CWD

        # Test expected output
        _test_output "$EXP" "$ACT" $LOOP $TESTNO 20 20

    ## 80.30.30 - Partial shortcut name - Multiple matches ##

      local COMMON="${SERIES}-${TEST_LVL1}"
      local EXP1=$( _sc_message 'I' 80 50 "$COMMON" )
      local EXP2=$( _sc_message 'I' 80 80 "$COMMON" )
      local EXP3=$( _sc_message 'D' 80 35 "$SHORTCUT1" "$TARGET1" )
      local EXP4=$( _sc_message 'D' 80 35 "$SHORTCUT2" "$TARGET2" )
      local EXP=$( echo -e "${EXP1}\n${EXP2}\n\n${EXP3}\n${EXP4}" )
      local ACT=$( $CMD "$COMMON" )
      # Test expected output
      _test_output "$EXP" "$ACT" $LOOP $TESTNO 30
}
