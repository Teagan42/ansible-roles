# Bash profile that syncs bash profile and other pref files

# If you use macports
if [ -d /opt/local/bin ]
then
export PATH=/opt/local/bin:/opt/local/sbin:/home/ldap/misc/openstack:/usr/local/Cellar:$PATH
fi

# Shell color options
export CLICOLOR=1
export LSCOLORS=ExFxcxdxcxegedbxgxEbEg

# Bash Prompt
case $TERM in
xterm*|xterm|linux)
export PS1="\[\e]0;\h: \w\a\]\[\e[0;31m\]\h:\[\e[0;0m\]\w \[\e[0;37m\]\u\[\e[0;0m\]: "
;;
*)
export PS1="\h:\w \u\$ "
;;
esac

# Serial to check against for updating remote hosts
#profilepush:SERIAL:0913201601

# Add additional files with #profilepush:FILE:<filename>
#profilepush:FILE:.ssh/authorized_keys
#profilepush:FILE:.bash_profile
#profilepush:FILE:.vimrc
#profilepush:FILE:.screenrc
#profilepush:FILE:.ssh/config

# Sync Function
profilepush () {


myHost=$1


remoteVersion=0
localVersion=`grep "^#profilepush:SERIAL:" ~/.bash_profile | awk 'BEGIN{FS=":"}{print $3}'`

if [ -d $PUSH_HOME_HOSTS ]
then
if [ -f $PUSH_HOME_HOSTS/$myHost ]
then
remoteVersion=`cat $PUSH_HOME_HOSTS/$myHost`
else
mkdir $PUSH_HOME_HOSTS
fi
fi

if [ $remoteVersion -lt $localVersion ]
then
myFiles=$(grep "^#profilepush:FILE:" ~/.bash_profile | awk -F : '{print $3}')
echo Files: $myFiles

ssh $myHost 'if [ ! -d $HOME/.ssh ]; then  mkdir $HOME/.ssh; fi | if [ ! -d $HOME/.historyfiles ]; then mkdir $HOME/.historyfiles; fi | if [ ! -d $HOME/.home_version_hosts ]; then  mkdir $HOME/.home_version_hosts; fi'

( for file in $( echo $myFiles); do cd ; rsync -avLP $file $myHost:$file; done ) && echo $localVersion > $PUSH_HOME_HOSTS/$myHost
fi

ssh $myHost
}

# Per-Host History File
export HISTFILE="${HOME}/.historyfiles/.bash_history.`hostname`"


# TCPDUMP Alias for DHCP
alias dhcptcpdump="tcpdump -vvv -s 0 '((port 67 or port 68) and (udp[8:1] = 0x1))'"

# All-Purpose Aliases

alias sbash='sudo bash -l'
alias less=view
alias more=view

