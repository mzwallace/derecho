# Derecho

*WORK IN PROGRESS*

Cloud automation help for the Rackspace Cloud + Chef + Beanstalkapp 

## Installation

Add this line to your application's Gemfile:

    gem 'derecho'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install derecho

Config File - The .derecho file needs to be in ~/ or your current working directory.
```
$ cat ~/.derecho
```    
<pre>
rackspace:
  username: my_rackspace_username
  api_key:  1234567890
  region:   ord

beanstalkap:
  domain:   my_beanstalk_subdomain
  login:    my_beanstalk_login
  password: my_beanstalk_password
</pre>

## Usage

<b>Right now there is only support for viewing load balancers and server stats, more to come very soon.</b>

```
$ derecho lb
```
<pre>
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

```
$ derecho srv
```
<pre>
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

## Todo

1. Refactor CLI to move all functionality out of cli.rb and into derecho.rb.

## Roadmap

1. Ability to add / remove servers to / from load balancers
2. Ability to create servers like with chef's knife rackspace command but once it's created it would be added to a specified load balancer.
3. Once a server is spun up the server is added to a beanstalkapp deployment environment and the same revision that lives on other servers would then be deployed to our new server.
4. Once a server is spun up a ping health check monitor would be added.
4. More to follow...

### Wishlist

1. Ability to spin up chef server with one command.
2. A subcommand dedicated to building out entire computer networks from a config file.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
