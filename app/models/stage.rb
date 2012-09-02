class Stage
  def self.dir(path=nil)
    if path.blank?
      Rails.root.join(".stage").to_s
    else
      Rails.root.join(".stage", path).to_s
    end
  end
end
