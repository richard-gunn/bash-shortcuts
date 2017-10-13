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
# Series 30 - Update shortcut target ###
#
# $1 - Command ( sc -u | sc --update | scupdate )
#
function series_30
{
  # EXP = Expected output from command
  # ACT = Actual output captured from command

  local LOOP=$1
  local CMD=$2
  local SERIES=30

  _clear_shortcuts

  ### 30.10 - Update shortcut - no params

    # Command - scupdate

    local TESTNO=10

    ## 30.10.10 - create shortcut ##

      local SHORTCUT=$( basename $PWD )
      local SHORTCUT_SANE=$( _sc_sanitise_name $( basename $PWD ) )
      local TARGET1=$( _name_target $SERIES $TESTNO 1 )
      local TARGET2='.'

      _exec_null mkdir $TARGET1
      _exec_null scadd $SHORTCUT $TARGET1

      # Verify shortcut
      _verify_shortcut $SHORTCUT_SANE $TARGET1 '' $LOOP $SERIES $TESTNO 10

    ## 30.10.20 - update shortcut

      local EXP1=$( _sc_message 'I' 20 05 "$SHORTCUT" "$SHORTCUT_SANE" )
      local EXP2=$( _sc_message 'I' 30 10 "$SHORTCUT_SANE" "$PWD" )
      local EXP=$( echo -e "$EXP1\n$EXP2" )
      local ACT=$( eval "$CMD" )
      # Test expected output
      _test_output "$EXP" "$ACT" $LOOP $SERIES $TESTNO 20

    ## 30.10.30 - verify shortcut

      # Verify shortcut
      _verify_shortcut $SHORTCUT_SANE $PWD '' $LOOP $SERIES $TESTNO 30

  ### 30.20 - Update shortcut - with shortcut name

    # Command - scupdate <shortcut name>

    local TESTNO=20

    ## 30.20.10 - create shortcut ##

      local SHORTCUT=$( _name_shortcut $SERIES $TESTNO )
      local TARGET1=$( _name_target $SERIES $TESTNO 1 )

      _exec_null mkdir $TARGET1
      _exec_null scadd $SHORTCUT $TARGET1

      # Verify shortcut
      _verify_shortcut $SHORTCUT $TARGET1 '' $LOOP $SERIES $TESTNO 10

    ## 30.20.20 - update shortcut

      local EXP=$( _sc_message 'I' 30 10 "$SHORTCUT" "$PWD" )
      local ACT=$( eval "$CMD" "$SHORTCUT" )
      # Test expected output
      _test_output "$EXP" "$ACT" $LOOP $SERIES $TESTNO 20

    ## 30.20.30 - verify shortcut

      # Verify shortcut
      _verify_shortcut $SHORTCUT $PWD '' $LOOP $SERIES $TESTNO 30

  ### 30.30 - Update shortcut - with PWD target ###

    # Command - scupdate <shortcut name> .

    local TESTNO=30

    ## 30.30.10 - Create shortcut ###

      local SHORTCUT=$( _name_shortcut $SERIES $TESTNO )
      local TARGET1=$( _name_target $SERIES $TESTNO 1 )
      local TARGET2='.'

      # Create target directory
      _exec_null mkdir $TARGET1
      # Create shortcut
      _exec_null scadd $SHORTCUT $TARGET1
      # Check shortcut
      _verify_shortcut $SHORTCUT $TARGET1 '' $LOOP $SERIES $TESTNO 10

    ## 30.30.20 - Update shortcut - PWD target ###

      local EXP=$( _sc_message 'I' 30 10 "$SHORTCUT" "$PWD" )
      local ACT=$( eval "$CMD" "$SHORTCUT" "$TARGET2" )
      # Test expected output
      _test_output "$EXP" "$ACT" $LOOP $SERIES $TESTNO 20

    ## 30.30.30 - Check shortcut points to PWD target ###

      _verify_shortcut $SHORTCUT $PWD '' $LOOP $SERIES $TESTNO 30

  ### 30.40 - Update shortcut - with target ###

    # Command - scupdate <shortcut name> <target dir>

    local TESTNO=40

    ## 30.40.10 - create new shortcut ###

      local SHORTCUT=$( _name_shortcut $SERIES $TESTNO )
      local TARGET1=$( _name_target $SERIES $TESTNO 1 )
      local TARGET2=$( _name_target $SERIES $TESTNO 2 )

      # Create target directories
      _exec_null mkdir $TARGET1
      _exec_null mkdir $TARGET2

      # Creat shortcut
      _exec_null scadd $SHORTCUT $TARGET1

      # Check shortcut
      _verify_shortcut $SHORTCUT $TARGET1 '' $LOOP $SERIES $TESTNO 10

    ## 30.40.20 - Update shortcut - Target ###

      local EXP=$( _sc_message 'I' 30 10 "$SHORTCUT" "$TARGET2" )
      local ACT=$( eval "$CMD" "$SHORTCUT" "$TARGET2" )
      # Test expected output
      _test_output "$EXP" "$ACT" $LOOP $SERIES $TESTNO 20

    ## 30.40.30 - Check shortcut points to second target ###

      _verify_shortcut $SHORTCUT $TARGET2 '' $LOOP $SERIES $TESTNO 30

  ### 30.50 - Update shortcut - with target and label ###

    # Command - scupdate <shortcut name> <target dir> <label>

    local TESTNO=50

    ## 30.50.10 - create new shortcut ###

      local SHORTCUT=$( _name_shortcut $SERIES $TESTNO  )
      local TARGET1=$( _name_target $SERIES $TESTNO 1 )
      local LABEL1=$( _name_label $SERIES $TESTNO 1 )
      local LABEL2=$( _name_label $SERIES $TESTNO 2 )

      # Create target directories
      _exec_null mkdir $TARGET1

      # Creat shortcut
      _exec_null scadd $SHORTCUT $TARGET1 "'$LABEL1'"

      # Check shortcut
      _verify_shortcut $SHORTCUT $TARGET1 "$LABEL1" $LOOP $SERIES $TESTNO 10

    ## 30.50.20 - Update shortcut - Target ###

      local EXP1=$( _sc_message 'I' 30 10 "$SHORTCUT" "$TARGET1" )
      local EXP2=$( _sc_message 'I' 50 10 "$SHORTCUT" "$LABEL2" )
      local EXP=$( echo -e "$EXP1\n$EXP2" )
      local ACT=$( eval "$CMD" "$SHORTCUT" "$TARGET1" "'$LABEL2'" )
      # Test expected output
      _test_output "$EXP" "$ACT" $LOOP $SERIES $TESTNO 20

    ## 30.50.30 - Check shortcut points to second target ###

      _verify_shortcut $SHORTCUT $TARGET1 "$LABEL2" $LOOP $SERIES $TESTNO 30
}
