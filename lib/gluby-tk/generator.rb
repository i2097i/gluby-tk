require 'nokogiri'
require 'pp'

module GlubyTK
  class Generator
    DIRECTORIES = [
      "assets",
      "assets/images",
      "interface",
      "src",
      "src/model",
      "src/view",
      "src/controller"
    ]

    TEMPLATES = [
      {:name => "main.rb", :path => ""},
      {:name => "includes.rb", :path => "src"},
      {:name => "application.rb", :path => "src"},
      {:name => "ApplicationWindow.glade", :path => "interface"}
    ]

    def self.create app_name
      if File.exist?(app_name)
        puts "#{app_name} already exists!"
        exit(1)
      end

      root = "#{Dir.pwd}/#{app_name}"

      module_name = "#{app_name.underscore}"

      app_id = module_name.humanize.downcase

      # Create root directory
      Dir.mkdir "#{Dir.pwd}/#{app_name}"

      # Create gluby-tkrc file
      File.open("#{root}/.gluby-tkrc", "w+") { |file|
        file.write(module_name)
      } 

      # Create sub-directories
      DIRECTORIES.each do |dir|
        Dir.mkdir "#{root}/#{dir}"
      end

      # Generate files from templates      
      TEMPLATES.each do |template|
        File.open("#{root}/#{template[:path]}/#{template[:name]}", "w+") { |file|
          file.write(get_template_contents("#{template[:name]}.template").gsub("gluby-tk_app_id", app_id))
        }
      end
      
      rebuild(root, true)
    end

    def self.rebuild(root = nil, generate_ruby_classes = false)
      unless is_glubytk_directory?(root)
        puts "No GlubyTK project detected. Please make sure you are in the right directory"
        exit(1)
      end

      root = root || Dir.pwd

      interface_files = Dir["#{root}/interface/*.glade"]
      gresource_file_contents = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
      gresource_file_contents += "<gresources>\n"
      interface_files.each { |filename|
        gresource_file_contents += "<gresource prefix=\"/app/#{current_app_name(root)}\">"
        gresource_file_contents += "<file preprocess=\"xml-stripblanks\">#{File.basename(filename)}</file>"
        gresource_file_contents += "</gresource>"
        if generate_ruby_classes
          generate_ruby_class_for_document(File.basename(filename), File.read(filename), root)
        end
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

      class_file_contents = [
        "class #{class_name} < Gtk::#{parent}",
        "\ttype_register",
        "\tclass << self",
        "\t\tdef init",
        "\t\t\tset_template(:resource => '/app/#{current_app_name(root)}/#{file_name}')",
        "\t\t\t#{doc.css("[id]").map{|e| e.attributes["id"].value }.to_s}.each{|child_id| bind_template_child(child_id)}",
        "\t\tend",
        "\tend",
        "end"
      ].join("\n")

      new_file_path = "#{root}/src/view/#{file_name.gsub(File.extname(file_name), "").underscore}.rb"
      File.open(new_file_path, "w+") { |file|
        file.write class_file_contents
      }
    end

    # Helpers

    private

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
      File.exist?(glubytk_rc_path(dir))
    end

    def self.glubytk_rc_path(dir = nil)
      "#{dir || Dir.pwd}/.gluby-tkrc"
    end

  end
end