module CMA
  class Sorter
    def initialize(file)
      @file = file
    end

    def sort
      write(content, content_as_table.headers)

      output
    end

    private
      def content
        content_as_table.sort_by { |a| -a['Clicks'].to_i }
      end

      def output
        "#{@file}.sorted"
      end

      def write(content, headers)
        CSV.open(output, "wb", DEFAULT_WRITE_CSV_OPTIONS) do |csv|
          csv << headers
          content.each do |row|
            csv << row
          end
        end
      end

      def content_as_table
        @content_as_table ||= CSV.read(@file, DEFAULT_CSV_OPTIONS)
      end
  end
end
