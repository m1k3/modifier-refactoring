require 'spec_helper'

describe CMA::Adjuster do

  subject { described_class.new(1, 0.4) }

  def input(data)
    [data].to_enum(:each).nil_enum
  end

  it 'should keep account id' do
    merger = subject.enum_for(input('Account ID' => 42))

    merger.to_a.first["Account ID"].should == 42
  end

  it 'should keep Last Avg CPC real value' do
    merger = subject.enum_for(input('Last Avg CPC' => 42))

    merger.to_a.first["Last Avg CPC"].should == 42
  end

  it 'should not keep Last Avg CPC zero value' do
    merger = subject.enum_for(input('Last Avg CPC' => 0))

    merger.to_a.first["Last Avg CPC"].should == nil
  end

  it 'should keep Clicks int value' do
    merger = subject.enum_for(input('Clicks' => 0))

    merger.to_a.first["Clicks"].should == '0'
  end

  it 'should keep Avg CPC float value' do
    merger = subject.enum_for(input('Avg CPC' => '42'))

    merger.to_a.first["Avg CPC"].should == '42,0'
  end

  it 'should keep number of commissions adjusted' do
    merger = subject.enum_for(input('number of commissions' => '42'))

    merger.to_a.first["number of commissions"].should == '16,8'
  end

  it 'should keep Commission Value adjusted' do
    merger = subject.enum_for(input('Commission Value' => '42'))

    merger.to_a.first['Commission Value'].should == '16,8'
  end
end
