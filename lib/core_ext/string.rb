class String
  DISALLOWED_CHARACTERS = /[\-\_\s.,?\'\":\/;\\]/

  def humanize
    gsub(DISALLOWED_CHARACTERS, " ").split(" ").map(&:capitalize).join("")
  end

  def underscore
    u = ""
    chars = sanitize.split("")
    unless chars.count == 0
      while chars.first.match(DISALLOWED_CHARACTERS)
        chars.delete_at(0)
      end

      while chars.last.match(DISALLOWED_CHARACTERS)
        chars.delete_at(chars.count - 1)
      end
    end

    chars.each_with_index do |c, i|
      if c.match(/[A-Za-z]/) && i > 0 && c == c.upcase
        u += " "
      end
      u += c.downcase
    end
    u.gsub(/\s/, "_")
  end

  def sanitize
    gsub(/_{2,}/, "_").gsub(DISALLOWED_CHARACTERS, "_")
  end

end