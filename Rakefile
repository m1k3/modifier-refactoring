lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'cma'

def latest(name)
  files = Dir["#{ ENV["HOME"] }/workspace/*#{name}*.txt"]

  files.sort_by! do |file|
    last_date = /\d+-\d+-\d+_[[:alpha:]]+\.txt$/.match file
    last_date = last_date.to_s.match(/\d+-\d+-\d+/)

    date = DateTime.parse(last_date.to_s)
    date
  end

  throw RuntimeError if files.empty?

  files.last
end


task :clean do
  FileUtils.rm Dir["#{ ENV["HOME"] }/workspace/*.txt.sorted"]
  FileUtils.rm Dir["#{ ENV["HOME"] }/workspace/*[0-9].txt"]
end

task adjust_for_cancellation: :clean do
  filename = ENV['filename'] || 'project_2012-07-27_2012-10-10_performancedata'
  modification_factor = ENV['modification_factor'] || 1
  cancellaction_factor = ENV['cancellaction_factor'] || 0.4

  modified = input = latest(filename)
  modifier = CMA::Modifier.new(modification_factor.to_f, cancellaction_factor.to_f)
  modifier.modify(modified, input)

  puts "DONE modifying"
end

task default: :adjust_for_cancellation
