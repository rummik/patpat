#!/bin/zsh

function _pat-su {
	if [[ $USER != 'root' ]]; then
		sudo -- $@
	else
		$@
	fi
}

function pat {
	local cmd

	if [[ $# -gt 0 ]]; then
		cmd=$1
		shift
	fi

	if whence -- -pat-$cmd > /dev/null; then
		$(whence -- -pat-$cmd) $@
		return $?
	else
		_pat-su aptitude $cmd $@
		return $?
	fi
}

alias -- -pat-search='aptitude search'

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
