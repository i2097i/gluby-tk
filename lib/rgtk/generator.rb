module Rgtk
  class Generator
    def self.create app_name
      puts "#{app_name} already exists!" and exit(1) if File.exist?(app_name)
      root = "#{Dir.pwd}/#{app_name}"
      directories = [
        "assets",
        "assets/images",
        "interface",
        "src",
        "src/model",
        "src/view",
        "src/controller"
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
        file.write(get_template_contents("includes.rb.template"))
      }
      
      # Create base module
      module_name = "#{app_name.downcase}"
      main_file = "#{root}/#{module_name}.rb"
      File.open(main_file, "w+") { |file| 
        # file.write("module #{module_name.humanize}\n\nend\n")
        file.write(get_template_contents("boot.rb.template"))
      }

      app_id = module_name.humanize.downcase
      # Create Application
      File.open("#{root}/src/application.rb", "w+") { |file|

        file.write("class Application < Gtk::Application
  def initialize
    super('app.#{app_id}', :handles_open)
    # TODO: Go to login screen if user is not ready logged in
    signal_connect 'activate' do |application|
      @window = ApplicationWindow.new(:application => application)
      @window.present
    end
  end
end
")
      }

      # Create ApplicationWindow
      File.open("#{root}/src/view/application_window.rb", "w+") { |file|
        file.write("class ApplicationWindow < Gtk::ApplicationWindow
  type_register
  class << self
    def init
      set_template(:resource => '/app/#{app_id}/ApplicationWindow.glade')
      # Specify the any UI elements you need to reference in code using the glade ID
      [\"main_box\", \"welcome_label\"].each{|child_id| bind_template_child(child_id)}
    end
  end
  
  def initialize(application: application)
    super(application: application)
  end
end")
      }

      File.open("#{root}/interface/interface.gresource.xml", "w+") { |file|
        file.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<gresources>
  <gresource prefix=\"/app/#{app_id}\">
    <file preprocess=\"xml-stripblanks\">ApplicationWindow.glade</file>
  </gresource>
</gresources>
")
      }

      File.open("#{root}/interface/ApplicationWindow.glade", "w+") { |file|
        file.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!-- Generated with glade 3.20.0 -->
<interface>
  <requires lib=\"gtk+\" version=\"3.20\"/>
  <template class=\"ApplicationWindow\" parent=\"GtkApplicationWindow\">
    <property name=\"can_focus\">False</property>
    <property name=\"window_position\">center</property>
    <property name=\"icon_name\">computer</property>
    <property name=\"gravity\">center</property>
    <property name=\"show_menubar\">False</property>
    <child>
      <object class=\"GtkBox\" id=\"main_box\">
        <property name=\"width_request\">300</property>
        <property name=\"height_request\">300</property>
        <property name=\"visible\">True</property>
        <property name=\"can_focus\">False</property>
        <property name=\"orientation\">vertical</property>
        <child>
          <object class=\"GtkLabel\" id=\"welcome_label\">
            <property name=\"visible\">True</property>
            <property name=\"can_focus\">False</property>
            <property name=\"label\" translatable=\"yes\">Welcome to #{module_name.humanize}!\n\nBuilt with RGTK</property>
          </object>
          <packing>
            <property name=\"expand\">False</property>
            <property name=\"fill\">True</property>
            <property name=\"position\">0</property>
          </packing>
        </child>
      </object>
    </child>
  </template>
</interface>
")
      }
    end

    def self.get_template_contents(template_name)
      File.read("#{template_dir}#{template_name}")
    end

    def self.template_dir
      "#{File.dirname(File.dirname(File.dirname(__FILE__)))}/templates/"
    end
  end
end