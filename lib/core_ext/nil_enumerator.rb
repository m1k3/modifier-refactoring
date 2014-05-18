class NilEnumerator < Enumerator
  def initialize(enum)
    @enum = enum
  end

  def next
    @enum.next
  rescue StopIteration
    nil
  end

  def peek
    @enum.peek
  rescue StopIteration
    nil
  end

  def to_a
    @enum.to_a
  end
end

class Enumerator
  def to_nil_enum
    NilEnumerator.new(self)
  end
  alias_method :nil_enum, :to_nil_enum
end
