#
# BASH Shortcuts - Messages
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
# Special markup for messages:
#
# ${LF} = Line feed
# ${SQ} = Single quote
# ${DQ} = Double quote
# ${AR} = Arrow (->)
# ${IN} = Indent with 2 spaces
# ${TB} = Tab character
# ${BL} = Left bracket
# ${RB} = Right bracket
#

# Error message prefix
SC_ERR_PRE='sc: Error - '

# Info message prefix
SC_INF_PRE='sc: Info - '

# 00 - General
SC_MSG_00[10]='${LF}BASH Shortcuts ${BL}sc${BR} Version [$1]${LF}'

# 10 - Installation and configuration
SC_MSG_10[10]='Shortcuts directory missing [$1]'
SC_MSG_10[20]='Links directory missing [$1]'
SC_MSG_10[30]='Labels directory missing [$1]'
SC_MSG_10[40]='Theme colours file missing [${SC_DIR_THEMES}/colours.sh]'
SC_MSG_10[50]='Default theme missing [${SC_DIR_THEMES}/default.theme]'

# 20 - Add shortcut
SC_MSG_20[05]='Shortcut name [$1] converted to [$2]'
SC_MSG_20[10]='Added shortcut [$1] with target [$2]'
SC_MSG_20[20]='Shortcut already exists [$1], try --update'
SC_MSG_20[30]='Could not create shortcut [$1]'
SC_MSG_20[40]='Target directory [$2] not found for shortcut [$1]'
SC_MSG_20[50]='Could not replace existing shortcut [$1]'

# 30 - Update shortcut
SC_MSG_30[10]='Updated shortcut [$1] to target [$2]'

# 40 - Delete shortcut
SC_MSG_40[10]='Shortcut [$1] deleted'
SC_MSG_40[20]='Label for shortcut [$1] deleted'
SC_MSG_40[30]='Could not delete shortcut [$1]'
SC_MSG_40[40]='Shortcut [$1] not found'
SC_MSG_40[50]='Could not delete label for shortcut [$1]'

# 50 - Label shortcut
SC_MSG_50[10]='Label [$2] added to shortcut [$1]'
SC_MSG_50[20]='Could not add label [$2] to shortcut [$1]'
SC_MSG_50[30]='Shortcut [$1] not found'

# 60 - Rename shortcut
SC_MSG_60[10]='Shortcut [$1] renamed to [$2]'
SC_MSG_60[20]='Cannot rename [$1] as [$2] already exists'
SC_MSG_60[30]='Could not rename shortcut label [$1]'
SC_MSG_60[40]='Could not create new shortcut [$1]'
SC_MSG_60[50]='Shortcut not found [$1]'

# 70 - Get shortcut

# 80 - List shortcuts
SC_MSG_80[10]='No shortcuts to list'
SC_MSG_80[20]='${LF}Available directory shortcuts:${LF}'
SC_MSG_80[30]='${IN}${SC_THM_NAM}${1} ${SC_THM_TXT}${AR} ${SC_THM_LAB}${2}${TXT_RST}'
SC_MSG_80[35]='${IN}${SC_THM_NAM}${1} ${SC_THM_TXT}${AR} [ ${2} ]${TXT_RST}'
SC_MSG_80[40]='${LF}Type ${SQ}sc -h${SQ} for help.${LF}'
SC_MSG_80[50]='No shortcut for [$1]'
SC_MSG_80[60]='Could not find a close match for [$1]'
SC_MSG_80[70]='Using closest match for [$1] which is [$2]'
SC_MSG_80[80]='There are several close matches for [$1]:${LF}'

# 90 - Export shortcuts
SC_MSG_90[10]='Exporting shortcuts to BASH variables:${LF}'

# 100 - Change theme
SC_MSG_100[10]='Theme changed to [$1]'
SC_MSG_100[20]='Cannot find theme file for [$1]'
