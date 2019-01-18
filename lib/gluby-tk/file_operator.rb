module GlubyTK
  class FileOperator
    def self.add_lines_to_file(path, lines = [], after_line_match = nil)
      unless after_line_match.nil?
        new_contents = ""
        get_io_contents(path).each do |line|
          new_contents << line
          if line.include?(after_line_match)
            lines.each do |l|
              new_contents << l
            end
          end
        end
        write_file path, new_contents
      end
    end

    def self.file_contains_line?(path, line_match)
      get_io_contents(path).each do |line|
        return true if line.include?(line_match)
      end
      false
    end

    private

    def self.get_io_contents(path)
      if File.exist?(path)
        return StringIO.open(File.read(path))
      end
      nil
    end

    def self.write_file(path, contents)
      File.open(path, "wb").write contents
    end
  end
end