class Float
  def to_german_s
    to_s.gsub('.', ',')
  end
end
