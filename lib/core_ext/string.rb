class String
  def humanize
    self.gsub("_", " ").gsub("-", " ").split(" ").map(&:capitalize).join("")
  end
end