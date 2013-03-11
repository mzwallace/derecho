# Derecho

Cloud automation help for the Rackspace Cloud + Chef + Beanstalkapp.  <a href="http://en.wikipedia.org/wiki/Derecho" target="_blank">Derecho</a>?

## <b><i>The Big Idea</i></b>
Heroku ease of use + robust Chef cookbooks + solid hosting on Rackspace
```
$ derecho scale test=4 # scale the test role type to 4 nodes
```
<pre>
$ cat .derecho

#YAML

accounts:
  rackspace:
    username: rackspace_username
    api_key:  rackspace_api_key
  beanstalkapp:
    domain:   beanstalk_domain
    login:    beanstalk_log
    password: beanstalk_password

lb:
  defaults:
    region:     ord
    http:       http
    algorithm:  least_connections
    protocol:   80
    port:       80
  roles:
    lb-name: 
      key:      value
    www-80:
    secure-80:
      region:   dfw
    secure-443:
      region:   dfw
      protocol: https
      port:     443
      monitor:
        type:     connect
        interval: 10
        timeout:  5
        attempts: 2
      throttling:
        max_connections: 100
        threshold:       25
        limit_to:        25
        timeframe:       5
    
srv:
  defaults:
    region: ord
    flavor: 2
    image:  75fk3dhc7fd46
  roles:
    name: # each ServerName / NodeName will be set to name1, name2, name3 etc
    secure:
      nodes:   2 # if system first initialized it will create 2 nodes
      role:    role[chef_base_role], role[chef_www], recipe[mod_ssl]
      lb:      lb_name # optional -- ie secure-443, if you want to attach to a load balancer
      app:     beanstalk_repo_name/folder # my_secure_app/Production
      monitor: ping # optional -- rackspace health monitor type
    www:
      nodes:   5 # if system first initialized it will create 5 nodes
      flavor:  3
      role:    role[chef_base_role], role[chef_www]
      lb:      www-80
      app:     front_end/Production
      volume:  volume_id
</pre>

## What's actually working?

<b>Right now there is only support for viewing load balancers and server stats, more to come very soon.</b>

#### All Tasks
<pre>
Tasks:
  derecho config # Manage config settings
  derecho lb     # Manage cloud load balancers
  derecho srv    # Manage cloud servers
</pre>

#### Load Balancers
<pre>
$ derecho lb

Tasks:
  derecho lb list # List all cloud load balancers
</pre>

<pre>
$ derecho lb list

Name    lb-80 108347
Port    80
IP(s)   162.38.85.207
Status  ACTIVE
Node(s) 1

Name    lb-443 108647
Port    443
IP(s)   162.38.85.207
Status  ACTIVE
Node(s) 2
</pre>

#### Servers
<pre>
$ derecho srv

Tasks:
  derecho srv list # List all cloud servers
</pre>

<pre>
$ derecho srv list

Name   cs1 d7fa99e2-c1c6-48d0-b846-7e3c291682e0
Flavor 2
Image  5cebb13a-f783-4f8c-8058-c4182c724ccd
IPs    162.38.121.30 (public) 10.177.143.130 (private)
Status ACTIVE

Name   cs2 458e3c59-93e5-480d-bd9f-4dcedfb0dfc5
Flavor 3
Image  846f98e2-ab52-412a-ab05-91b92be40f52
IP(s)  162.38.122.222 (public) 10.177.135.201 (private)
Status ACTIVE

Name   cs3 1ebdfbe4-ba87-4b5b-8fe5-1af769745fb8
Flavor 3
Image  8a3a9f96-b997-46fd-b7a8-a9e740796ffd
IP(s)  162.38.119.60 (public) 10.177.137.239 (private)
Status ACTIVE
</pre>

## Installation

Add this line to your application's Gemfile:

    gem 'derecho'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install derecho

Config File - The .derecho file needs to be in your current working directory.
<pre>
$ cat .derecho    

accounts:
  rackspace:
    username: my_rackspace_username
    api_key:  1234567890
    region:   ord
</pre>

Check your config with:
```
$ derecho config show
```

## Roadmap

1. Chef solo or Chef server? Or both???
2. Easy configuration using derecho config <b><i>In Progress</i></b>
3. Ability to add / remove servers to / from load balancers
4. Ability to create servers like with chef's knife rackspace command.
5. Once a server is spun up the server is added to a beanstalkapp deployment environment and the same revision that lives on other servers would then be deployed to our new server.
6. Once a server is spun up a ping health check monitor would be added.
7. The server will then be added to the load balancer.
8. More to follow...

### Wishlist

1. Ability to spin up chef server with one command.
2. A subcommand dedicated to building out entire computer networks from a config file.

### Todo

1. Refactor CLI to move all Derecho functionality out of Derecho::CLI and into Derecho so it can be used programmatically.

## Help! 

Cause I'm going to need it ... believe it or not this is my first ruby application ever! Here's to hoping it doesn't become vaporware!

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
