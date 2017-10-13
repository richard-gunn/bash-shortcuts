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
# _sc_exec_null - Execute commands and redirect STDOUT and STDERR to null device
#
function _sc_exec_null
{
  eval "$@" > /dev/null 2>&1
}

#
# _sc_create_list - Create shortcut list
#
function _sc_create_list
{
  # Delete existing list
  _sc_delete_list

  for F in $( ls -A "$SC_DIR_TARGETS" ); do
    # Check for existence of shortcut label
    if [ -f "$SC_DIR_LABELS/$F" ]; then
      # Show shortcut with label
      local SC_LABEL=$( cat "$SC_DIR_LABELS/$F" )
      local SC_LINE=$( _sc_message 'D' 80 30 "$F" "$SC_LABEL" )
      echo -n "$SC_LINE" >> "$SC_LIST"

    else
      # No label for shortcut - show path instead
      local SC_PATH=$( cat "$SC_DIR_TARGETS/$F" )
      local SC_LINE=$( _sc_message 'D' 80 35 "$F" "$SC_PATH" )
      echo -n "$SC_LINE" >> "$SC_LIST"

    fi
    echo -e "$TXT_RST" >> "$SC_LIST"
  done
}

#
# _sc_delete_list - Delete shortcut list
#
function _sc_delete_list
{
  # Delete existing list file
  if [ -f "$SC_LIST" ]; then
    rm "$SC_LIST"
  fi
}

#
# _sc_init - Initialise
#
function _sc_init
{
  # Load default paths
  if [ ! -n "$SC_BASE_DIR" ];then
    . "${HOME}/.bash-shortcuts/sc-paths.sh"
  fi

  # Check shortcut directory exists
  if [ ! -d "${SC_DIR_SHORTCUTS}" ]; then
    _sc_message 'E' 10 10 "${SC_DIR_SHORTCUTS}"
    return 1
  fi

  # Check shortcut links directory exists
  if [ ! -d "${SC_DIR_TARGETS}" ]; then
    _sc_message 'E' 10 20 "${SC_DIR_TARGETS}"
    return 1
  fi

  # Check shortcut labels directory exists
  if [ ! -d "$SC_DIR_LABELS" ]; then
    _sc_message 'E' 10 30 "$SC_DIR_LABELS"
    return 1
  fi

  # Terminal text color escape codes

  # Load colour declarations
  if [ -f "${SC_DIR_THEMES}/colours.sh" ]; then
      . "${SC_DIR_THEMES}/colours.sh"
  else
    _sc_message 'E' 10 40 "${SC_DIR_THEMES}/colours.sh"
    return 1
  fi

  # Load theme
  local THEME_NAME=$( cat "$SC_LINK_THEME" )
  local PATH_THEME="${SC_DIR_THEMES}/${THEME_NAME}-theme.sh"

  if [ -f "$PATH_THEME" ]; then
      . "$PATH_THEME"
  else
    if [ -f "${SC_DIR_THEMES}/default.theme" ]; then
        . "${SC_DIR_THEMES}/default.theme"
    else
      _sc_message 'E' 10 50 "${SC_DIR_THEMES}/default.theme"
      return 1
    fi
  fi

  return 0
}

#
# _sc_list_partial
#
# $@ - Partial Matches
#
function _sc_list_partial {

  for F in $@; do
    # Check for existence of shortcut label
    if [ -f "$SC_DIR_LABELS/$F" ]; then
      # Show shortcut with label
      local SC_LABEL=$( cat "$SC_DIR_LABELS/$F" )
      local SC_LINE=$( _sc_message 'D' 80 30 "$F" "$SC_LABEL" )
      echo -n "$SC_LINE"

    else
      # No label for shortcut - show path instead
      local SC_PATH=$( cat "$SC_DIR_TARGETS/$F" )
      local SC_LINE=$( _sc_message 'D' 80 35 "$F" "$SC_PATH" )
      echo -n "$SC_LINE"
    fi
    echo -e $TXT_RST
  done
}

#
# Display Info Message
#
# $1 - Type: 'E'=Error, 'I'=Info, 'D'=Display
# $2 - Info Message Major Number
# $3 - Info Message Minor Number
# $4..n - Additional parameters for error text (shifted down 3)
#
function _sc_message
{
  local TYPE=$1
  local MAJ=$2
  local MIN=$3
  shift 3

  if [ "$TYPE" == 'E' ]; then
    local PREFIX=$SC_ERR_PRE
  elif [ "$TYPE" == 'I' ]; then
    local PREFIX=$SC_INF_PRE
  else
    local PREFIX=''
  fi

  # Add message params for debug purposes
  if [ "$SC_DEBUG" == 'Y' ]; then
    local PREFIX="$PREFIX [$MAJ:$MIN] "
  fi

  local LF="\n" ; local SQ="'"  ; local DQ='"'
  local AR='->' ; local TB="\t" ; local IN='~'
  local BL='('  ; local BR=')'

  local SC_MSG="${PREFIX}\${SC_MSG_$MAJ[$MIN]}"
  local SC_MSG=$( eval echo "$SC_MSG" )
  eval echo -e "${SC_MSG_PRE}${SC_MSG}" | sed -e "s/~/  /g"
}

#
# _sc_name_bash_variable - Translate shortcut name to BASH variable name
#
#   $1 - Shortcut name
#
function _sc_name_bash_variable
{
  local VARNAME="SHCUT_"$( echo "$1" | tr '[:lower:]-.' '[:upper:]__')
  echo $VARNAME
}

#
# _sc_sanitise_name - Sanitize shortcut name
#
#   $1 - name to be sanitised
#
function _sc_sanitise_name
{
  # Shortcut names can only contain lower-case alpha, digits and hyphens

  # Convert upper to lower and underscores/spaces to hyphens
  local SC_NAME=$( echo "$1" | tr '[:upper:]_ ' '[:lower:]--')

  # Remove everything that isn't a lower character, digit or hyphen
  local SC_NAME=$( echo "$SC_NAME" | tr -dc '[:lower:][:digit:]-')

  echo $SC_NAME
}

#
# scadd - Add a shortcut
#
#   $1 - shortcut name
#   $2 - target directory
#   $3 - label
#   $4 - update existing shortcut
#
function scadd
{
  # If first param not set then shortcut name is basename of current directory
  if [ '' = "$1" ]; then
    local SHORTCUT=$( basename `pwd` )
  else
    local SHORTCUT=$1
  fi

  # If second param not set then target becomes current directory
  if [ '' = "$2" ] || [ '.' = "$2" ]; then
    local TARGET=$( pwd )
  else
    local TARGET=$2
  fi

  local LABEL=$3
  local UPDATE=$4

  # Sanitize shortcut name
  local SANE_NAME=$( _sc_sanitise_name "$SHORTCUT" )

  if [ "$SHORTCUT" != "$SANE_NAME" ];then
    # Use sanitized shortcut name
    _sc_message 'I' 20 05 "$SHORTCUT" "$SANE_NAME"
    local SHORTCUT="$SANE_NAME"
  fi;

  # Ensure target is a directory
  if [ -d "$TARGET" ]; then

    # Handle existing shortcut
    if [ -f "$SC_DIR_TARGETS/$SHORTCUT" ]; then

      # Remove existing shortcut if update option used
      if [ 'Y' = "$UPDATE" ]; then
        _sc_exec_null rm "$SC_DIR_TARGETS/$SHORTCUT"
        if [ 0 -ne $? ]; then
          # Problem replacing shortcut
          _sc_message 'E' 20 50 "$SHORTCUT"
          return
        fi
      else
        # Shortcut already exists
        _sc_message 'E' 20 20 "$SHORTCUT"
        return
      fi

    fi

    # Create new shortcut
    #_sc_exec_null echo "$TARGET" > "$SC_DIR_TARGETS/$SHORTCUT"
    echo "$TARGET" 2>/dev/null > "$SC_DIR_TARGETS/$SHORTCUT"
    if [ 0 -eq $? ]; then
      if [ 'Y' = "$UPDATE" ]; then
        # Shortcut update
        _sc_message 'I' 30 10 "$SHORTCUT" "$TARGET"
      else
        # Shortcut added
        _sc_message 'I' 20 10 "$SHORTCUT" "$TARGET"
      fi
      # Create label if specified
      if [ "$LABEL" != '' ]; then
        sclabel "$SHORTCUT" "$LABEL"
      fi
      # Cause the shortcut to be rebuilt the next time it's required
      _sc_delete_list
    else
      # Could not create shortcut
      _sc_message 'E' 20 30 "$SHORTCUT"
    fi
    return

  else

    # Target directory not found
    _sc_message 'E' 20 40 "$SHORTCUT" "$TARGET"
    return

  fi
}

#
# scdelete - Delete a shortcut
#
#   $1 - symbolic link (shortcut) name
#
function scdelete
{
  # Shortcut name
  local SHORTCUT=$1
  local UPDATE=0

  # Remove label text
  if [ -f "$SC_DIR_LABELS/$SHORTCUT" ]; then
    _sc_exec_null rm "$SC_DIR_LABELS/$SHORTCUT"
    if [ 0 -eq $? ]; then
      # Label deleted
      _sc_message 'I' 40 20 "$SHORTCUT"
      UPDATE=1
    else
      # Label could not be deleted
      _sc_message 'E' 40 50 "$SHORTCUT"
      return
    fi
  fi

  # Remove shortcut file
  if [ -f "$SC_DIR_TARGETS/$SHORTCUT" ]; then
    _sc_exec_null rm "$SC_DIR_TARGETS/$SHORTCUT"
    if [ 0 -eq $? ]; then
      # Shortcut deleted
      _sc_message 'I' 40 10 "$SHORTCUT"
      UPDATE=1
    else
      # Could not delete
      _sc_message 'E' 40 30 "$SHORTCUT"
      return
    fi
  else
    # Shortcut not found
    _sc_message 'E' 40 40 "$SHORTCUT"
    UPDATE=1
  fi

  if [ $UPDATE -eq 1 ]; then
    # Cause the list to be rebuilt the next time it's called
    _sc_delete_list
  fi
}

#
# scexport - Create BASH variables for shortcuts
#
# Example: 'music' is exported to $SC_MUSIC
#
function scexport
{
  #echo -e "\nsc: Exporting shortcuts to BASH variables:\n"
  _sc_message 'D' 90 10

  for F in $( ls -A "$SC_DIR_TARGETS" ); do
    local SC_PATH=$( cat "$SC_DIR_TARGETS/$F" )
    local VARNAME=$( _sc_name_bash_variable "$F" )
    echo -en "${TXT_SC_NAM}${VARNAME}${TXT_SC_DFT}=${TXT_SC_DSC}${SC_PATH}${TXT_RST}\n"
    export "$VARNAME"="$SC_PATH"
  done
  echo -e $TXT_RST
}

#
# scget - Get directory path for a shortcut
#
#   $1 - shortcut name
#
function scget
{
  local SHORTCUT=$1

  if [ -f "$SC_DIR_TARGETS/$SHORTCUT" ]; then
    echo -en $( cat "$SC_DIR_TARGETS/$SHORTCUT" )
  fi
}

#
# schelp - Display command help
#
function schelp
{
  _sc_message 'D' 00 10 "$SC_VERSION"
  cat "$SC_HELP"
  return
}

#
# sclabel - Label a shortcut
#
#   $1 - shortcut name
#   $2 - label text
#
function sclabel
{
  # Shortcut name
  local SHORTCUT=$1
  local LABEL=$2

  # Create a text file in the shortcut labels directory
  if [ -f "$SC_DIR_TARGETS/$SHORTCUT" ]; then
    echo $LABEL 2> /dev/null > "$SC_DIR_LABELS/$SHORTCUT"
    if [ 0 -eq $? ]; then
      # Shortcut label added
      _sc_message 'I' 50 10 "$SHORTCUT" "$LABEL"
      # Update the shortcut list the next time it's required
      _sc_delete_list
    else
      # Could not label shortcut
      _sc_message 'E' 50 20 "$SHORTCUT" "$LABEL"
    fi
    return
  else
    # Shortcut not found
    _sc_message 'E' 50 30 "$SHORTCUT"
    return
  fi
}

#
# sclist - List shortcuts
#
function sclist
{
  # Create list if necessacry
  if [ ! -f "${SC_LIST}" ];then
    _sc_create_list
  fi

  if [ -f "${SC_LIST}" ];then
    _sc_message 'D' 80 20
    cat $SC_LIST
    _sc_message 'D' 80 40
  else
    # No shortcuts to list
    _sc_message 'I' 80 10
  fi
}

#
# screname - Rename an existing shortcut
#
# $1 - shortcut name
# $2 - new shortcut name
#
function screname {

  # Shortcut name
  local SHORTCUT=$1
  # New shortcut name
  local NEWSHORTCUT=$2

  # Ensure that the shortcut file already exists
  if [ -f "$SC_DIR_TARGETS/$SHORTCUT" ]; then

    # Ensure that the new shortcut file does not already exist
    if [ -f "$SC_DIR_TARGETS/$NEWSHORTCUT" ]; then
      # Cannot rename as new shortcut name already exists
      _sc_message 'E' 60 20 "$SHORTCUT" "$NEWSHORTCUT"
      return
    fi

    # Rename the symbolic link
    _sc_exec_null mv "$SC_DIR_TARGETS/$SHORTCUT" "$SC_DIR_TARGETS/$NEWSHORTCUT"
    if [ 0 -eq $? ]; then

      if [ -f "$SC_DIR_LABELS/$SHORTCUT" ]; then
        # Rename the label
        _sc_exec_null mv "$SC_DIR_LABELS/$SHORTCUT" "$SC_DIR_LABELS/$NEWSHORTCUT"
        if [ 0 -eq $? ]; then
          # Shortcut renamed
          _sc_message 'I' 60 10 "$SHORTCUT" "$NEWSHORTCUT"
          # Update the shortcuts list file
          _sc_delete_list
          return
        else
          # Revert the symbolic link back to it's original name
          _sc_exec_null mv "$SC_DIR_TARGETS/$NEWSHORTCUT" "$SC_DIR_TARGETS/$SHORTCUT"
          # Cannot rename label
          _sc_message 'E' 60 30 "$SHORTCUT"
          return
        fi
      else
        # Shortcut renamed
        _sc_message 'I' 60 10 "$SHORTCUT" "$NEWSHORTCUT"
        # Update the shortcuts list file
        _sc_delete_list
        return
      fi

    else
      # Cannot create new shortcut
      _sc_message 'E' 60 40 "$SHORTCUT"
      return
    fi

  else
    # Shortcut not found
    _sc_message 'E' 60 50 "$SHORTCUT"
    return
  fi
}

#
# sctheme - change the theme link
#
# $1 - theme name corresponding to ./themes/<theme-name>.sh
#
function sctheme {

  # Requested theme name
  local THEME_NAME=$1

  # Full path to them file
  local THEME_PATH="${SC_DIR_THEMES}/${THEME_NAME}-theme.sh"

  # Check for existence of theme file
  if [ -f "$THEME_PATH" ]; then
    # Create new theme link
    #ln -s -f "$THEME_PATH" "$SC_LINK_THEME"
    echo "$THEME_NAME" 2> /dev/null > "$SC_LINK_THEME"
    # Run theme declarations
    . "$THEME_PATH"
    # Rebuild shortcut list with new theme
    _sc_delete_list
    # Theme changed
    _sc_message 'I' 100 10 "$THEME_NAME"
  else
    # Cannot find theme file
    _sc_message 'E' 100 20 "$THEME_NAME"
  fi
}

#
# scupdate - Update a shortcut target and label
#
#   $1 - symbolic link (shortcut) name
#   $2 - target directory
#   $3 - label
#
function scupdate
{
  scadd "$1" "$2" "$3" 'Y'
}

#
# scversion - Display version info
#
function scversion
{
  _sc_message 'D' 00 10 $SC_VERSION
}
