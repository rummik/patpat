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
	elif [[ $# -gt 0 ]]; then
		-pat-su aptitude $cmd $@
	else
		print 'Nothing to do.'
	fi
}

function pat-install {
	if [[ -f $1 ]]; then
		-pat-su dpkg -i $1
	else
		-pat-su aptitude install $@
	fi
}

function pat-update {
	-pat-su aptitude update
	-pat-su apt-file update
}

function pat-find {
	pat-file find $@
}

function pat-file {
	-pat-su apt-file $@
}
