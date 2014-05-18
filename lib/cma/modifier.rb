module CMA
  DEFAULT_CSV_OPTIONS = { col_sep: "\t", headers: :first_row }
  DEFAULT_WRITE_CSV_OPTIONS = DEFAULT_CSV_OPTIONS.merge(row_sep: "\r\n")

  class Modifier
    KEYWORD_UNIQUE_ID = 'Keyword Unique ID'

    LINES_PER_FILE = 120000

    def initialize(saleamount_factor, cancellation_factor)
      @adjuster = Adjuster.new(saleamount_factor, cancellation_factor)
    end

    def modify(output, input)
      sorted_input = Sorter.new(input).sort

      input_enumerator = lazy_read(sorted_input)

      adjuster = adjuster_from(input_enumerator)

      write_output(output, adjuster)
    end

    private

    def write_output(output, adjuster)
      file_index = 0
      file_name = output.gsub('.txt', '')
      while adjuster.peek do
        CSV.open("#{file_name}_#{file_index}.txt", 'wb', DEFAULT_WRITE_CSV_OPTIONS) do |csv|
          csv << adjuster.peek.headers
          line_count = 1
          while adjuster.peek && line_count < LINES_PER_FILE
            csv << adjuster.next
            line_count += 1
          end
          file_index += 1
        end
      end
    end

    def adjuster_from(input)
      @adjuster.enum_for(input).nil_enum
    end

    def lazy_read(file)
      CSV.to_enum(:foreach, file, DEFAULT_CSV_OPTIONS)
    end
  end
end
