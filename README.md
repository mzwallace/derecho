# Derecho

CLI cloud automation gem for the Rackspace Cloud + Chef (+ Beanstalkapp?).  <a href="http://en.wikipedia.org/wiki/Derecho" target="_blank">Derecho</a>?

## <b><i>The Big Idea</i></b>
Heroku ease of use + robust Chef cookbooks + solid hosting on Rackspace
```
$ derecho scale test=4 # scale the test role type to 4 nodes
```
<a href="https://github.com/mzwallace/derecho/wiki/The-Plan">The Plan Extended.</a>

## What's actually working?

<b>Right now there is only support for viewing / creating / deleting load balancers and viewing server stats, more to come very soon.</b>

#### All Tasks
<pre>
Tasks:
  derecho config          # Manage config settings
  derecho help [command]  # Find help on a specific command
  derecho init            # Create a .derecho file in this directory
  derecho lb              # Manage cloud load balancers
  derecho srv             # Manage cloud servers
  derecho version         # Show version number
</pre>

#### Load Balancers
<pre>
$ derecho lb

Tasks:
  derecho lb create [lb-name] [first-server-id]  # Create a load balancer and attach a server to it
  derecho lb delete [lb-id]                      # Delete a load balancer
  derecho lb help [command]                      # Find help on a specific command
  derecho lb list                                # List all cloud load balancers
</pre>

<pre>
$ derecho lb list

Name    lb-80 108347
Port    80
IP(s)   
  162.38.85.207
Status  ACTIVE
Node(s) 1

Name    lb-443 108647
Port    443
IP(s)   
  162.38.85.207
Status  ACTIVE
Node(s) 2
</pre>

Why not make this easy? 

<b>Baby steps only available in github downloaded version of gem as of yet, will release to rubygems soon. Until then you just need to put in the required info upfront.</b>

<pre>
$ derecho lb create

What do you want to name your load balancer? test-lb

Available servers:
1. test1 a3468d3ec7ea
2. test2 7e3c291682e0
3. test3 4dcedfb0dfc5
4. test4 1af769745fb8

Choose a server number: 1

Attach server test1 to load balancer test-lb? yes

Building load balancer:
Name:     test-lb
ID:       1111111
Protocol: HTTP
Port:     80
IP Type:  PUBLIC

Status: BUILD
Status: BUILD
Status: BUILD
Status: BUILD
Status: BUILD
Status: BUILD
Status: BUILD
Status: BUILD
Status: BUILD
Status: BUILD
Status: BUILD
Status: BUILD
Status: BUILD
Status: BUILD
Status: ACTIVE
Operation complete.
</pre>

<pre>
$ derecho lb delete

Available load balancers:
1. test-lb3 333333
2. test-lb2 222222
3. test-lb1 111111

Choose a load balancer number: 3

Delete load balancer test-lb1? yes

Waiting for load balancer to shut down: 
Name: test-lb1 
ID:   111111

Status: PENDING_DELETE
Status: PENDING_DELETE
Status: PENDING_DELETE
Status: PENDING_DELETE
Status: PENDING_DELETE
Status: PENDING_DELETE
Status: PENDING_DELETE
Status: PENDING_DELETE
Status: PENDING_DELETE
Status: PENDING_DELETE
Status: DELETED
Operation complete.
</pre>

#### Servers
<pre>
$ derecho srv

Tasks:
  derecho srv help [command]  # Find help on a specific command
  derecho srv list            # List all cloud servers
</pre>

<pre>
$ derecho srv list

Name   cs1 d7fa99e2-c1c6-48d0-b846-7e3c291682e0
Flavor 2
Image  5cebb13a-f783-4f8c-8058-c4182c724ccd
IPs    
  162.38.121.30 (public) 
  10.177.143.130 (private)
Status ACTIVE

Name   cs2 458e3c59-93e5-480d-bd9f-4dcedfb0dfc5
Flavor 3
Image  846f98e2-ab52-412a-ab05-91b92be40f52
IP(s)  
  162.38.122.222 (public) 
  10.177.135.201 (private)
Status ACTIVE

Name   cs3 1ebdfbe4-ba87-4b5b-8fe5-1af769745fb8
Flavor 3
Image  8a3a9f96-b997-46fd-b7a8-a9e740796ffd
IP(s)  
  162.38.119.60 (public) 
  10.177.137.239 (private)
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
2. ~~Easy configuration using derecho config~~
3. Ability to add / remove servers to / from load balancers <b><i>In Progress</i></b>
4. Ability to create servers like with chef's knife rackspace command.
5. Once a server is spun up the server is added to a beanstalkapp deployment environment and the same revision that lives on other servers would then be deployed to our new server.
6. Once a server is spun up a ping health check monitor would be added.
7. The server will then be added to the load balancer.
8. Ability to spin up chef server with one command.
9. A subcommand dedicated to building out entire computer networks from a config file.


## Help! 

Cause I'm going to need it ... believe it or not this is my first ruby application ever! Here's to hoping it doesn't become vaporware!

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
