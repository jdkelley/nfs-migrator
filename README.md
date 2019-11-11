# [WIP] - `nfs-migrator`

This tool migrates an nfs share directory from one nfs server to another. Was developed for migrating stateful data used by containers from one container orchestration provider to another.


## Prerequisites 

* At the moment, this script assumes that the nfs share directory is at `/nfs` on the nfs server. Change this at the top of the script. Eventually, this will be a default in a .config file for defaults and a flag you can pass at execution time for overrides.
* You have the origin and destination nfs servers setup in your ssh config so that you can use `ssh <ip or hostname>` to ssh to the server. If you need help setting that up, please visit this link: [Setting up SSH Config][ssh-config-configuration].

## Usage

Configure your IPs in the script and run with `./migrate.sh <directory name>`.

More to come ...


## In Docker

More to come ...

## License

This tool is released under the [MIT License][license].

[ssh-config-configuration]: ./README.md "Setting up Your SSH Config"
[license]: ./LICENSE "MIT License"
