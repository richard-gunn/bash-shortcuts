#
# BASH Shortcuts - Default Paths
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

# Base directory
if [ -n "$SC_TEST" ]; then
  SC_DIR_BASE='/tmp/sc'
else
  SC_DIR_BASE="${HOME}/.bash-shortcuts"
fi
# Config directory
SC_DIR_CONFIG="${SC_DIR_BASE}/config"
# Shortcuts directory
SC_DIR_SHORTCUTS="${SC_DIR_BASE}/shortcuts"
# Targets for shortcuts
SC_DIR_TARGETS="${SC_DIR_SHORTCUTS}/targets"
# Labels for shortcuts
SC_DIR_LABELS="${SC_DIR_SHORTCUTS}/labels"
# Shortcut list file
SC_LIST="${SC_DIR_SHORTCUTS}/list.txt"
# Current theme name
SC_LINK_THEME="${SC_DIR_CONFIG}/current-theme"
# Themes directory
SC_DIR_THEMES="${SC_DIR_BASE}/themes"
# Help file
SC_HELP="${SC_DIR_BASE}/help/help.txt"
