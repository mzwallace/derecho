# Derecho [![Gem Version](https://badge.fury.io/rb/derecho.png)](http://badge.fury.io/rb/derecho)

CLI cloud automation gem for the Rackspace Cloud + Chef (+ Beanstalkapp?).  <a href="http://en.wikipedia.org/wiki/Derecho" target="_blank">Derecho</a>?

## <b><i>The Big Idea</i></b>
Heroku ease of use + robust Chef cookbooks + solid hosting on Rackspace
```
$ derecho scale test=4 # scale the test role type to 4 nodes
```
<a href="https://github.com/mzwallace/derecho/wiki/The-Plan">Wiki: The extended plan</a>

## What's actually working?

I'll try to keep a summary of the tasks that are working below.  Since this is a work in progress, the documentation will likely be consistant with the gem as if you downloaded it directly from this repo (not the RubyGems.org version, but try checking the --pre).

#### All Tasks
<pre>
Tasks:
  derecho config          # Manage config settings
  derecho help [command]  # Find help on a specific command
  derecho init            # Create a .derecho file in this directory
  derecho lb              # Manage load balancers
  derecho srv             # Manage servers
  derecho version         # Show version number
</pre>

#### Load Balancers

All arguments are optional! If you leave them out, you will be prompted with a list of options to choose from.  Also, nothing will happen until you confirm, so go nuts!

<pre>
$ derecho lb

Tasks:
  derecho lb attach [lb-id] [server-id]          # Attach a server to a load balancer
  derecho lb create [lb-name] [first-server-id]  # Create a load balancer and attach a server to it
  derecho lb delete [lb-id]                      # Delete a load balancer
  derecho lb detach [lb-id] [node-id]            # Detach a node from a load balancer
  derecho lb help [command]                      # Find help on a specific command
  derecho lb list                                # List all load balancers
  derecho lb nodes [lb-id]                       # List a load balancer's nodes
</pre>

<a href="https://github.com/mzwallace/derecho/wiki/Load-Balancers">Wiki: Load balancer examples</a>

#### Servers
<pre>
$ derecho srv

Tasks:
  derecho srv help [command]  # Find help on a specific command
  derecho srv list            # List all servers
</pre>

<a href="https://github.com/mzwallace/derecho/wiki/Servers">Wiki: Server examples</a>

## Installation

<a href="https://github.com/mzwallace/derecho/wiki/Installation">Wiki: Installation</a>

The short of it:

```
$ gem install derecho
```
or
```
$ gem search derecho --pre --remote # might find a better version this way
$ gem install derecho --version v###
```
Once the gem is installed ...
```
$ derecho init
```
</pre>

## Roadmap

####Completed / In Progress
1. ~~Easy configuration using derecho config~~
2. ~~Ability to list all the things~~
3. ~~Ability to create / delete load balancers~~
4. Ability to attach nodes to / detach nodes from load balancers <b><i>In Progress</i></b>

####Decisions to be made / What's next
* Ability to create and bootstrap servers like with chef's knife rackspace command.
* Once a server is spun up the server is added to a beanstalkapp deployment environment and the same revision that lives on other servers would then be deployed to our new server.
* Once a server is spun up a ping health check monitor would be added.
* The server will then be added to the load balancer.
* Ability to spin up chef server with one command.
* A subcommand dedicated to building out entire computer networks from a config file.
* Chef solo or Chef server? Or both???

## Help! 

Cause I'm going to need it ... believe it or not this is my first ruby application ever! Here's to hoping it doesn't become vaporware!

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
