# vagrant-puppet-icinga2

## Setup

    $ git clone https://github.com/lbetz/vagrant-puppet-icinga2.git icinga2
    $ cd icinga2

    $ git remote add vagrant https://github.com/lbetz/vagrant-puppet-environment.git
    $ git fetch vagrant
    $ git subtree add --squash --prefix=deployment/ vagrant master
    $ git fetch vagrant master

### Puppet Modules

    $ sudo gem install r10k

    $ cd puppet
    $ r10k puppetfile install -v
