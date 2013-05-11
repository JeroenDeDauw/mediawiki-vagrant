# == Base Puppet manifest
#
# This manifest declares resource defaults for the Mediawiki-Vagrant
# Puppet site. All Puppet modules bundled with this project have an
# implicit dependency on this manifest and the declarations it contains.
# Modify this file with care.
#
# For more information about resource defaults in Puppet, see
# <http://docs.puppetlabs.com/puppet/2.7/reference/lang_defaults.html>.
#

stage { 'first': }
stage { 'last': }

Stage['first'] -> Stage['main'] -> Stage['last']

# Declares a default search path for executables, allowing the path to
# be omitted from individual resources. Also configures Puppet to log
# the command's output if it was unsuccessful.
Exec {
	logoutput => on_failure,
	path      => [ '/bin', '/usr/bin', '/usr/local/bin', '/usr/sbin/' ],
}

Package { ensure => present, }

# Declare default uid / gid and permissions for file resources, and
# tells Puppet not to back up configuration files by default.
File {
	backup => false,
	owner  => 'root',
	group  => 'root',
	mode   => '0644',
}

package { 'python-pip':
	ensure => present,
}

Package['python-pip'] -> Package <| provider == pip |>

# This solves the 'stdin: not a tty' error message, which is caused by a
# call to 'mesg n' in /root/.profile. Sadly it'll still appear once,
# since profile is sourced before Puppet can run. That sucks, because
# first impressions do count. Fix it and you get a cookie.
exec { 'update profile':
	command => 'sed -i -e "s/^mesg n/tty -s \&\& mesg n/" /root/.profile',
	onlyif  => 'grep -q "^mesg n" /root/.profile',
}
