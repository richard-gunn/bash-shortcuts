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
# Series 50 - Label shortcut
#
# $1 - Command ( sc -l | sc --label | sclabel )
#
function series_50 {

  # EXP = Expected output from command
  # ACT = Actual output captured from command

  local SERIES=50
  local LOOP=$1
  local CMD=$2

  _clear_shortcuts

  ### 50.10 - Label a shortcut ###

    local TEST_LVL1=10
    local TESTNO="${SERIES}.${TEST_LVL1}"

    local SHORTCUT=$( _name_shortcut $SERIES $TEST_LVL1 )
    local TARGET=$( _name_target $SERIES $TEST_LVL1 )
    local LABEL=$( _name_label $SERIES $TEST_LVL1 )

    # Create a shortcut

      _exec_null mkdir "$TARGET"
      _exec_null scadd "$SHORTCUT" "$TARGET"

    ## 50.10.10 - Check the shortcut

      _verify_shortcut "$SHORTCUT" "$TARGET" '' $LOOP $TESTNO 10

    ## 50.10.20 - Label the shortcut

      local EXP=$( _sc_message 'I' 50 10 "$SHORTCUT" "$LABEL" )
      local ACT=$( eval "$CMD" "$SHORTCUT" "'$LABEL'" )
      # Test expected output
      _test_output "$EXP" "$ACT" $LOOP $TESTNO 20

    ## 50.10.30 - Check the label

      _verify_shortcut "$SHORTCUT" "$TARGET" "$LABEL" $LOOP $TESTNO 30

  ### 50.20 - Label a shortcut - could not add label ###

    local TESTNO=20
    local SHORTCUT=$( _name_shortcut $SERIES $TESTNO )
    local LABEL=$( _name_label $SERIES $TESTNO )

    # Create a shortcut

      _exec_null scadd "$SHORTCUT"

    # Remove write permissions on labels directory

      _exec_null chmod -w "$SC_DIR_LABELS"

    # Run test

      local EXP=$( _sc_message 'E' 50 20 "$SHORTCUT" "$LABEL" )
      local ACT=$( eval "$CMD" "$SHORTCUT" "'$LABEL'" )
      # Test expected output
      _test_output "$EXP" "$ACT" $LOOP $SERIES $TESTNO

    # Restore write permissions on labels directory

      _exec_null chmod +w "$SC_DIR_LABELS"

  ### 50.30 - Label a shortcut - shortcut not found ###

    local TESTNO=30
    local SHORTCUT=$( _name_shortcut $SERIES $TESTNO )
    local LABEL=$( _name_label $SERIES $TESTNO )

    # Don't create shortcut

    # Run test
    local EXP=$( _sc_message 'E' 50 30 "$SHORTCUT" "$LABEL" )
    local ACT=$( eval "$CMD" "$SHORTCUT" "'$LABEL'" )
    # Test expected output
    _test_output "$EXP" "$ACT" $LOOP $SERIES $TESTNO
}
