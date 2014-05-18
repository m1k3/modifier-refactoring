module CMA
  class Adjuster
    LAST_VALUE_WINS = ['Account ID', 'Account Name', 'Campaign', 'Ad Group',
                       'Keyword', 'Keyword Type', 'Subid', 'Paused', 'Max CPC',
                       'Keyword Unique ID', 'ACCOUNT', 'CAMPAIGN', 'BRAND',
                       'BRAND+CATEGORY', 'ADGROUP', 'KEYWORD']
    LAST_REAL_VALUE_WINS = ['Last Avg CPC', 'Last Avg Pos']
    INT_VALUES = ['Clicks', 'Impressions', 'ACCOUNT - Clicks', 'CAMPAIGN - Clicks',
                  'BRAND - Clicks', 'BRAND+CATEGORY - Clicks', 'ADGROUP - Clicks',
                  'KEYWORD - Clicks']
    FLOAT_VALUES = ['Avg CPC', 'CTR', 'Est EPC', 'newBid', 'Costs', 'Avg Pos']
    ADJUST_BY_CANCELLATION = ['number of commissions']
    ADJUST_BY_CANCELLATION_AND_SALESAMOUNT = ['Commission Value',
                                              'ACCOUNT - Commission Value',
                                              'CAMPAIGN - Commission Value',
                                              'BRAND - Commission Value',
                                              'BRAND+CATEGORY - Commission Value',
                                              'ADGROUP - Commission Value',
                                              'KEYWORD - Commission Value']

    def initialize(saleamount_factor, cancellation_factor)
      @saleamount_factor = saleamount_factor
      @cancellation_factor = cancellation_factor
    end

    def enum_for(input)
      Enumerator.new do |yielder|
        while input.peek
          row = input.next
          yielder.yield(adjust_values(row))
        end
      end
    end

    private

      def adjust_values(hash)
        LAST_REAL_VALUE_WINS.each do |key|
          hash[key] = nil if [0, '0', ''].include?(hash[key])
        end
        INT_VALUES.each do |key|
          hash[key] = hash.fetch(key, 0).to_s
        end
        FLOAT_VALUES.each do |key|
          hash[key] = hash.fetch(key, '0').from_german_to_f.to_german_s
        end
        ADJUST_BY_CANCELLATION.each do |key|
          hash[key] = (@cancellation_factor * hash.fetch(key, '0').from_german_to_f).to_german_s
        end
        ADJUST_BY_CANCELLATION_AND_SALESAMOUNT.each do |key|
          hash[key] = (@cancellation_factor * @saleamount_factor * hash.fetch(key, '0').from_german_to_f).to_german_s
        end
        hash
      end
  end
end
