#!/bin/zsh

function _pat-check-init {
	local req ask missing=()

	for req in {apt-file,aptitude}; do
		if ! whence -- $req > /dev/null; then
			missing+=($req)
		fi
	done

	if [[ $#missing -gt 0 ]]; then
		print Patpat depends on: ${(j:, :)missing}
		print -n Install the missing dependencies"? [Y/n] "

		read ask

		if [[ $ask == Y || $ask == y || -z $ask ]]; then
			_pat-su apt-get install $missing
		else
			return 1
		fi
	fi

	return 0
}

function _pat-su {
	if [[ $USER != 'root' ]]; then
		sudo -- $@
	else
		$@
	fi
}

function pat {
	local cmd=help

	if [[ $# -gt 0 ]]; then
		cmd=$1
		shift
	fi

	if [[ $cmd == 'moo' ]]; then
		case x$1 in
			x) print "I'm an elephant.";;
			*) print "I'm not an elephant?";;
		esac
		return
	fi

	if [[ $cmd != 'help' ]]; then
		_pat-check-init
	fi

	if whence -- -pat-$cmd > /dev/null; then
		$(whence -- -pat-$cmd) $@
		return $?
	else
		_pat-su aptitude $cmd $@
		return $?
	fi
}

function -pat-help {
	<<-EOF
	Usage:
	  pat <command> [args]

	Commands:
	  help					Display this help
	  up					Alias for pat update && pat upgrade
	  u,update				Update package lists and contents [aptitude,apt-file]
	  upgrade				Perform an upgrade [aptitude]
	  ui					Open a ncurses UI for managing packages [aptitude]
	  i,install <package...|file>		Install a single .deb, or list of packages [dpkg,apt-get,aptitude]
	  file <action> [pattern...]		Wrapper around apt-file [apt-file]
	  ppa <ppa>				Shorthand for adding a PPA [apt-add-repository]
	  add,add-repository <repo>		Add a repository [add-apt-repository]
	  reconfigure <package...>		Reconfigure packages [dpkg-reconfigure]
	  search <pattern...>			Search for a package by name and/or pattern [aptitude]
	  find <pattern...>			Search files in packages by pattern [apt-file]
	  show <package>			Display detailed information about a package [aptitude]
	  autoremove				Automatically remove all unused packages [apt-get]

	If a command does not match the list above, it is passed directly to aptitude.

	This patpat does not yet have supercow powers.
	EOF
}

function -pat-ui {
	_pat-su aptitude
}

alias -- -pat-search='aptitude search'
alias -- -pat-show='aptitude show'

alias -- -pat-i=-pat-install
function -pat-install {
	if [[ -f $1 ]]; then
		_pat-su dpkg -i $1
		_pat-su apt-get -f install
	else
		_pat-su aptitude install $@
	fi
}

function -pat-up {
	-pat-update
	_pat-su aptitude upgrade
}

alias -- -pat-u=-pat-update
function -pat-update {
	_pat-su aptitude update
	_pat-su apt-file update
}

function -pat-reconfigure {
	_pat-su dpkg-reconfigure $@
}

alias -- -pat-add=-pat-add-repository
function -pat-add-repository {
	_pat-su add-apt-repository $1
	-pat-update
}

function -pat-ppa {
	-pat-add-repository ppa:$1
}

function -pat-find {
	apt-file find $@
}

function -pat-file {
	_pat-su apt-file $@
}

function -pat-autoremove {
	_pat-su apt-get autoremove $@
}
