# input:
# - two enumerators returning elements sorted by their key
# - block calculating the key for each element
# - block combining two elements having the same key or a single element, if there is no partner
# output:
# - enumerator for the combined elements
require 'core_ext/nil_enumerator'

class Combiner

  def initialize(&key_extractor)
    @key_extractor = key_extractor
  end

  def combine(*enumerators)
    enumerators = enumerators.map{|e| e.nil_enum}
    Enumerator.new do |yielder|
      while !done(enumerators)
        yielder.yield(pick_min_values_from_enums(enumerators))
      end
    end
  end

  private
    def done(enumerators)
      enumerators.all? { |enumerator| enumerator.peek.nil? }
    end

    def last_keys(enumerators)
      enumerators.map { |enumerator| key(enumerator.peek) }
    end

    def pick_min_values_from_enums(enumerators)
      min_key = min_key(last_keys(enumerators))

      enumerators.map do |enumerator|
        enumerator.next if key(enumerator.peek) == min_key
      end
    end

    def key(value)
      value.nil? ? nil : @key_extractor.call(value)
    end

    def min_key(last_keys)
      last_keys.min do |a, b|
        if a.nil? and b.nil?
          0
        elsif a.nil?
          1
        elsif b.nil?
          -1
        else
          a <=> b
        end
      end
    end
end
