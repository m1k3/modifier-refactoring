require_relative 'modifier'

task :clean do
  name = "project_2012-07-27_2012-10-10_performancedata"
  FileUtils.rm Dir["#{ ENV["HOME"] }/workspace/#{name}.txt.sorted"]
  FileUtils.rm Dir["#{ ENV["HOME"] }/workspace/#{name}_*.txt"]
end

task adjust_for_cancellation: :clean do
  modified = input = latest('project_2012-07-27_2012-10-10_performancedata')
  modification_factor = 1
  cancellaction_factor = 0.4
  modifier = Modifier.new(modification_factor, cancellaction_factor)
  modifier.modify(modified, input)

  puts "DONE modifying"
end

task default: :adjust_for_cancellation
