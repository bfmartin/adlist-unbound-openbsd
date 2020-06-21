# adlist-unbound-openbsd

Download lists of advertising domains, and format them for blocking
using unbound on OpenBSD. This is perfect for running on an OpenBSD
DNS server for a home or small network.

**Warning:** installing this requires some OpenBSD administration
knowledge and editing text configuration files. It's not difficult,
though, and if you can configure unbound, you should be able to get
this working, too.

This has been in use on my network since OpenBSD 6.2.


## Features

### Well-known sources for advertising domains

Several sources for advertising domains are used, and it's easy to add
more.

### Elementary privilege separation

First, a non-privileged script wil download domains and format them
for use by unbound. Then, a privileged account will install the list
of domains into the unbound configuration directory, then restart
unbound. This is accomplished by using doas to run the privileged
script.

### Whitelisting

Domains may be excluded from blocking using simple whitelisting
techniques. Examples are included.

### No external dependencies

This works using a base install of OpenBSD.

## Programs

The following programs are included here:

* ```adlist-unbound-cron.sh```

  - This is the top-level program. It runs via crontab, and calls the
    other programs. Unprivileged.

* ```adlist-unbound-fetch.sh```

  - This program downloads domain list files, and formats them for use
    by unbound. Unprivileged.

* ```adlist-unbound-ctl.sh```

  - This program installs the new config file, and restarts
    unbound. This program requires root privileges.

While it is possible to run all these programs under root, it's best
not to, to avoid possible problems in downloading data.


## Install

### Install adlist programs

As root, execute the following:

      for prog in bin/*; do
        install -o root -m 0755 $prog /usr/local/bin
      done

**Note:** These programs don't need to be installed in
  ```/usr/local/bin```.

**Important:** be sure to install all files in the bin directory in
the same target directory. The ```adlist-unbound-cron.sh``` starts the
other scripts, and looks for them in the same directory.

They can go pretty much anywhere but be sure to install all programs
in the same directory. If you choose somewhere other than
```/usr/local/bin```, change the path for the cronjob below, and also
for the doas.conf below.

### Configure unbound

Add the following line to ```/var/unbound/etc/unbound.conf```

    include: /var/unbound/etc/adlist.conf

Add it to the ```server:``` section, something like this:

        server:
          interface: 127.0.0.1
          interface: ::1
          include: /var/unbound/etc/adlist.conf

### Enable unbound

If you haven't done this already, make sure unbound is enabled, and
make it start at boot time. Do this command:

      rcctl enable unbound

### Configure doas

One of the programs, the one that installs the domain list into the
unbound config dir and then restarts unbound, requires root
privileges. Put the following into ```/etc/doas.conf```:

      permit nopass :wheel as root cmd /usr/local/bin/adlist-unbound-ctl.sh

This assumes the account running the command is in the wheel group.

Since the last matching rule takes precedence, put this line at the
bottom of the ```/etc/doas.conf``` file.

### Configure crontab

Running this weekly should be sufficient. Enter this into the crontab
of a non-privileged user:

      0 1 * * 0 /usr/local/bin/adlist-unbound-cron.sh

This will run it Sundays at 1 AM.
