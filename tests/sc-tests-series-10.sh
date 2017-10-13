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
# Series 10 - Check installation ###
#
function series_10
{
  local SERIES=10

  _exec_null rm -r "$SC_DIR_SHORTCUTS"

  # 10.10 - Check shortcut directory ###

    local TESTNO=10

    # Run test
    local EXP=$( _sc_message 'E' 10 10 "${SC_DIR_SHORTCUTS}" )
    local ACT=$( _sc_init )
    _test_output "$EXP" "$ACT" 0 $SERIES $TESTNO

    _exec_null mkdir "${SC_DIR_SHORTCUTS}"

  # 10.20 - Check links directory ###

    local TESTNO=20

    # Run test
    local EXP=$( _sc_message 'E' 10 20 "${SC_DIR_TARGETS}" )
    local ACT=$( _sc_init )
    _test_output "$EXP" "$ACT" 0 $SERIES $TESTNO

    _exec_null mkdir "${SC_DIR_TARGETS}"

  # 10.30 - Check labels directory ###

    local TESTNO=30

    # Run test
    local EXP=$( _sc_message 'E' 10 30 "${SC_DIR_LABELS}" )
    local ACT=$( _sc_init )
    _test_output "$EXP" "$ACT" 0 $SERIES $TESTNO

    _exec_null mkdir "${SC_DIR_LABELS}"
}

