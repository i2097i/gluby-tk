# GlubyTK

[![Gem Version](https://badge.fury.io/rb/gluby-tk.svg)](https://badge.fury.io/rb/gluby-tk)  [![master](https://travis-ci.org/i2097i/gluby-tk.svg?branch=master)](https://travis-ci.org/i2097i/gluby-tk)  [![develop](https://travis-ci.org/i2097i/gluby-tk.svg?branch=develop)](https://travis-ci.org/i2097i/gluby-tk)

GlubyTK (Glade+Ruby+GTK) is a tool for creating GTK applications in Ruby with Glade.

## Installation

Add this line to your application's Gemfile:

    $ gem install gluby-tk

## Usage

### Create & run a new Gluby project
    $ gluby new my_app_name && cd my_app_name && ruby main.rb

### Add a new glade template
Using [Glade](https://glade.gnome.org/), create a new widget template and save it to your project's 'interface' directory with the extension ```.glade```. Then from the root of your project run 
    
    $ gluby rebuild true

This command will parse your template and create the required ruby class & bindings.

> NOTE: If you want access to any elements in the template you will need to define a value for the ID field in glade.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/i2097i/gluby-tk.
> Feel free to send any comments/improvements suggestions.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

