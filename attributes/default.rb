# Array of virtual users to create
#
# Each virtual user should be an hash with the following properties
# {
#     login: 'ftpuser', # ftp login
#     password: 'secret', # ftp password
#     home: '/home/ftp', # ftp folder for the user, he's chrooted into this folder
#     system_user: 'ftp', # system user to impersonate
#     system_group: 'ftp' # system group to impersonate
# }
default[:pure_ftpd][:users] = []

# Pure ftpd options, configure as needed, here are some defaults,
# see man pure-ftp-wrapper for allowed values
default[:pure_ftpd][:options][:AltLog] = 'clf:/var/log/pure-ftpd/transfer.log'
default[:pure_ftpd][:options][:ChrootEveryone] = 'yes'
default[:pure_ftpd][:options][:FSCharset] = 'UTF-8'
default[:pure_ftpd][:options][:NoAnonymous] = 'yes'
default[:pure_ftpd][:options][:PureDB] = '/etc/pure-ftpd/pureftpd.pdb'
default[:pure_ftpd][:options][:Umask] = '113 002'
default[:pure_ftpd][:options][:PassivePortRange] = '23800 24820'
