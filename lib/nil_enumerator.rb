class NilEnumerator < Enumerator
  def initialize(enum)
    @enum = enum
  end

  def next
    begin
      @enum.next
    rescue StopIteration
      nil
    end
  end

  def peek
    begin
      @enum.peek
    rescue StopIteration
      nil
    end
  end
end
