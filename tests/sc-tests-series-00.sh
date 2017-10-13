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
# Series 00 - tests
#
function series_00 {

  local SERIES=0
  local LOOP=0

  # 05 - Examine version variable ###

    if [ "$SC_VERSION" == '' ]; then
      _log_fail 'Version value is null' $LOOP $SERIES 05
    else
      _log_pass 'Version value is not null' $LOOP $SERIES 05
    fi

  # Test internal function _sc_message
    SC_MSG_TEST[10]='Test message. Param1=[$1]. Param2=[$2]'
    SC_MSG_TEST[20]='${IN}StringA ${TB}${AR} ${TB}StringB'

  # Turn off message param debugging
    SC_DEBUG='N'

  # 10 - Test Info Message ###
    local EXP='sc: Info - Test message. Param1=[One]. Param2=[Two]'
    local ACT=$( _sc_message 'I' TEST 10 'One' 'Two' )
    # Test expected output
    _test_output "$EXP" "$ACT" $LOOP $SERIES 10

  # 20 - Test Error Message ###
    local EXP='sc: Error - Test message. Param1=[One]. Param2=[Two]'
    local ACT=$( _sc_message 'E' TEST 10 'One' 'Two' )
    # Test expected output
    _test_output "$EXP" "$ACT" $LOOP $SERIES 20

  # 30 - Test Display Message ###
    local EXP=$( echo -e "  StringA \t-> \tStringB" )
    local ACT=$( _sc_message 'D' TEST 20 )
    # Test expected output
    _test_output "$EXP" "$ACT" $LOOP $SERIES 30

  # Turn on message param debugging
    SC_DEBUG='Y'

  # 40 - Test Shortcut name santise ###
    local SHORTCUT='@#Mixed Case With Spaces and_Underscores_and Numbers 123#@'
    local EXP='mixed-case-with-spaces-and-underscores-and-numbers-123'
    local ACT=$( _sc_sanitise_name "$SHORTCUT" )
    # Test expected output
    _test_output "$EXP" "$ACT" $LOOP $SERIES 40

  # 50 - Test shortcut name creation
    local EXP='shortcut-1-2-3-4-5'
    local ACT=$( _name_shortcut 1 2 3 4 5 )
    # Test expected output
    _test_output "$EXP" "$ACT" $LOOP $SERIES 50

  # 60 - Test label name creation
    local EXP='Label 1.2.3.4.5'
    local ACT=$( _name_label 1 2 3 4 5 )
    # Test expected output
    _test_output "$EXP" "$ACT" $LOOP $SERIES 60

  # 70 - Test target dir name creation
    local EXP="${SC_DIR_TEST}/target-1-2-3-4-5"
    local ACT=$( _name_target 1 2 3 4 5 )
    # Test expected output
    _test_output "$EXP" "$ACT" $LOOP $SERIES 70

  # 80 - Test naming of BASH shortcut variables
    local SHORTCUT='shortcut-1-2-3'
    local EXP="SHCUT_SHORTCUT_1_2_3"
    local ACT=$( _sc_name_bash_variable "$SHORTCUT" )
    # Test expected output
    _test_output "$EXP" "$ACT" $LOOP $SERIES 80

  # 90 - Check that the help file is present

    if [ -f "$SC_HELP" ];then
      _log_pass 'Check that the help file is present' $LOOP $SERIES 90
    else
      _log_fail 'Check that the help file is present' $LOOP $SERIES 90
    fi
}
