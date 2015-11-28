#!/bin/bash

. ../.functions
. utils.sh

print_title "Arch post-installation script.
# This script will install and configure some useful programs.
# It is not recommended run this script more than once."
question_for_answer "Continue?"
if [ "$OPTION" != "y" ]; then 
  exit 1
fi

