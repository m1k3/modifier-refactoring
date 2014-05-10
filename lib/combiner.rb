# input:
# - two enumerators returning elements sorted by their key
# - block calculating the key for each element
# - block combining two elements having the same key or a single element, if there is no partner
# output:
# - enumerator for the combined elements
require_relative 'ext'
class Combiner

  def initialize(&key_extractor)
    @key_extractor = key_extractor
  end

  def combine(*enumerators)
    enumerators = enumerators.map{|e| e.nil_enum}
    Enumerator.new do |yielder|
      last_values = Array.new(enumerators.size)
      done = enumerators.all? { |enumerator| enumerator.peek.nil? }
      while not done
        last_values = pick_candidate_values_from_enums(last_values, enumerators)

        done = last_values.all? { |last_value| last_value.nil? }
        unless done
          values = pick_values_from_candidate_values(last_values)
          last_values = remove_picked_values(last_values)

          yielder.yield(values)
        end
      end
    end
  end

  private
    def key(value)
      value.nil? ? nil : @key_extractor.call(value)
    end

    def remove_picked_values(last_values)
      min_key = min_key(last_values)
      last_values.map do |value|
        value if key(value) != min_key
      end
    end

    def pick_values_from_candidate_values(last_values)
      min_key = min_key(last_values)
      last_values.map do |value|
        value if key(value) == min_key
      end
    end

    def pick_candidate_values_from_enums(last_values, enumerators)
      last_values.map.each_with_index do |value, index|
        if value.nil? && !enumerators[index].peek.nil?
          enumerators[index].next
        else
          value
        end
      end
    end

    def min_key(last_values)
      last_values.map { |e| key(e) }.min do |a, b|
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
