#!/bin/sh
# esp - e.g.  `esp pho` filename #open filename with photoshop
# intuitively and dynamically launch osX apps from the terminal
#
# @Author: Kimler (KC) Corey
# @Date: 2014
# @Contact: kimler[at]gmail[dot]com
# @version: 1.0
#
# Special thanks to the following <github names>:
# zenpuppet, <kimlercorey>, etc... 

#                         
#     .oPYo. .oPYo.  .oPYo. 
#     8.     8       8    8 
#     `boo   `Yooo. o8YooP' 
#     .P         `8  8      
#     8           8  8      
#     `YooP' `YooP'  8      
#:.....::.....::..:::::..::::::
#::: Terminal MDFind Launcher::
#::::::::::::::::::::::::::::::



prefs="$HOME/.esp_profile"
search_term=""
target_action=""
APPNAME=""

# possible actions = write, go | list | delete
go=true; write=false; list=false; delete=false; quiet_mode=false; OPTIND=1

# Show help information
usage() {
cat << EOF

Usage: ${0##*/} [-hvqwld] search_term [target_action]
Search OSX bundle on local systems and run the program executable passing the 
target_action (ie filename, url, etc) to the program once it is executed.
     
     -h          display this help info then exit
     -v          verbose mode.
     -p          print alias add cmd
     -q          quiet mode - do not ask to confirm
     -w          write this esp association to auto_act file
     -l          list all associations from auto_act file
     -d          delete search term from auto_act file

EOF
}                

# Load the preferences into memory
function loadPrefs {
  echo "loading prefs file"
  IFS=$'\n' read -d '' -r -a approved < $prefs
}

# Create a preference file into file $prefs
function createPrefs {
  echo "# list approved esp associations ( $prefs )" > $prefs  
  echo "creating prefs file"
}

# show preferences (and create/load them if nec. first)
function showPrefs {

  if [ ! -f "$prefs" ]; then
    createPrefs
  fi

  loadPrefs

  printf '%s\n' "${approved[@]}"

}

# Output the alias that user may manually add to their aliases list
# todo: (possibly) add prompt to add alias to list programatically  
function print_alias {
 printf "alias %s='esp -q %s \$1'\n" "$1" "$1"
}

# Prompt for user input with default prompt
function confirm { # call with a prompt string or use a default

  if $quiet_mode; then return 0; fi #if quiet mode then don't ask
  
  read -r -p "${1:-Are you sure?} [y/N] " response
  case $response in
    [yY][eE][sS]|[yY]) 
      true
      ;;
  *)
      false
      ;;
   esac
}

function is_app_exists {
  app="$1"    
  APPNAME=$(mdls -name kMDItemCFBundleIdentifier \
    -raw "$(mdfind "(kMDItemContentTypeTree=com.apple.application) && (kMDItemDisplayName == '$1*'cdw)" | head -1)")

  if [ "$APPNAME" != ": could not find ." ]; then
    return 0
  fi

  return 1
}  

function loadApp {

  PARTS=$(awk "/^$1[ ]/" $prefs)

  IFS=' ' read -a PARTS <<< "${PARTS}"

  if [ "${PARTS[1]}" ]; then

    APPNAME=${PARTS[1]}
    quiet_mode=true
  fi

  confirm "open $APPNAME from keyword '$1'" && `open -b$APPNAME $3`
}

# Walk through flag options
while getopts "hvqwldp:" opt; do
case "$opt" in
    h)
        usage
        exit 0
        ;;
    v)  verbose=true
        ;;
    p)  print_alias $2
        exit 0
        ;;
    q)  quiet_mode=true
        ;;
    w)  write=true
        ;;
    l)  list=true
        showPrefs
        exit 0
        ;;
    d)  delete=true
        exit 0
        ;;
    '?')
        usage >&2
        exit 0
        ;;
    esac
done

shift "$((OPTIND-1))" # Removes the flags once processed

search_term=$1 
target_action=${@:2} #included all arguments after search_term

# Show help if someone ONLY types the command
[[ $# -eq 0 ]] && usage

is_app_exists "$1"

if $delete; then
  terms="$search_term $APPNAME" 
  confirm "Delete entry '$search_term $APPNAME'" && grep -vwE "($search_term $APPNAME)" $prefs > $prefs.new && mv $prefs $prefs.bak && mv $prefs.new $prefs 
  exit 0;
fi

if (is_app_exists "$1")
then
      if $write ; then 
      confirm "Save $search_term $APPNAME relationship?" && echo "$search_term $APPNAME" >> $prefs
      fi  
      loadApp "$1" "$APPNAME" "$target_action" # && `open -b$APPNAME $2` 
  else
      echo "could not find application for $1"
  fi
