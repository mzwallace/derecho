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

## Usage

The .derecho file needs to be in ~/ or your current working directory.

<b>Right now there is only support for viewing load balancers stats, more to come very soon.</b>

```
$ derecho lb
```
<pre>
ID   108347
Name secure-80
Port 80
IP Address(es) 166.78.85.207
Status ACTIVE
Nodes  1

ID   108647
Name secure-443
Port 443
IP Address(es) 166.78.85.207
Status ACTIVE
Nodes  2
</pre>

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
