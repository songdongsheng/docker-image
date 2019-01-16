# force dpkg not to call sync() after package extraction (speeding up installs)
if [ -d "$targetDir/etc/dpkg/dpkg.cfg.d" ]; then
	# --debian-eol lenny and older do not include /etc/dpkg/dpkg.cfg.d
	cat > "$targetDir/etc/dpkg/dpkg.cfg.d/docker-apt-speedup" <<-'EOF'
		# For most Docker users, package installs happen during "docker build", which
		# doesn't survive power loss and gets restarted clean afterwards anyhow, so
		# this minor tweak gives us a nice speedup (much nicer on spinning disks,
		# obviously).
		force-unsafe-io
	EOF
	chmod 0644 "$targetDir/etc/dpkg/dpkg.cfg.d/docker-apt-speedup"
fi
