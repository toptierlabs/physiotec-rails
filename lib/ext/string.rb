class String
  def as_sym
    self.underscore.parameterize.gsub("-","_").to_sym
  end
end