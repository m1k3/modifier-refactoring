module CMA
  class Merger
    LAST_VALUE_WINS = ['Account ID', 'Account Name', 'Campaign', 'Ad Group', 'Keyword', 'Keyword Type', 'Subid', 'Paused', 'Max CPC', 'Keyword Unique ID', 'ACCOUNT', 'CAMPAIGN', 'BRAND', 'BRAND+CATEGORY', 'ADGROUP', 'KEYWORD']
    LAST_REAL_VALUE_WINS = ['Last Avg CPC', 'Last Avg Pos']
    INT_VALUES = ['Clicks', 'Impressions', 'ACCOUNT - Clicks', 'CAMPAIGN - Clicks', 'BRAND - Clicks', 'BRAND+CATEGORY - Clicks', 'ADGROUP - Clicks', 'KEYWORD - Clicks']
    FLOAT_VALUES = ['Avg CPC', 'CTR', 'Est EPC', 'newBid', 'Costs', 'Avg Pos']
    ADJUST_BY_CANCELLATION = ['number of commissions']
    ADJUST_BY_CANCELLATION_AND_SALESAMOUNT = ['Commission Value', 'ACCOUNT - Commission Value', 'CAMPAIGN - Commission Value', 'BRAND - Commission Value', 'BRAND+CATEGORY - Commission Value', 'ADGROUP - Commission Value', 'KEYWORD - Commission Value']

    def initialize(saleamount_factor, cancellation_factor)
      @saleamount_factor = saleamount_factor
      @cancellation_factor = cancellation_factor
    end

    def enum_for(combiner)
      Enumerator.new do |yielder|
        while combiner.peek
          list_of_rows = combiner.next
          merged = combine_hashes(list_of_rows)
          yielder.yield(combine_values(merged))
        end
      end.nil_enum
    end

    private

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
        ADJUST_BY_CANCELLATION.each do |key|
          hash[key] = (@cancellation_factor * hash[key][0].from_german_to_f).to_german_s
        end
        ADJUST_BY_CANCELLATION_AND_SALESAMOUNT.each do |key|
          hash[key] = (@cancellation_factor * @saleamount_factor * hash[key][0].from_german_to_f).to_german_s
        end
        hash
      end

      def combine_hashes(list_of_rows)
        list_of_rows.each_with_object(Hash.new {|h, k| h[k] = []}) do |row, hashes|
          next if row.nil?
          row.each do |k, v|
            hashes[k] << v
          end
        end
      end
  end
end
