# 
# Do NOT Edit the Auto-generated Part!
# Generated by: spectacle version 0.32
# 

Name:       monit

# >> macros
# << macros
%define spectacle_bug hack_fix
%if 0%{?sailfishos_version} > 40300
BuildRequires:  pkgconfig(libcrypt)
%endif

Summary:    Pro-active monitoring utility for unix systems
Version:    5.34.0
Release:    0
Group:      Applications
License:    AGPLv3+
URL:        https://mmonit.com/monit
Source0:    %{name}-%{version}.tar.gz
Source1:    monitrc
Source2:    monit-web.desktop
Source100:  monit.yaml
Source101:  monit-rpmlintrc
Requires(preun): systemd
Requires(post): systemd
Requires(postun): systemd
BuildRequires:  pkgconfig(zlib)
BuildRequires:  pkgconfig(libssl)
BuildRequires:  pam-devel
BuildRequires:  systemd
BuildRequires:  automake
BuildRequires:  autoconf
BuildRequires:  libtool
BuildRequires:  bison
BuildRequires:  flex
BuildRequires:  desktop-file-utils

%description
Monit. Barking at daemons.

Monit is a small Open Source utility for managing and monitoring Unix
systems. Monit conducts automatic maintenance and repair and can execute
meaningful causal actions in error situations.

Up and running in 15 minutes!
With all features needed for system monitoring and error recovery. It's
like having a watchdog with a toolbox on your phone.

%if "%{?vendor}" == "chum"
Title: Monit
Type: console-application
PackagedBy: nephros
Categories:
 - System
 - Monitor
Custom:
  Repo: https://bitbucket.org/tildeslash/monit/
  PackagingRepo: https://github.com/nephros/monit/
PackageIcon: https://mmonit.com/monit/img/logo.png
Screenshots:
   - https://mmonit.com/monit/img/screenshots/1.png
   - https://mmonit.com/monit/img/screenshots/9.png
   - https://mmonit.com/monit/img/screenshots/10.png
   - https://mmonit.com/monit/img/screenshots/2.png
   - https://mmonit.com/monit/img/screenshots/4.png
   - https://mmonit.com/monit/img/screenshots/5.png
Links:
  Homepage: %{url}
  Help: https://mmonit.com/wiki/Monit
%endif


%package contrib
Summary:    Community contributions for %{name}
Group:      Applications
BuildArch:  noarch
Requires:   %{name}

%description contrib
%{summary}.

Configurations and scripts for Monit, created by the community.

Please submit your own scripts and config snippets to the packaging
repo so we can enhance the contrib package together.

%if "%{?vendor}" == "chum"
Title: Monit Community Configs
Type: console-application
PackagedBy: nephros
Categories:
 - System
 - Monitor
Custom:
  Repo: https://github.com/nephros/monit/
PackageIcon: https://mmonit.com/monit/img/logo.png
Links:
  Homepage: https://github.com/nephros/monit/tree/master/contrib
  Help: https://mmonit.com/wiki/Monit/ConfigurationExamples
  Bugtracker: https://github.com/nephros/monit/issues
%endif


%prep
%setup -q -n %{name}-%{version}/monit

# >> setup
# << setup

%build
# >> build pre
./bootstrap
# << build pre

%configure --disable-static \
    --enable-optimized \
    --with-zlib

make %{?_smp_mflags}

# >> build post
# generate with correct paths
make system/startup/monit.service
# << build post

%install
rm -rf %{buildroot}
# >> install pre
# << install pre
%make_install

# >> install post
rm -rf %{buildroot}%{_mandir}
rm -rf %{buildroot}%{_docdir}
install -m 600 -D %SOURCE1 %{buildroot}%{_sysconfdir}/monitrc
install -m 644 -D %SOURCE2 %{buildroot}%{_datadir}/applications/monit-web.desktop
install -m 644 -D system/startup/%{name}.service %{buildroot}/%{_unitdir}/%{name}.service
install -m 644 -D system/bash/%{name} %{buildroot}%{_sysconfdir}/bash_completion.d/%{name}
mkdir -p %{buildroot}%{_sysconfdir}/%{name}.d
for size in 76 512; do
install -m 644 -D ../icons/Icon/Monit-Icon-${size}x${size}@1x.png %{buildroot}%{_datadir}/icons/hicolor/${size}x${size}/apps/%{name}.png
install -m 644 -D ../icons/Logo/Monit-Logo-${size}x${size}@1x.png %{buildroot}%{_datadir}/icons/hicolor/${size}x${size}/apps/%{name}-logo.png
done

## the icon names are a bit weird wrt. sizes, the 1x, 2x, 3x prefixes are scales??
## Icons
install -m 644 -D ../icons/Icon/Monit-Icon-20x20@1x.png %{buildroot}%{_datadir}/icons/hicolor/16x16/apps/%{name}.png
install -m 644 -D ../icons/Icon/Monit-Icon-76x76@1x.png %{buildroot}%{_datadir}/icons/hicolor/64x64/apps/%{name}.png
install -m 644 -D ../icons/Icon/Monit-Icon-76x76@2x.png %{buildroot}%{_datadir}/icons/hicolor/128x128/apps/%{name}.png
install -m 644 -D ../icons/Icon/Monit-Icon-40x40@2x.png %{buildroot}%{_datadir}/icons/hicolor/86x86/apps/%{name}.png
## Logos
install -m 644 -D ../icons/Logo/Monit-Logo-20x20@1x.png %{buildroot}%{_datadir}/icons/hicolor/16x16/apps/%{name}-logo.png
install -m 644 -D ../icons/Logo/Monit-Logo-40x40@3x.png     %{buildroot}%{_datadir}/icons/hicolor/128x128/apps/%{name}-logo.png
install -m 644 -D ../icons/Logo/Monit-Logo-83.5x83.5@2x.png %{buildroot}%{_datadir}/icons/hicolor/172x172/apps/%{name}-logo.png
install -m 644 -D ../icons/Logo/Monit-Logo-512x512@2x.png   %{buildroot}%{_datadir}/icons/hicolor/1024x1024/apps/%{name}-logo.png

# install -contrib parts
pushd ../contrib
%make_install
# << install post

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop

%preun
# >> preun
%systemd_preun %{name}.service
# << preun

%post
# >> post
%systemd_post %{name}.service
# << post

%postun
# >> postun
%systemd_postun
# << postun

%files
%defattr(-,root,root,-)
%license COPYING
%{_bindir}/*
%{_unitdir}/%{name}.service
%{_datadir}/applications/%{name}-web.desktop
%{_datadir}/icons/hicolor/*/*/*.png
%config %{_sysconfdir}/bash_completion.d/%{name}
%config(noreplace) %{_sysconfdir}/monitrc
%dir %{_sysconfdir}/%{name}.d
# >> files
# << files

%files contrib
%defattr(-,root,root,-)
%config %{_sysconfdir}/%{name}.d/README.md
%dir %{_sysconfdir}/%{name}.d/scripts
%dir %{_sysconfdir}/%{name}.d/available
%config %{_sysconfdir}/%{name}.d/available/*.conf
# >> files contrib
# << files contrib
