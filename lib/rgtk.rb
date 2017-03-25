require "rgtk/version"
require "core_ext/string"

module Rgtk
  def self.create app_name
    puts "#{app_name} already exists!" and exit(1) if File.exist?(app_name)
    root = "#{Dir.pwd}/#{app_name}"
    directories = [
      "assets",
      "assets/images",
      "interface",
      "src",
      "model",
      "view",
      "controller"
    ]

    templates = [
      "src/application.rb",
    ]

    

    # Create root directory
    Dir.mkdir "#{Dir.pwd}/#{app_name}"

    # Create sub-directories
    directories.each do |dir|
      Dir.mkdir "#{root}/#{dir}"
    end

    # Create includes file
    File.open("#{root}/src/includes.rb", "w+") { |file| 
      file.write("# Search paths
        $: << 'src/model/'
        $: << 'src/view/'
        $: << 'src/controller/'
        $: << 'src/helpers/'

        # Dependencies
        require 'gtk3'"
      )
    }
    
    # Create base module
    module_name = "#{app_name.downcase}"
    main_file = "#{root}/#{module_name}.rb"
    File.open(main_file, "w+") { |file| 
      file.write("module #{module_name.humanize}\n\nend") 
    }

    # Create Boot file
    File.open("#{root}/boot.rb", "w+") { |file|
      file.write("$: << 'src'
        require 'includes'

        current_path = File.expand_path(File.dirname(__FILE__))
        data_path = \"#{current_path}/interface\"

        gresource_bin = \"#{data_path}/interface.gresource\"
        gresource_xml = \"#{data_path}/interface.gresource.xml\"

        system(\"glib-compile-resources\", \"--target\", gresource_bin, \"--sourcedir\", File.dirname(gresource_xml), gresource_xml)

        at_exit do
          FileUtils.rm_f(gresource_bin)
        end

        resource = Gio::Resource.load(gresource_bin)
        Gio::Resources.register(resource)

        # Start Our Shit
        # Application.new.run"
      ) 
    }
    
  end

end
