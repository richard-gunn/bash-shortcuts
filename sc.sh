#
# BASH Shortcuts
#
# <http://sourceforge.net/projects/bash-shortcuts/>
#
# Copyright (C) 2010, 2011 Richard Gunn
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

SC_VERSION='1.4.1'

# Load messages
. "${HOME}/.bash-shortcuts/sc-messages.sh"

# Load command functions
. "${HOME}/.bash-shortcuts/sc-commands.sh"

#
# sc - Main shortcuts command function
#
function sc
{
  # Help
  if [ '-?' = "$1" ] || [ '-h' = "$1" ] || [ '--help' = "$1" ]; then
    schelp
    return
  fi

  # Add a new shortcut
  if [ '-a' = "$1" ] || [ '--add' = "$1" ]; then
    scadd "$2" "$3" "$4" 'N'
    return
  fi

  # Delete an existing shortcut
  if [ '-d' = "$1" ] || [ '--delete' = "$1" ]; then
    scdelete "$2"
    return
  fi

  # Export shortcuts
  if [ '-e' = "$1" ] || [ '--export' = "$1" ]; then
    scexport
    return
  fi

  # Get directory path
  if [ '-g' = "$1" ] || [ '--get' = "$1" ]; then
    scget "$2"
    return
  fi

  # Add/update label
  if [ '-l' = "$1" ] || [ '--label' = "$1" ]; then
    sclabel "$2" "$3"
    return
  fi

  # Rename existing shortcut
  if [ '-r' = "$1" ] || [ '--rename' = "$1" ]; then
    screname "$2" "$3"
    return
  fi

  # Change theme
  if [ '-t' = "$1" ] || [ '--theme' = "$1" ]; then
    sctheme "$2"
    return
  fi

  # Update existing shortcut
  if [ '-u' = "$1" ] || [ '--update' = "$1" ]; then
    scupdate "$2" "$3" "$4"
    return
  fi

  # Update existing shortcut
  if [ '-v' = "$1" ] || [ '--version' = "$1" ]; then
    scversion
    return
  fi

  # List shortcuts
  if [ 0 -eq $# ]; then
    sclist
    return
  fi

  # Go to shortcut directory
  if [ -f "$SC_DIR_TARGETS/$1" ]; then
    cd $( cat "$SC_DIR_TARGETS/$1" )
  else
    #echo "sc: No shortcut for [$1]!"
    _sc_message 'I' 80 50 "$1"

    local MATCHES=()
    local MATCHES=$( ls "$SC_DIR_TARGETS" | awk -v MATCH="$1" '$0 ~ MATCH {print}' )

    # Convert to an array
    local MATCHES=(${MATCHES[@]})

    # Get size of array
    local CNT_MATCHES=$( echo ${#MATCHES[@]} )

    # No shortcut
    if [ 0 -eq "$CNT_MATCHES" ]; then
      #echo "sc: Could not find a close match for [$1]"
      _sc_message 'I' 80 60 "$1"

    # Exact match
    elif [ 1 -eq "$CNT_MATCHES" ]; then
      local SC=${MATCHES[0]}
      #echo "sc: Using closest match for [$1] which is [$SC]"
      _sc_message 'I' 80 70 "$1" "$SC"
      cd $( cat "$SC_DIR_TARGETS/$SC" )

    # Partial matches (prefixed)
    else
      #echo -e "sc: There are several close matches for [$1]:\n"
      _sc_message 'I' 80 80 "$1"
      _sc_list_partial ${MATCHES[@]}

    fi
  fi
}

if [ ! -n "$SC_TEST" ]; then
  # Initialise
  _sc_init
  # Delete the short-cut list (will be rebuilt when needed)
  if [ "$?" -eq 0 ]; then
    _sc_delete_list
  fi
fi
