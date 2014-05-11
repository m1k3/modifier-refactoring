require 'spec_helper'

describe CMA::Modifier do
  let(:output_location) { File.expand_path('../../fixtures/project_2012-07-27_2012-10-10_performancedata_0.txt', __FILE__) }
  let(:sorted_location) { File.expand_path('../../fixtures/project_2012-07-27_2012-10-10_performancedata.txt.sorted', __FILE__) }

  before :each do
    FileUtils.rm_rf output_location
    FileUtils.rm_rf sorted_location
  end

  it 'sorts and applies modification to an input CSV file' do
    input = modified = File.expand_path('../../fixtures/project_2012-07-27_2012-10-10_performancedata.txt', __FILE__)
    CMA::Modifier.new(1, 0.4).modify(modified, input)

    File.exists?(output_location).should be_true
    File.exists?(sorted_location).should be_true
  end
end
