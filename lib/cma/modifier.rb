module CMA
  DEFAULT_CSV_OPTIONS = { col_sep: "\t", headers: :first_row }
  DEFAULT_WRITE_CSV_OPTIONS = DEFAULT_CSV_OPTIONS.merge(row_sep: "\r\n")

  class Modifier
    KEYWORD_UNIQUE_ID = 'Keyword Unique ID'

    LINES_PER_FILE = 120000

    def initialize(saleamount_factor, cancellation_factor)
      @merger = Merger.new(saleamount_factor, cancellation_factor)
    end

    def modify(output, input)
      input = Sorter.sort(input)

      input_enumerator = lazy_read(input)

      combiner = combiner_from(input_enumerator)

      merger = merger_from(combiner)

      write_output(output, merger)
    end


    private
      def write_output(output, merger)
        file_index = 0
        file_name = output.gsub('.txt', '')
        while merger.peek do
          CSV.open("#{file_name}_#{file_index}.txt", "wb", DEFAULT_WRITE_CSV_OPTIONS) do |csv|
            csv << merger.peek.keys
            line_count = 1
            while merger.peek && line_count < LINES_PER_FILE
              csv << merger.next
              line_count +=1
            end
            file_index += 1
          end
        end
      end

      def combiner_from(input_enumerator)
        Combiner.new do |value|
          value[KEYWORD_UNIQUE_ID]
        end.combine(input_enumerator).nil_enum
      end

      def merger_from(combiner)
        @merger.enum_for(combiner)
      end

      def lazy_read(file)
        Enumerator.new do |yielder|
          CSV.foreach(file, DEFAULT_CSV_OPTIONS) do |row|
            yielder.yield(row)
          end
        end
      end
  end
end
