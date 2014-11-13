#!/bin/zsh

function -pat-su {
	if [[ $USER != 'root' ]]; then
		sudo -- $@
	else
		$@
	fi
}

function pat {
	if [[ $# -gt 0 ]]; then
		cmd=$1
		shift
	fi

	if functions + "pat-$cmd" > /dev/null; then
		"pat-$cmd" $@
		return $?
	else
		-pat-su aptitude $cmd $@
	fi
}

function pat-search {
	aptitude search $@
}

function pat-install {
	if [[ -f $1 ]]; then
		-pat-su dpkg -i $1
		-pat-su apt-get -f install
	else
		-pat-su aptitude install $@
	fi
}

function pat-up {
	pat-update
	-pat-su aptitude upgrade
}

function pat-update {
	-pat-su aptitude update
	-pat-su apt-file update
}

function pat-reconfigure {
	-pat-su dpkg-reconfigure $@
}

function pat-find {
	apt-file find $@
}

function pat-file {
	-pat-su apt-file $@
}
