## Community contributions for Monit on Sailfish OS

The monit-contrib package installs configuration files named `/etc/monit.d/available/foo.conf`.

The monitrc file includes `/etc/monit.d/*.conf`

Therefore, in order to activate a config, either symlink or copy from the `available/` directory.

### Helper scripts

If a conf file requires a helper script, those should be placed into `/etc/monit.d/scripts/foo.sh`.
As such scripts are not automatically used by monit, they do not need to be activated or symlinked.
