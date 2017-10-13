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
# Series 70 - Get shortcut
#
# $1 - Command ( sc -g | sc --get | scget )
#
function series_70
{
  # EXP = Expected output from command
  # ACT = Actual output captured from command

  local SERIES=70
  local LOOP=$1
  local CMD=$2

  _clear_shortcuts

  ### 70.10 - Get shortcut ###

    local TEST_LVL1=10
    local TESTNO="${SERIES}.${TEST_LVL1}"

    local SHORTCUT=$( _name_shortcut $SERIES $TEST_LVL1  )
    local TARGET=$( _name_target $SERIES $TEST_LVL1  )

    # Create the shortcut

      _exec_null mkdir "$TARGET"
      _exec_null scadd "$SHORTCUT" "$TARGET"

    ## 70.10.10 - check shortcut

      _verify_shortcut "$SHORTCUT" "$TARGET" '' $LOOP $TESTNO 10

    ## 70.10.20 - get shortcut

      local EXP="$TARGET"
      local ACT=$( eval "$CMD" "$SHORTCUT" )
      # Test expected output
      _test_output "$EXP" "$ACT" $LOOP $TESTNO 20

  ### 70.20 - Get shortcut - not found ###

    local TESTNO=20
    local SHORTCUT=$( _name_shortcut $SERIES $TESTNO )

    # Do not create a shortcut

    # Run test
    local EXP='[ NULL ]'
    local ACT=$( eval "$CMD" "$SHORTCUT" )
    _test_output "$EXP" "$ACT" $LOOP $SERIES $TESTNO
}
