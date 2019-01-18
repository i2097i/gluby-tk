require 'stringio'
require 'nokogiri'

module GlubyTK

  class Generator
    DIR_ASSETS = "assets"
    DIR_ASSETS_IMAGES = "#{DIR_ASSETS}/images"
    DIR_INTERFACE = "interface"
    DIR_SRC = "src"
    DIR_SRC_GLUBY = "#{DIR_SRC}/gluby"

    DIRECTORIES = [
      DIR_ASSETS,
      DIR_ASSETS_IMAGES,
      DIR_INTERFACE,
      DIR_SRC,
      DIR_SRC_GLUBY
    ]

    TEMPLATES = [
      {:name => "main.rb", :path => nil},
      {:name => "includes.rb", :path => "src"},
      {:name => "application.rb", :path => "src"},
      {:name => "ApplicationWindow.glade", :path => "interface"}
    ]

    SAMPLE_CODE_LINES = [
      "# Label Reference: https://ruby-gnome2.osdn.jp/hiki.cgi?pango-markup",
      "welcome_label.margin = 100",
      "welcome_label.use_markup = true",
      "welcome_label.markup = '<span weight=\"heavy\" foreground=\"white\" size=\"x-large\"><b>Generated with GlubyTK</b></span>'",
    ]

    def self.create app_name
      if File.exist?(app_name)
        GlubyTK.gputs "#{app_name} already exists!"
        exit(1)
      end

      root = "#{Dir.pwd}/#{app_name}"

      module_name = "#{app_name.underscore}"

      # Create root directory
      GlubyTK.gputs "Creating new project directory..."
      Dir.mkdir "#{Dir.pwd}/#{app_name}"

      # Create gluby-tkrc file
      File.open("#{root}/.gluby-tkrc", "w+") { |file|
        file.write(module_name)
      } 

      # Create sub-directories
      DIRECTORIES.each do |dir|
        GlubyTK.gputs "Creating directory: #{dir}..."
        Dir.mkdir "#{root}/#{dir}"
      end

      # Generate files from templates      
      TEMPLATES.each do |template|
        template_dest_file = "#{root}/#{template[:path].nil? ? "" : template[:path] + "/"}#{template[:name]}"
        GlubyTK.gputs "Creating #{template_dest_file}"
        File.open(template_dest_file, "w+") { |file|
          file.write(get_template_contents("#{template[:name]}.template").gsub("gluby-tk_app_id", module_name))
        }
      end
      
      # Construct gresource file & ruby classes
      rebuild(root)

      # Add in example code
      GlubyTK::FileOperator.add_lines_to_file("#{root}/#{DIR_SRC}/application_window.rb", SAMPLE_CODE_LINES.map{|scl| "\t\t#{scl}\n"}, "begin_sample_code")

      GlubyTK.gputs "Finished creating #{module_name}"
      GlubyTK.gputs "Done!"
    end

    def self.rebuild(root = nil)
      GlubyTK.gputs "Constructing gresource file..."
      root = root || Dir.pwd

      interface_files = Dir["#{root}/interface/*.glade"]

      gluby_class_matcher = "#{root}/src/gluby/gluby_*.rb"
      system("rm #{gluby_class_matcher}") if Dir[gluby_class_matcher].any?
      
      gresource_file_contents = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
      gresource_file_contents += "<gresources>\n"
      
      interface_files.each { |filename|
        gresource_file_contents += "<gresource prefix=\"/app/#{current_app_name(root)}\">"
        gresource_file_contents += "<file preprocess=\"xml-stripblanks\">#{File.basename(filename)}</file>"
        gresource_file_contents += "</gresource>"
        generate_ruby_class_for_document(File.basename(filename), File.read(filename), root)
      }
      
      gresource_file_contents += "</gresources>\n"

      File.open("#{root}/interface/interface.gresource.xml", "w+") { |file|
        file.write(Nokogiri::XML(gresource_file_contents, &:noblanks))
      }
    end

    def self.generate_ruby_class_for_document(file_name, file_contents, root)
      doc = Nokogiri::XML(file_contents)
      
      if doc.css("template").first.nil?
        main_template = doc.css("object").first
        class_name = main_template["id"]
        parent = main_template["class"]
      else
        main_template = doc.css("template").first
        class_name = main_template["class"]
        parent = main_template["parent"]
      end
      
      parent = parent.gsub("Gtk","")

      base_file_name = "#{file_name.gsub(File.extname(file_name), "").underscore}"

      GlubyTK.gputs "Constructing #{base_file_name} Ruby class..."

      gluby_file_dir = "#{root}/src/gluby"
      gluby_file_path = "#{gluby_file_dir}/gluby_#{base_file_name}.rb"
      gluby_class_file_contents = [
        "class #{class_name.underscore.humanize} < Gtk::#{parent}",
        "\ttype_register",
        "\tclass << self",
        "\t\tdef init",
        "\t\t\tset_template(:resource => '/app/#{current_app_name(root)}/#{file_name}')",
        "\t\t\t#{doc.css("[id]").map{|e| e.attributes["id"].value.to_sym }.select{|e| e != class_name.to_sym }}.each{|child_id| bind_template_child(child_id)}",
        "\t\tend",
        "\tend",
        "end"
      ].join("\n")

      File.open(gluby_file_path, "w+") { |file|
        GlubyTK.gputs "Writing #{gluby_file_path}..."
        file.write gluby_class_file_contents
      }

      # TODO: Need to ensure that the user-facing class (not the gluby_class_name) reflects any updates such as root class name change etc.
      file_path = "#{root}/src/#{base_file_name}.rb"
      app_name = current_app_name(root).humanize
      if !File.exist?(file_path)
        GlubyTK.gputs "#{file_path} did not exist. Creating..."
        class_file_contents = [
          "class #{class_name.underscore.humanize}",
          "\tAPP_NAME = \"#{app_name}\"",
          "\tdef initialize(args = nil)",
          "\t\tsuper(args)",
          "\t\tGLib.set_application_name(APP_NAME)",
          "\t\tset_wmclass(APP_NAME, APP_NAME)",
          "\t\t# begin_sample_code",
          "\t\t# end_sample_code",
          "\tend",
          "end"
        ].join("\n")

        File.open(file_path, "w+") { |file|
          GlubyTK.gputs "Writing #{file_path}..."
          file.write class_file_contents
        }
      end

      File.open("#{gluby_file_dir}/gluby_includes.rb", "a+") { |file|
        contents = file.read
        g_req = "require 'gluby_#{base_file_name}'"
        req = "require '#{base_file_name}'"

        GlubyTK.gputs "Checking require entries for #{base_file_name}..."
        file.write("#{g_req}\n") if contents.match(g_req).nil?
        file.write("#{req}\n") if contents.match(req).nil?
      }
    end

    # Helpers

    def self.get_template_contents(template_name)
      File.read("#{template_dir}#{template_name}")
    end

    def self.template_dir
      "#{File.dirname(File.dirname(File.dirname(__FILE__)))}/templates/"
    end

    def self.current_app_name(dir = nil)
      File.read(glubytk_rc_path(dir)).strip
    end

    def self.is_glubytk_directory?(dir = nil)
      is_g_project = File.exist?(glubytk_rc_path(dir))
      
      GlubyTK.gputs "No GlubyTK project detected. Please make sure you are in the right directory." if !is_g_project
      
      return is_g_project
    end

    def self.glubytk_rc_path(dir = nil)
      "#{dir || Dir.pwd}/.gluby-tkrc"
    end
  end
end