debootstrap --variant=minbase 

/usr/share/i18n/charmaps/UTF-8.gz
/usr/share/i18n/locales/C
/usr/share/i18n/locales/POSIX
/usr/share/i18n/locales/zh_CN

	[ -n "$targetDir" ] # just to be safe
	for dir in dev proc sys; do
		if [ -e "$targetDir/$dir" ]; then
			# --debian-eol woody and below have no /sys
			mount --rbind "/$dir" "$targetDir/$dir"
		fi
	done
	mount --rbind --read-only /etc/resolv.conf "$targetDir/etc/resolv.conf"
	exec chroot "$targetDir" /usr/bin/env -i PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" TZ="$TZ" LC_ALL="$LC_ALL" SOURCE_DATE_EPOCH="$epoch" "$@"

rm -f \
	"$targetDir/var/log/dpkg.log" \
	"$targetDir/var/log/bootstrap.log" \
	"$targetDir/var/log/alternatives.log" \
	"$targetDir/var/cache/ldconfig/aux-cache"
rm -f "$targetDir/run/mount/utab"
rmdir "$targetDir/run/mount" 2>/dev/null || :

# .slimify-includes
/usr/share/locale/locale.alias
/usr/share/gnome/help/*/C/*
/usr/share/doc/kde/HTML/C/*
/usr/share/omf/*/*-C.emf
/usr/share/locale/languages'
/usr/share/locale/all_languages'
/usr/share/locale/currency/*'
/usr/share/locale/l10n/*

# .slimify-excludes

./var/cache/apt/**
./var/lib/apt/lists/**
./etc/apt/apt.conf.d/01autoremove-kernels
./var/log/apt/history.log
./var/log/apt/term.log
./run/motd.dynamic
./etc/apt/trustdb.gpg
./var/lib/systemd/catalog/database

/usr/share/locale/*
/usr/share/gnome/help/*/*
/usr/share/doc/kde/HTML/*/*
/usr/share/omf/*/*-*.emf
/usr/share/doc/*
/usr/share/groff/*
/usr/share/info/*
/usr/share/linda/*
/usr/share/lintian/overrides/*
/usr/share/locale/*
/usr/share/man/*


tarArgs+=(
	--numeric-owner
	--transform 's,^./,,'
	--sort name
	.
)