# -*- mode: sh -*-

# Firejail profile for harbour-monit

# x-sailjail-translation-catalog = harbour-monit
# x-sailjail-translation-key-description = permission-la-dbus
# x-sailjail-description = Systemd D-Bus permissions
# x-sailjail-translation-key-long-description = permission-la-dbus_description
# x-sailjail-long-description = Allows access to systemd DBus interfaces


## PERMISSIONS
# x-sailjail-permission = Connman

### D-Bus
dbus-user filter
dbus-user.talk org.freedesktop.DBus
dbus-user.call org.freedesktop.DBus=org.freedesktop.DBus@/*
dbus-user.broadcast org.freedesktop.DBus=org.freedesktop.DBus@/*

# BEG systemd manager and related
dbus-user.talk org.freedesktop.systemd1
dbus-user.call org.freedesktop.systemd1=org.freedesktop.systemd1@/*
dbus-user.call *=org.freedesktop.systemd1.Manager@/*
dbus-user.call *=org.freedesktop.systemd1.Unit@/*
# END systemd manager and related

### D-Bus
dbus-system filter
dbus-system.talk org.freedesktop.DBus
dbus-system.call org.freedesktop.DBus=org.freedesktop.DBus@/*
dbus-system.broadcast org.freedesktop.DBus=org.freedesktop.DBus@/*

# BEG systemd manager and related
dbus-system.talk org.freedesktop.systemd1
dbus-system.call org.freedesktop.systemd1=org.freedesktop.systemd1@/*
dbus-system.call *=org.freedesktop.systemd1.Manager@/*
dbus-system.call *=org.freedesktop.systemd1.Unit@/*
# END systemd manager and related
