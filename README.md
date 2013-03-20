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

<a href="https://github.com/mzwallace/derecho/wiki/Load-Balancers">Load balancer examples</a>

#### Servers
<pre>
$ derecho srv

Tasks:
  derecho srv help [command]  # Find help on a specific command
  derecho srv list            # List all cloud servers
</pre>

<a href="https://github.com/mzwallace/derecho/wiki/Servers">Server examples</a>

## Installation

Add this line to your application's Gemfile:

    gem 'derecho'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install derecho

Config File - The .derecho file needs to be in your current working directory.

Setup your config file
```
$ derecho init
```

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
