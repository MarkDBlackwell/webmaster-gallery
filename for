#!/bin/sh
# Author: Mark D. Blackwell
# Date written: November 6, 2010
# Date last changed: November 6, 2010

# Usage:
#   for <glob>
# For example (assuming the existence of multiple executables, ./fu* ):
#   nano `./for ./fu*`

for arg in $@ ; do $arg ; done
