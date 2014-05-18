require 'spec_helper'

describe CMA::Merger do

  subject { described_class.new(1, 0.4) }

  def combiner(data)
    [data].to_enum(:each).nil_enum
  end

  it 'should keep account id' do
    merger = subject.enum_for(combiner({'Account ID' => 42}))

    merger.to_a.first["Account ID"].should == 42
  end

  it 'should keep Last Avg CPC real value' do
    merger = subject.enum_for(combiner({'Last Avg CPC' => 42}))

    merger.to_a.first["Last Avg CPC"].should == 42
  end

  it 'should not keep Last Avg CPC zero value' do
    merger = subject.enum_for(combiner({'Last Avg CPC' => 0}))

    merger.to_a.first["Last Avg CPC"].should == nil
  end

  it 'should keep Clicks int value' do
    merger = subject.enum_for(combiner({'Clicks' => 0}))

    merger.to_a.first["Clicks"].should == '0'
  end

  it 'should keep Avg CPC float value' do
    merger = subject.enum_for(combiner({'Avg CPC' => '42'}))

    merger.to_a.first["Avg CPC"].should == '42,0'
  end

  it 'should keep number of commissions adjusted' do
    merger = subject.enum_for(combiner({'number of commissions' => '42'}))

    merger.to_a.first["number of commissions"].should == '16,8'
  end

  it 'should keep Commission Value adjusted' do
    merger = subject.enum_for(combiner({'Commission Value' => '42'}))

    merger.to_a.first["Commission Value"].should == '16,8'
  end
end
