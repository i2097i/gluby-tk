require 'listen'
module GlubyTK
  class Listener
    attr_accessor :listener

    def initialize
      GlubyTK.gputs "Starting listener..."
      @listener = Listen.to(Dir.pwd) do |modified, added, removed|
        GlubyTK::Generator.rebuild if (modified + added + removed).map{|path| File.extname(path)}.select{|extension| extension == '.glade'}.any?
      end
      @listener.start
      sleep
    end
  end
end