# Set local path probably used in future
export LD_LIBRARY_PATH="$HOME/local/lib/:$LD_LIBRARY_PATH"
export PATH="$HOME/local/bin:$PATH"

# Path to your oh-my-zsh installation.
# sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
export ZSH=$HOME/.oh-my-zsh

# ZSH_THEME="refined"
# ZSH_THEME="robbyrussell"
# ZSH_THEME="avit"
ZSH_THEME="agnoster"
DEFAULT_USER="$USER"
# ZSH_THEME="ys"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=$HOME/.oh-my-zsh/custom/


# Install plugins manually

# zsh-autosuggestions
if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ] ; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
fi

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  z
  extract
  history-substring-search
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# configuration for plugins

# Set shell command line to be vim-like
set -o vi

# Comment this will cause unseen completion due to same background color
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=6'
# ctrl + f to accept suggestions
bindkey '^F' autosuggest-accept

# Eanble fuzzy search
HISTORY_SUBSTRING_SEARCH_FUZZY='whateveryouwant'


# Fix vim tab error
# rm -rf ~/.antigen/.zcomp*
# rm -rf $ZSH_COMPDUMP


# User configuration
#
# Super useful fuzzy completion
zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-}={A-Z\_}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
  'r:|?=** m:{a-z\-}={A-Z\_}'

# To check the os name of current shell
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac


# Restore incremental search
# bindkey -v
# bindkey '^R' history-incremental-search-backward

# Set LANG
# export LANG=zh_CN.GBK
export LANG=en_US.UTF-8
# export LANGUAGE=en_US

# Set for macos
# coloring output from ls for mac
if [ "$machine" = "Mac" ]; then
    # brew install coreutils at first
    # Or simply use following line if gls is not available
    # export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD
    alias l='gls -htl --color=auto'
    alias ll='l'
    alias ls='gls --color=auto'
else
    # Alias the command for linux
    alias l='ls -lht --color=auto'
    alias ll='l'
fi


# Set for CCProxy for server unable to acess Internet
# outer_ip=10.130.14.95:808
# export http_proxy=$outer_ip
# export https_proxy=$outer_ip

# Useful records
# git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Set the color for ls

colors_dir="${HOME}/.dircolors"
color_file="dircolors.ansi-dark"
if [ -d "$colors_dir" ] ; then
   eval `dircolors ${colors_dir}/${color_file} &>/dev/null`
   eval `gdircolors ${colors_dir}/${color_file} &>/dev/null`

else
    # Create dir and download dircolors
   mkdir ${colors_dir}
   git clone https://github.com/seebi/dircolors-solarized.git ${colors_dir}
   eval `dircolors ${colors_dir}/${color_file} &>/dev/null`
   eval `gdircolors ${colors_dir}/${color_file} &>/dev/null`
fi

# Function

# Convenient pep8 to check python scripts
convenient_pep8 () {
    pep8 --show-source $1 | less -N
}

# Count ngram from arpa LM
function cngram() {
    if (( $# < 1 )); then 
        echo "usage: cngram arpa_file [...]"
        echo ""
        return 1
    fi
    for i in "$@"; do
        echo -n "$i: "
        head $i | perl -lne 'BEGIN {$total=0.0}; if ($_ =~/=(\d+)/) {$total += int($1)};END{print $total/1e6." million"}'
    done
}

if [ "$machine" = "Mac" ]; then
    # Get scp parameter
    getscp () {
        echo $USER@$(ipconfig getifaddr en1):$(pwd)/$1
    }

    # Copy to clicpboard (tcb) from remote server
    tcb () {
        ssh fengyukun@192.168.0.162 pbcopy
    }
else
    getscp () {
        echo $USER@$(hostname -I | perl -lane 'print $F[0]'):$(readlink -f $1)
    }
fi

# Print average of numbers from a file or stdin
avg () {
    while read line
    do
        perl -lne 'BEGIN{$sum=0; $c=0} END{print $sum/$c} next if /^$/; $sum += $_;$c+=1' $line
    done < "${1:-/dev/stdin}"
}