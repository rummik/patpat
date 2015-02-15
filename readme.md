 Patpat
========
Your one-stop APT wrapper that cuts down on extra moo.


```
Usage:
  pat <command> [args]

Commands:
  help                                  Display this help
  up                                    Alias for pat update && pat upgrade
  u,update                              Update package lists and contents [aptitude,apt-file]
  upgrade                               Perform an upgrade [aptitude]
  i,install <package...|file>           Install a single .deb, or list of packages [dpkg,apt-get,aptitude]
  file <action> [pattern...]            Wrapper around apt-file [apt-file]
  ppa <ppa>                             Shorthand for adding a PPA [apt-add-repository]
  add,add-repository <repo>             Add a repository [add-apt-repository]
  reconfigure <package...>              Reconfigure packages [dpkg-reconfigure]
  search <pattern...>                   Search for a package by name and/or pattern [aptitude]
  find <pattern...>                     Search files in packages by pattern [apt-file]
  show <package>                        Display detailed information about a package [aptitude]

If a command does not match the list above, it is passed directly to aptitude.

This patpat does not yet have supercow powers.
```
