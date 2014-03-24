name             'pure-ftpd'
maintainer       'Fabio Napoleoni'
maintainer_email 'f.napoleoni@gmail.com'
license          'Apache 2.0'
description      'Installs/Configures pure-ftpd'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

supports 'ubuntu'

recipe            'pure-fptd', 'Pure ftp daemon configuration'
recipe            'pure-fptd::firewall', 'Open ftp port on firewall using firewall_rule'

depends 'firewall' # Used in pure-fptd::firewall
