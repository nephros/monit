# 
# Do NOT Edit the Auto-generated Part!
# Generated by: spectacle version 0.32
# 

Name:       harbour-monit

# >> macros
# << macros
%define __provides_exclude_from qml/external

Summary:    Sailfish OS GUI for monit
Version:    0.9.5
Release:    0
Group:      Applications
License:    ASL 2.0
BuildArch:  noarch
URL:        https://github.com/nephros/monit
Source0:    %{name}-%{version}.tar.gz
Source100:  harbour-monit.yaml
Source101:  harbour-monit-rpmlintrc
Requires:   monit
Requires:   libsailfishapp-launcher
Requires:   qt5-qtdeclarative-import-xmllistmodel
Requires:   qml(Nemo.Mce)
Requires:   qml(QtQuick.XmlListModel)
BuildRequires:  qt5-qttools-linguist
BuildRequires:  qt5-qmake
BuildRequires:  sailfish-svg2png
BuildRequires:  qml-rpm-macros
BuildRequires:  desktop-file-utils

%description
Monit. Barking at daemons.

Monit is a small Open Source utility for managing and monitoring Unix
systems. Monit conducts automatic maintenance and repair and can execute
meaningful causal actions in error situations.

This is a simple Sailfish OS GUI application to view the status of the
daemon.

%if "%{?vendor}" == "chum"
Title: Embark Monit GUI
Type: desktop-application
Categories:
 - Monitor
Custom:
  Repo: https://github.com/nephros/monit
PackageIcon: %{url}/app/icons/%{name}.svg
Screenshots:
  - %{url}/raw/app/Screenshot_001.png
Links:
  Homepage: https://www.mmonit.com/monit/slides
%endif


%prep
%setup -q -n %{name}-%{version}

# >> setup
# << setup

%build
# >> build pre
# << build pre

%qmake5 

make %{?_smp_mflags}

# >> build post
# << build post

%install
rm -rf %{buildroot}
# >> install pre
# << install pre
%qmake5_install

# >> install post
# mangle version info
sed -i -e "s/unreleased/%{version}/" %{buildroot}%{_datadir}/%{name}/qml/%{name}.qml

# remove unnecessary Opal things:
for f in .git .gitignore .reuse LICENSES doc translations CHANGELOG.md CONTRIBUTORS.md README.md release-module.sh
do
rm -rf %{buildroot}%{_datadir}/%{name}/qml/external/opal-about/$f
done


# << install post

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop

%files
%defattr(-,root,root,-)
%license LICENSE
%dir %{_datadir}/%{name}
%{_datadir}/%{name}/translations/*.qm
%{_datadir}/%{name}/qml/*
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/*/*/apps/%{name}.png
%{_datadir}/icons/*/*/apps/%{name}.svg
%{_sysconfdir}/sailjail/permissions/*.profile
# >> files
# << files
