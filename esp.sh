#!/bin/bash
# esp - e.g.  `esp pho` filename #open filename with photoshop
# intuitively and dynamically launch osX apps from the terminal
#
# @Author: Kimler (KC) Corey
# @Date: 2014
# @Contact: kimler[at]gmail[dot]com
# @version: 1.05
#
# Special thanks to the following <github names>:
# zenpuppet, <kimlercorey>, etc... 

#                         
#      .oPYo. .oPYo.  .oPYo. 
#      8.     8       8    8 
#      `boo   `Yooo. o8YooP' 
#      .P         `8  8      
#      8           8  8      
#      `YooP' `YooP'  8      
# :.....::.....::..:::::..::::::::
# ::: Terminal MDFind Launcher :::
# ::::::::::::::::::::::::::::::::

prefs="$HOME/.esp_profile"
REPO="https://raw.github.com/kimlercorey/esp/master/esp.sh"
ALIAS="$HOME/.alias"
PROFILE="$HOME/.bash_profile"
search_term=""; target_action=""; APPNAME=""; THISVERSION=""; ONLINEVERSION=""

# Actions
write=false; delete=false; quiet_mode=false; OPTIND=1

# Show help information
usage() {

  thisVersion
  cat << EOF

Usage: ${0##*/} [-hvqwldu] search_term [target_action]
Search OSX bundle on local systems and run the program executable passing the 
target_action (ie filename, url, etc) to the program once it is executed.
     
     -h          display this help info then exit
     -v          verbose mode.
     -p          print alias cmd
     -a          add alias cmd to $ALIAS (and load the alias file from $PROFILE)
     -q          quiet mode - do not ask to confirm
     -w          write this esp association to $prefs
     -l          list all associations from $prefs
     -d          delete search term from $prefs
     -u          check for updates to esp in repo at $REPO

[ Version $THISVERSION ]
     
EOF
}                

# retrieve and set this version of the program
thisVersion() {
  thisFile=$(cat ~/bin/"${0##*/}")
 
  getNext=0
  version=0
   
  for w in $thisFile
  do
             
    if [ "$getNext" == "1" ]; then
      version="$w"
      break
    fi
                                                      
    if [ "$w" == "@version:" ]; then
      getNext="1"
    fi
                                                                                      
  done
                                                                                       
  THISVERSION="$version"                                                                                     
}

# retrieve and set the version in the repo
onlineVersion() {
  thisFile=$(curl -Ls $REPO);

  getNext=0
  version=0

  for w in $thisFile
  do

    if [ "$getNext" == "1" ]; then
      version="$w"
      break
    fi

    if [ "$w" == "@version:" ]; then
      getNext="1"
    fi

  done

  ONLINEVERSION="$version"
 } 

# perform update
updateScript() {
  echo "UPDATING . . ."
  curl -Ls -o ~/bin/esp-0 $REPO \
      && chmod +x ~/bin/esp-0 \
      && mv ~/bin/esp-0 ~/bin/esp \
      && echo "UPDATED TO VERSION $ONLINEVERSION."
}

# Compares declared local version to that in repo
compareThisVersionToTheNewest() {
  thisVersion
  onlineVersion

  if [ "$THISVERSION" != "$ONLINEVERSION" ]; then
    confirm "You are running version $THISVERSION and $ONLINEVERSION is available. Would you like to upgrade? " && updateScript
  else
    echo "your version $THISVERSION is the most current version avaiable."
  fi
}

# Load the preferences into memory
loadPrefs() {

  # if !exist create new pref file
  if [ ! -f "$prefs" ]; then
    createPrefs
  fi

  IFS=$'\n' read -d '' -r -a approved < "$prefs"
}

# Create a preference file into file $prefs
createPrefs() {
  echo "# list approved esp associations ( $prefs )" > "$prefs"  
}

# show preferences (and create/load them if nec. first)
showPrefs() {

  if [ ! -f "$prefs" ]; then
    createPrefs
  fi

  loadPrefs

  printf '%s\n' "${approved[@]}"
}

# Output the alias that user may manually add to their aliases list  
print_alias() {
  printf "alias %s='esp -q %s \$1'\n" "$1" "$1"
}

# Output the alias to .bashrc
print_alias_to_bashrc() {
  if [[ ! -f $ALIAS ]]; then
    touch "$ALIAS"
    echo "# ALIAS FILES GENERATED FROM ESP" >> "$ALIAS"
    echo "source $ALIAS" >> "$PROFILE" 
  fi

  confirm "Create Alias in $ALIAS for command $1 " && echo "alias $1='esp -q $1 \$1'" >> "$ALIAS"  

  # Id like to source this immediately avaiable after added but nothing seems to work
  # except eval as a function wihich just seems wrong - until there is a solution for that
  # user will need to start a new shell to invoke their added aliases

}

# Prompt for user input with default prompt
confirm() { # call with a prompt string or use a default

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

# Returns success state and result itself in $APPNAME
is_app_exists() {
  APPNAME=$(mdls -name kMDItemCFBundleIdentifier -raw "$(mdfind "(kMDItemContentTypeTree=com.apple.application) && (kMDItemDisplayName == '$1*'cdw)" | head -1)")

  if [ "$APPNAME" != ": could not find ." ]; then
    return 0
  fi

  return 1
}  

# Ask to open result
loadApp() {
  PARTS=$(awk "/^$1[ ]/" "$prefs")

  IFS=' ' read -a PARTS <<< "${PARTS}"

  if [ "${PARTS[1]}" ]; then
    APPNAME=${PARTS[1]}
    quiet_mode=true
  fi

  confirm "open $APPNAME from keyword '$1'" && $(open -b"$APPNAME" "$3")
}

#`# Walk through flag options
while getopts ":uhvqwldpa" opt; do
case "$opt" in
    h)
        usage
        exit 0
        ;;
    v)  verbose=true
        ;;
    p)  print_alias "$2"
        exit 0
        ;;
    a)  print_alias_to_bashrc "$2"
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
        ;;
    u)  
        compareThisVersionToTheNewest
        exit 0
        ;;
    \?)
        echo "\nInvalid option: -$OPTARG" && usage >&2
        exit 0
        ;;
    esac
done

shift "$((OPTIND-1))" # Removes the flags once processed

search_term=$1 
target_action=${@:2} #included all arguments after search_term

# Show help if someone ONLY types the command
[[ $# -eq 0 ]] && usage && exit

is_app_exists "$1"

if $delete; then
  terms="$search_term $APPNAME" 
  confirm "Delete entry '$search_term $APPNAME'" && grep -vwE "($search_term $APPNAME)" "$prefs" > "$prefs.new" && mv "$prefs" "$prefs.bak" && mv "$prefs.new" "$prefs" 
  exit 0;
fi

if (is_app_exists "$1")
then
      if $write ; then 
      confirm "Save $search_term $APPNAME relationship?" && echo "$search_term $APPNAME" >> "$prefs"
      fi  
      loadApp "$1" "$APPNAME" "$target_action" # && `open -b$APPNAME $2` 
  else
      echo "could not find application for $1"
  fi
