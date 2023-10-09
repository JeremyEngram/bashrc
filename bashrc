# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bashrc_aliases ]; then
    . ~/.bashrc_aliases
fi

# bash aliases master file for ssh connectors
if [ -f ~/.bash_connectors ]; then
    . ~/.bash_connectors
fi

# bash functions master file
if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


# SYSTEM COMMANDS LOGGING EXECUTION
whoami="\$(whoami)@\$(echo \$SSH_CONNECTION | awk '{print \$1}')"
export PROMPT_COMMAND='RETRN_VAL=\$?;logger -p local6.debug "\$whoami [$$] \$(history 1 | sed "s/^[ ]*[0-9]\+[ ]*//" )"'


# LOG ALL COMMANDS TO /VARLOG/COMMANDS
# export PROMPT_COMMAND='RETRN_VAL=$?;logger -p local6.debug "$(whoami) [$$]: $(history 1 | sed "s/^[ ]*[0-9]\+[ ]*//" ) [$RETRN_VAL]"'
export PROMPT_COMMAND='RETRN_VAL=$?;logger -p local6.debug "$(whoami) [$$]: $(history 1 | sed "s/^[ ]*[0-9]\+[ ]*//" )"'

##########################################################

export PATH=$PATH:/usr/local/bin/omnisint
export PATH=$PATH:/usr/local/bin/omnisint/standalone
export PATH=$PATH:/usr/local/bin/omnisint/py
export PATH=$PATH:/usr/local/bin/omnisint/sh
export PATH=$PATH:/usr/local/bin/standalone
export PATH=$PATH:~/.local/bin
export PATH=$PATH:~/.bin
export PATH=$PATH:~/bin
export PATH=$PATH:/var/www/html/scripts
export PATH=$PATH:/var/www/html
export PATH=$PATH:/opt


#########################################################

############################################################

source ~/.autoenv/activate.sh

alias arm='sudo chmod +x'

alias url2pdf='wkhtmltopdf'
alias pdf2txt=''

################################################# START FORENSICS ALIASES
#alias binwalk
#alias scalpel
#alias foremost
################################################# END FORENSICS ALIASES


################################################# START BASIC SYSTEM ALIASES
alias displayservices='sudo service --status-all'

alias diskuagewarning='disk_usage_warning'

#alias backupomnisint='zip -r omnisint.zip /var/www/html'

alias differentialbackup='sudo bash /usr/local/bin/standalone/differential-backup.sh'
alias incrementalbackup='sudo rsync -av --link-dest=<previous_backup_directory> /var/www/html /media/csi/failover'
alias filelevelbackup='sudo rsync -av --delete /var/www/html/ /media/csi/failover/filelevelbackup'

alias diskimage='sudo dd if=/dev/sda of=/media/csi/failover/omnisint.iso bs=4M status=progress'

############################################################################## START SSH CONNECTORS ALIASES
alias masterserver='ssh jeremy@masterserver'
alias masterservercmd='ssh jeremy@masterserver -t'
alias sshfsmasterserver='sshfs jeremy@masterserver:/ /home/csi/Masterserver'
############################################################################## END SSH CONNECTORS ALIASES

#alias remotediskimage='remotediskimage.sh /dev/sda masterserver /home/jeremy/omnisint-remote-disk-image.iso'
#alias sshfsdiskimage='sshfs-remote-diskimage.sh /dev/sda /media/csi/remote remote-server:/home/jeremy/omnisint-remote-disk-image.iso'
#alias sshfsdiskimage2='sshfs-remote-diskimage2.sh /dev/sda /media/csi/remote remote-server:/home/jeremy/omnisint-remote-disk-image.iso'

alias reloadfstabpartitions='sudo systemctl daemon-reload'
#alias createsystemdservice=''

###################################################################################################### START CRUCIAL BASHRC FUNCTIONS

function disk_usage_warning() {
    local THRESHOLD=90  # Set the disk space utilization threshold in percentage

    local UTILIZATION=$(df -h --output=pcent / | awk 'NR==2 {print substr($1, 1, length($1)-1)}')

    if [ "$UTILIZATION" -ge "$THRESHOLD" ]; then
        echo "Warning: Disk space utilization is $UTILIZATION%."
    fi

    unset -f disk_usage_warning  # Unset the function to prevent it from running again
}


function takeowership() {
  if [ -z "$1" ]; then
    echo "Please provide a directory path."
    return 1
  fi

  if [ ! -d "$1" ]; then
    echo "The provided path is not a directory."
    return 1
  fi

  sudo chown -R csi:csi "$1"
  sudo chmod 775 "$1"
}


function addtolinestart {
  if [ $# -ne 2 ]; then
    echo "Usage: addtolinestart 'line' file"
    return 1
  fi

  line="$1"
  file="$2"

  # Insert line at start of each line
  sed -i "s/^/$line /" "$file" 
}

function createsystemservice {

}


################################################

# Define Omniscient HOMEDIR and BASE_DIR
HOMEDIR="/home/csi/"

# Define the Base directory
BASE_DIR="/home/csi/gpt4all"	#All System Files, User Files, Logs Into/Output From Local BaseDir AI

# OFF-PREM MASS STORAGE VARS
OFF_PREM="/mnt/mass_storage"

# New environment variables
export WEBIFACE="/var/www/html/omniface"	# Immutable Web Dir Wordpress For Web UI Documentation
export AIHOME="$BASE_DIR/.local/share/nomic.ai/GPT4All"	# New Home Dir For .Bin LLM Models CodeLlamma WizardUnsensored Groovy-Malformed 
export AIDIGEST="$BASE_DIR/gpt4all/LocalDocs"	#Spool All System And User Docs To GPT4All
export OPERATIONS="/opt"
export CASES="/home/csi/Cases/"	# Read All Cases Into Gpt4All
export LLMODELS="$BASE_DIR/llmodels/"

export GPT4MODELS="/home/csi/.local/share/nomic.ai/GPT4All/"

################################################

alias mobileforensics='androtree
'
alias scriptman='python3 /usr/local/bin/ScriptMan.py'
alias gpt4all='/home/csi/gpt4all/bin/chat'
alias webmin='xdg-open https://csi.lan:10000'


alias arm='sudo chmod +x'
alias url2pdf='wkhtmltopdf'
alias implement='sudo apt install -y'
alias blowoff='sudo apt autoremove'
alias dropoff='sudo apt remove'
alias truncatelogs='sudo truncate -s 0 /var/log/syslog'
alias nmapme='sudo nmap -sS localhost'


export PATH=$PATH:/home/$(whoami)/.local/bin
export PATH=$PATH:/home/$(whoami)/.bin
export PATH=$PATH:/home/$(whoami)/bin

export PATH=$PATH:/opt
export PATH=$PATH:/usr/local/bin/omnisint




################################################

export PATH="$PATH:/home/jeremy/.local/bin"


# JINA_CLI_BEGIN

## autocomplete
_jina() {
  COMPREPLY=()
  local word="${COMP_WORDS[COMP_CWORD]}"

  if [ "$COMP_CWORD" -eq 1 ]; then
    COMPREPLY=( $(compgen -W "$(jina commands)" -- "$word") )
  else
    local words=("${COMP_WORDS[@]}")
    unset words[0]
    unset words[$COMP_CWORD]
    local completions=$(jina completions "${words[@]}")
    COMPREPLY=( $(compgen -W "$completions" -- "$word") )
  fi
}

complete -F _jina jina

# session-wise fix
ulimit -n 4096
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
# default workspace for Executors

# JINA_CLI_END

export NVM_DIR="/home/jerermy/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

export PATH="/home/jerermy/.local/bin:$PATH"
export PATH=$PATH:/opt/fastchat/bin



alias gkeywordspider='python3 /usr/local/bin/omnisint/googlekeywordspider.py'


alias html2pdf='python3 /usr/local/bin/omnisint/html2guipdf'

alias tailjournal='journalctl -xe | ~/journalctl_xelog.log'

alias update='sudo apt update; sudo apt upgrade'

alias arm='sudo chmod +x'

alias url2pdf='wkhtmltopdf'

alias implement='sudo apt install -y'
alias blowoff='sudo apt autoremove'
alias dropoff='sudo apt remove'


alias displayservices='sudo service --status-all'
alias search='sudo apt-cache search'

alias bashly='docker run --rm -it --user $(id -u):$(id -g) --volume "$PWD:/app" dannyben/bashly'
export PATH=$PATH:/new/path1
export MY_VARIABLE=value

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/bashrc.post.bash" ]] && builtin source "$HOME/.fig/shell/bashrc.post.bash"
export DISPLAY=:0.0
