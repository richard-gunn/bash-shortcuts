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
# Series 90 - Export shortcuts
#
# $1 - Loop
# $2 - Command ( sc -e | sc --export | scexport )
#
function series_90
{
  # EXP = Expected output from command
  # ACT = Actual output captured from command

  local SERIES=90
  local LOOP=$1
  local CMD=$2

  _clear_shortcuts

  ### 90.10 - Test 10 ###

    local TEST_LVL1=10
    local TESTNO="${SERIES}.${TEST_LVL1}"

    local SHORTCUT1=$( _name_shortcut $SERIES $TEST_LVL1 1 )
    local TARGET1=$( _name_target $SERIES $TEST_LVL1 1 )

    local SHORTCUT2=$( _name_shortcut $SERIES $TEST_LVL1 2 )
    local TARGET2=$( _name_target $SERIES $TEST_LVL1 2 )

    # Create a shortcuts

      _exec_null mkdir "$TARGET1"
      _exec_null mkdir "$TARGET2"
      _exec_null scadd "$SHORTCUT1" "$TARGET1"
      _exec_null scadd "$SHORTCUT2" "$TARGET2"

    ## 90.10.10 - verify shortcut 1

      _verify_shortcut "$SHORTCUT1" "$TARGET1" '' $LOOP $TESTNO 10

    ## 90.10.20 - verify shortcut 2

      _verify_shortcut "$SHORTCUT2" "$TARGET2" '' $LOOP $TESTNO 20

    ## 90.10.30 - export shortcuts

      local EXPORT1=$( _sc_name_bash_variable $SHORTCUT1 )
      local EXPORT2=$( _sc_name_bash_variable $SHORTCUT2 )
      local EXP1=$( _sc_message 'D' 90 10 )
      local EXP2="${EXPORT1}=${TARGET1}"
      local EXP3="${EXPORT2}=${TARGET2}"
      local EXP=$( echo -e "${EXP1}\n\n${EXP2}\n${EXP3}\n" )
      local ACT=$( eval "$CMD" )
      # Test expected output
      _test_output "$EXP" "$ACT" $LOOP $TESTNO 30

      ## Run the command to make the exported variables available to this script
      _exec_null eval $CMD

    ## 90.10.40 - Test exported shortcut 1

      local EXP=${TARGET1}
      # Variable variable
      local ACT=${!EXPORT1}
      # Test expected output
      _test_output "$EXP" "$ACT" $LOOP $TESTNO 40

    ## 90.10.50 - Test exported shortcut 2

      local EXP=${TARGET2}
      # Variable variable
      local ACT=${!EXPORT2}
      # Test expected output
      _test_output "$EXP" "$ACT" $LOOP $TESTNO 50

    # Unset the BASH variables

      eval unset ${EXPORT1}
      eval unset ${EXPORT2}
}
