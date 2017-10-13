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
# Series 120 - Get help info
#
# $1 - Loop
# $2 - Command ( sc -h | sc --help | schelp )
#
function series_120
{
  # EXP = Expected output from command
  # ACT = Actual output captured from command

  local SERIES=120
  local LOOP=$1
  local CMD=$2

  ### 110.10 - Examine help info ###

    local EXP1=$( _sc_message 'D' 00 10 "$SC_VERSION" )
    local EXP2=$( eval cat "$SC_HELP" )
    local EXP=$( echo -e "${EXP1}\n\n${EXP2}" )
    local ACT=$( eval $CMD )
    # Test expected output
    _test_output "$EXP" "$ACT" $LOOP $SERIES 10

}
