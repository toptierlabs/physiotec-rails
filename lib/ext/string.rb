class String
  def as_sym
    self.underscore.parameterize.gsub("-","_").to_sym
  end

  def represents_number?
		to_i.to_s == self
	end
end