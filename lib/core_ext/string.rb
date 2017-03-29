class String
  DISALLOWED_CHARACTERS = "[\-\s\.\,\?\'\"\:\;\\\/]"

  def humanize
    gsub(DISALLOWED_CHARACTERS, " ").split(" ").map(&:capitalize).join("")
  end

  def underscore
    u = ""
    sanitize.split("").each_with_index do |c, i|; if i > 0 && c == c.upcase; u += " "; end; u += c.downcase; end;
    u.gsub(" ", "_")
  end

  def sanitize
    gsub(DISALLOWED_CHARACTERS, "_")
  end

end