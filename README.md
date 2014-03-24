# pure-ftpd cookbook [![Build Status](https://travis-ci.org/fabn/chef-pure-ftpd.svg)](https://travis-ci.org/fabn/chef-pure-ftpd)

Install and configure pure-ftpd server with virtual users support.

# Requirements

This cookbook is built and tested on Ubuntu 12.04.

# Cookbooks:

This cookbook doesn't have direct dependencies on other cookbooks for default recipe.

Opscode firewall cookbook is used in recipe `pure-ftpd::firewall` to manage firewall configuration.

# Attributes

The following attributes are used to drive default recipe

* `node['pure_ftpd']['users']` - List of virtual users to create
* `node['pure_ftpd']['options']` - Options provided to pure-ftpd wrapper

For the firewall recipe the only attribute given is

* `node['pure_ftpd']['firewall_allow']` - Network source allowed for incoming ftp connections

# Recipes

default
-------

Install and configure pure-ftpd daemon for standalone execution (no inetd) and configure virtual
users as authentication source.

Daemon options can be configured with `node['pure_ftpd']['options']` hash, some defaults are already
given in default attributes.

FTP Virtual users can be configured using `node['pure_ftpd']['users']` attribute. It's an array of
 users hashes where every user is specified with a set of properties. The following is an example of
 virtual user.

```ruby
{
    login: 'ftpuser', # ftp login
    password: 'secret', # ftp password
    home: '/home/ftp', # ftp folder for the user, he's chrooted into this folder
    system_user: 'ftp', # system user to impersonate
    system_group: 'ftp' # system group to impersonate
}
```

firewall
--------

Open ftp port on firewall using opscode firewall cookbook. The default rule make port 21 world
accessible. You can control this behavior using the `node['pure_ftpd']['firewall_allow']` attribute
 to specify a range of allowed sources (e.g. `'10.0.0.0/8'`)

# Author

Author:: Fabio Napoleoni (<f.napoleoni@gmail.com>)
