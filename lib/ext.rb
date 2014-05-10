require_relative 'nil_enumerator'
class Enumerator
  def to_nil_enum
    NilEnumerator.new(self)
  end
  alias_method :nil_enum, :to_nil_enum
end
