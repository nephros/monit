## Community contributions for Monit on Sailfish OS

The monit-contrib package installs configuration files named `/etc/monit.d/available/foo.conf`.

The monitrc file includes `/etc/monit.d/*.conf`

Therefore, in order to activate a config, either symlink or copy from the `available/` directory.

Copy if you plan to change the file, symlink if you are OK with package updates overwriting old versions.

Afterwards, do a `monit reload`.

### Helper scripts

If a conf file requires a helper script, that should be placed into
`/etc/monit.d/scripts/foo.sh`. As such scripts are not automatically used by
Monit, they do not need to be activated or symlinked.

### Contributing

You are cordially invited to submit issues or Pull Requests! This is a group effort!

https://github.com/nephros/monit

