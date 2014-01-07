class String
  def as_sym
    self.underscore.parameterize.to_sym
  end
end