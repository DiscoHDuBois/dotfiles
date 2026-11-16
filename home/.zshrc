# Prompt: starship se installato, altrimenti powerlevel10k
export PATH="$HOME/.local/bin:$PATH"
(( $+commands[starship] )) && USE_STARSHIP=1

# Fastfetch all'apertura di kitty (prima dell'instant prompt di p10k, che non vuole output dopo)
if [[ -o interactive && $TERM == xterm-kitty && -z $FASTFETCH_SHOWN ]]; then
  export FASTFETCH_SHOWN=1
  _ff_size=''
  _ff_show() {
    # $COLUMNS/$LINES si aggiornano solo quando zsh gestisce il segnale: legge la misura dal terminale
    local s; s=$(stty size 2>/dev/null) && { LINES=${s% *}; COLUMNS=${s#* }; }
    _ff_size="$LINES $COLUMNS"
    if   (( COLUMNS >= 82 && LINES >= 21 )); then fastfetch
    elif (( COLUMNS >= 48 && LINES >= 21 )); then fastfetch --logo none
    fi
  }

  # Ridisegno se Tiling Shell ridimensiona la finestra prima del primo comando
  _ff_pristine=1
  TRAPWINCH() {
    (( _ff_pristine )) && [[ -n $_ff_size ]] || return 0
    [[ $(stty size 2>/dev/null) == $_ff_size ]] && return 0
    zle && zle -I
    print -n '\e_Ga=d\e\\\e[H\e[2J\e[3J'       # cancella immagini kitty, schermo e scrollback
    _ff_show
  }
  _ff_done() { _ff_pristine=0; unfunction TRAPWINCH 2>/dev/null; add-zsh-hook -d preexec _ff_done; }
  autoload -Uz add-zsh-hook && add-zsh-hook preexec _ff_done

  # Attesa di 0.25s per il posizionamento di Tiling Shell
  zmodload zsh/zselect 2>/dev/null && zselect -t 25 2>/dev/null
  _ff_show
fi

# Powerlevel10k instant prompt
if [[ -z $USE_STARSHIP && -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
if [[ -n $USE_STARSHIP ]]; then ZSH_THEME=""; else ZSH_THEME="powerlevel10k/powerlevel10k"; fi
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# Prompt
if [[ -n $USE_STARSHIP ]]; then
  eval "$(starship init zsh)"
else
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
fi
