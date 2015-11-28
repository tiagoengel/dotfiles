#!/bin/bash

function question_for_answer() {
  read -p "$1 [y][n]: " OPTION
  echo ""
}

function print_line() {
  echo "--------------------------------------------------------------------------------"
}  

function print_title () {
  clear
  echo "#-------------------------------------------------------------------------------"
  echo -e "# $1"
  echo "#-------------------------------------------------------------------------------"
  echo ""
}

function install_status() {
  if [ $? -ne 0 ] ; then
    CURRENT_STATUS=-1
  else
    CURRENT_STATUS=1
  fi
} 

function finish_function() {  
  print_line
  echo "Continue with RETURN"
  read
  clear
} 

function sumary() {
  install_status
  case $CURRENT_STATUS in
    0)
      print_line
      echo "$1 not successfull (Canceled)"
      ;;
    -1)
      print_line
      echo "$1 not successfull (Error)"
      ;;
    1)
      print_line
      echo "$1 successfull"
      ;;
    *)
      print_line
      echo "WRONG ARG GIVEN"
      ;;
  esac
}


