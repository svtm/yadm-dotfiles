# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
  export ZSH="/usr/share/oh-my-zsh"

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"


# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  mvn
  colored-man-pages
  common-aliases
  docker
  kubectl
)

source $ZSH/oh-my-zsh.sh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi
export EDITOR='vim'
# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

xset b off
NPM_PACKAGES="${HOME}/.npm-packages"
LOCAL_PACKAGES="${HOME}/.local"
PATH="$HOME/signicat/docker-green-stack-sign/util:$NPM_PACKAGES/bin:$LOCAL_PACKAGES/bin:$HOME/.cabal:$HOME/.ghcup/bin:$HOME/scripts:$PATH"

export JAVA_HOME="/usr/lib/jvm/default"

unset MANPATH
export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"
source /usr/share/fzf/key-bindings.zsh

unsetopt share_history
unsetopt hist_verify

# If current selection is a text file shows its content,
# if it's a directory shows its content, the rest is ignored
FZF_CTRL_T_OPTS="--preview-window wrap --preview '
if [[ -f {} ]]; then
    file --mime {} | grep -q \"text\/.*;\" && bat --color \"always\" {} || (tput setaf 1; file --mime {})
elif [[ -d {} ]]; then
    exa -l --color always {}
else;
    tput setaf 1; echo YOU ARE NOT SUPPOSED TO SEE THIS!
fi'"

function options() {
    PLUGIN_PATH="$HOME/.oh-my-zsh/plugins/"
    for plugin in $plugins; do
        echo "\n\nPlugin: $plugin"; grep -r "^function \w*" $PLUGIN_PATH$plugin | awk '{print $2}' | sed 's/()//'| tr '\n' ', '; grep -r "^alias" $PLUGIN_PATH$plugin | awk '{print $2}' | sed 's/=.*//' |  tr '\n' ', '
    done
}

function lpc() {
    if [ -z "$2" ]; then
        field="Password"
    else
	field=$2
    fi
    lpass show $1 | grep $field | awk '{print $2}' | xclip -selection c
    echo "Copied field $field from service $1 to clipboard (if it existed)"
}

function murder() {
    if [ -z "$1" ]; then
        echo "Usage: murder <processname-ish>"
    else
        echo "Murdering all processes matching $1"
        ps -aux | grep $1 | grep -v grep | awk '{print $2}' | xargs kill
    fi
}

alias cdsigapp="cd ~/signicat/signicat-stack"
alias cddocker="cd ~/signicat/docker-green-stack-sign"
alias cdsig="cd ~/signicat/"
alias cdsignflow="cd ~/signicat/signflow"
alias cdportal="cd ~/signicat/portal"
alias cdws="cd ~/signicat/ws-gateway"
alias cdsignrest="cd ~/signicat/signrest-app"
alias cdlib="cd ~/signicat/libraries"
alias cdnomad="cd ~/signicat/nomad-sign-team"
alias mscrot="scrot -e 'mv $f ~/screenshots/'"

replace_symlink() {
    if [ -z "$1" ]; then
        echo "Usage: replace_symlink <filename>"
    else
        readlink_output=`readlink $1`
        if [ -z "$readlink_output" ]; then
            echo "$1 is not a symlink"
        else
            echo "cp --remove-destination -r $readlink_output $1"
            cp --remove-destination -r $readlink_output $1
        fi
    fi
}

alias update_pmodules="find ~/signicat/ -maxdepth 1 -type d \(  -name \"pmodule_*\" \) -exec bash -c \"cd '{}' && git pull\" \;"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export QTT_QPA_PLATFORMTHEME=gtk2

alias yolo="mvn clean install -DskipTests -Dcheckstyle.skip -Djacoco.skip -Ddocker.skip -Djavadoc.skip -Denforcer.skip -Dmaven.javadoc.skip=true"

bwl() {
	bw_output=$(bw unlock)
	echo $bw_output
	export_cmd=$(echo $bw_output | grep export | sed 's/\$ //')
	if [ ! -z $export_cmd ]; then
		eval $export_cmd
	fi
}
