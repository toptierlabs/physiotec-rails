class String
  def as_sym
    self.parameterize.underscore.to_sym
  end
end