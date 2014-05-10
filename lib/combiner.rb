# input:
# - two enumerators returning elements sorted by their key
# - block calculating the key for each element
# - block combining two elements having the same key or a single element, if there is no partner
# output:
# - enumerator for the combined elements
class Combiner

  def initialize(&key_extractor)
    @key_extractor = key_extractor
  end

  def combine(*enumerators)
    Enumerator.new do |yielder|
      last_values = Array.new(enumerators.size)
      done = enumerators.all? { |enumerator| enumerator.nil? }
      while not done
        pick_candidate_values_from_enums(last_values, enumerators)

        done = enumerators.all? { |enumerator| enumerator.nil? } and last_values.compact.empty?
        unless done
          values = pick_values_from_candidate_values(last_values)

          yielder.yield(values)
        end
      end
    end
  end

  private
    def key(value)
      value.nil? ? nil : @key_extractor.call(value)
    end

    def pick_values_from_candidate_values(last_values)
      min_key = min_key(last_values)
      values = Array.new(last_values.size)
      last_values.each_with_index do |value, index|
        if key(value) == min_key
          values[index] = value
          last_values[index] = nil
        end
      end
      values
    end

    def pick_candidate_values_from_enums(last_values, enumerators)
      last_values.each_with_index do |value, index|
        if value.nil? and not enumerators[index].nil?
          begin
            last_values[index] = enumerators[index].next
          rescue StopIteration
            enumerators[index] = nil
          end
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
