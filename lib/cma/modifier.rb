module CMA
  DEFAULT_CSV_OPTIONS = { col_sep: "\t", headers: :first_row }
  DEFAULT_WRITE_CSV_OPTIONS = DEFAULT_CSV_OPTIONS.merge(row_sep: "\r\n")

  class Modifier
    KEYWORD_UNIQUE_ID = 'Keyword Unique ID'
    LAST_VALUE_WINS = ['Account ID', 'Account Name', 'Campaign', 'Ad Group', 'Keyword', 'Keyword Type', 'Subid', 'Paused', 'Max CPC', 'Keyword Unique ID', 'ACCOUNT', 'CAMPAIGN', 'BRAND', 'BRAND+CATEGORY', 'ADGROUP', 'KEYWORD']
    LAST_REAL_VALUE_WINS = ['Last Avg CPC', 'Last Avg Pos']
    INT_VALUES = ['Clicks', 'Impressions', 'ACCOUNT - Clicks', 'CAMPAIGN - Clicks', 'BRAND - Clicks', 'BRAND+CATEGORY - Clicks', 'ADGROUP - Clicks', 'KEYWORD - Clicks']
    FLOAT_VALUES = ['Avg CPC', 'CTR', 'Est EPC', 'newBid', 'Costs', 'Avg Pos']

    LINES_PER_FILE = 120000

    def initialize(saleamount_factor, cancellation_factor)
      @saleamount_factor = saleamount_factor
      @cancellation_factor = cancellation_factor
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

      def merger_from(combiner)
        Enumerator.new do |yielder|
          while combiner.peek
            list_of_rows = combiner.next
            merged = combine_hashes(list_of_rows)
            yielder.yield(combine_values(merged))
          end
        end.nil_enum
      end

      def combiner_from(input_enumerator)
        Combiner.new do |value|
          value[KEYWORD_UNIQUE_ID]
        end.combine(input_enumerator).nil_enum
      end

      def combine_values(hash)
        LAST_VALUE_WINS.each do |key|
          hash[key] = hash[key].last
        end
        LAST_REAL_VALUE_WINS.each do |key|
          hash[key] = hash[key].select {|v| not (v.nil? or v == 0 or v == '0' or v == '')}.last
        end
        INT_VALUES.each do |key|
          hash[key] = hash[key][0].to_s
        end
        FLOAT_VALUES.each do |key|
          hash[key] = hash[key][0].from_german_to_f.to_german_s
        end
        ['number of commissions'].each do |key|
          hash[key] = (@cancellation_factor * hash[key][0].from_german_to_f).to_german_s
        end
        ['Commission Value', 'ACCOUNT - Commission Value', 'CAMPAIGN - Commission Value', 'BRAND - Commission Value', 'BRAND+CATEGORY - Commission Value', 'ADGROUP - Commission Value', 'KEYWORD - Commission Value'].each do |key|
          hash[key] = (@cancellation_factor * @saleamount_factor * hash[key][0].from_german_to_f).to_german_s
        end
        hash
      end

      def combine_hashes(list_of_rows)
        keys = []
        list_of_rows.each do |row|
          next if row.nil?
          row.headers.each do |key|
            keys << key
          end
        end
        result = {}
        keys.each do |key|
          result[key] = []
          list_of_rows.each do |row|
            result[key] << (row.nil? ? nil : row[key])
          end
        end
        result
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
