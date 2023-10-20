PROMPT="%F{#FFFFFF}╭─%F{#af00d1}%n %{%F{#808080}%}em %F{#008000}%B%~%b%f
%F{#FFFFFF}╰─%{%F{#FFFFFF}%}o %f"

# sistema
alias update='sudo zypper dup'

# games
alias warframe='nohup lutris lutris:rungame/warframe > /dev/null 2>&1 &'
alias cyberpunk='nohup lutris lutris:rungame/cyberpunk-2077 > /dev/null 2>&1 &'
alias theforest='nohup lutris lutris:rungame/sons-of-the-forest > /dev/null 2>&1 &'
alias sekiro='nohup lutris lutris:rungame/sekirotm-shadows-die-twice > /dev/null 2>&1 &'

# git

alias addup='git add -u'
alias addall='git add .'
alias branch='git branch'
alias commit='git commit -m'
alias fetch='git fetch'
alias pull='git pull origin'
alias status='git status'
alias push='git push'
