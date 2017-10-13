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
# Series 100 - Set theme
#
# $1 - Loop
# $2 - Command ( sc -t | sc --theme | sctheme )
#
function series_100
{
  # EXP = Expected output from command
  # ACT = Actual output captured from command

  local SERIES=100
  local LOOP=$1
  local CMD=$2

  _clear_shortcuts

  ### 100.10 - change theme ###

    local TEST_LVL1=10
    local TESTNO="${SERIES}.${TEST_LVL1}"

    local THEME1='light'
    local THEME2='dark'

    # Set theme to default
    _exec_null sctheme "$THEME1"

    ## 100.10.10 - verify that theme link points to theme1

      local EXP="$THEME1"
      local ACT=$( cat "$SC_LINK_THEME" )
      # Test expected output
      _test_output "$EXP" "$ACT" $LOOP $TESTNO 10

    ## 100.10.20 - change theme

      local EXP=$( _sc_message 'I' 100 10 "$THEME2" )
      local ACT=$( eval "$CMD" "$THEME2" )
      # Test expected output
      _test_output "$EXP" "$ACT" $LOOP $TESTNO 20

    ## 100.10.30 - verify that theme link points to theme2

      local EXP="$THEME2"
      local ACT=$( cat "$SC_LINK_THEME" )
      # Test expected output
      _test_output "$EXP" "$ACT" $LOOP $TESTNO 30

  ### 100.20 - change theme - non existent ###

    local TEST_LVL1=20
    local TESTNO="${SERIES}.${TEST_LVL1}"

    local THEME1='dark'
    local THEME2='missing'

    # Set theme to default
    _exec_null sctheme "$THEME1"

    ## 100.20.10 - verify that theme link points to theme1

      local EXP="$THEME1"
      local ACT=$( cat "$SC_LINK_THEME" )
      # Test expected output
      _test_output "$EXP" "$ACT" $LOOP $TESTNO 10

    ## 100.20.20 - change theme

      local EXP=$( _sc_message 'E' 100 20 "$THEME2" )
      local ACT=$( eval "$CMD" "$THEME2" )
      # Test expected output
      _test_output "$EXP" "$ACT" $LOOP $TESTNO 20

    ## 100.20.30 - verify that theme link still points to theme1

      local EXP="$THEME1"
      local ACT=$( cat "$SC_LINK_THEME" )
      # Test expected output
      _test_output "$EXP" "$ACT" $LOOP $TESTNO 30
}
