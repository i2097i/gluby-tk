# GlubyTK

##### __Current Version:__
[![Gem Version](https://badge.fury.io/rb/gluby-tk.svg)](https://badge.fury.io/rb/gluby-tk)

##### CI Status:

> __Master:__ [![master](https://travis-ci.org/i2097i/gluby-tk.svg?branch=master)](https://travis-ci.org/i2097i/gluby-tk)

> __Develop:__ [![develop](https://travis-ci.org/i2097i/gluby-tk.svg?branch=develop)](https://travis-ci.org/i2097i/gluby-tk)

GlubyTK (Glade+Ruby+GTK) is a tool for creating GTK applications in Ruby with Glade.

## Installation

Add this line to your application's Gemfile:

    $ gem install gluby-tk

## Usage

The GlubyTK command line tool command is simply called ```gluby``` for simplicity.

### Create & run a new Gluby project
    $ gluby new my_app_name && cd my_app_name && gluby start

### Add a new glade template
Using [Glade](https://glade.gnome.org/), create a new widget template and save it to your project's 'interface' directory with the extension ```.glade```. Then from the root of your project run 
    
    $ gluby rebuild

This command will parse your template and create the required ruby class & bindings.

#### Listening for changes
GlubyTK uses the [guard/listen](https://github.com/guard/listen) gem to listen for any changes to your interface files. When a change is detected it essentially runs the ```gluby rebuild``` command automatically.

    $ gluby listen


> NOTE: If you want access to any Glade elements in Ruby code, you will need to define a value for the ```Composite -> Class``` or ```Non-composite -> ID``` field in Glade.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/i2097i/gluby-tk.
> Feel free to send any comments/improvements suggestions.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

