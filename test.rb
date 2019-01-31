require 'open3'

*rest = ARGV
compile_command = ARGV.join(" ")
puts "using compile command: '#{compile_command}'"

class String
  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end
  def red
    colorize(31)
  end
  def green
    colorize(32)
  end
  def yellow
    colorize(33)
  end
  def pink
	colorize(35)
  end
end

tests = 0
fails = []
Dir.glob('Tests/*.cpp') do |cpp_file|
	stdout, stderr, status = Open3.capture3("#{compile_command} #{cpp_file} Tests/main.cxx")
	tests += 1
	tabs = "\t"
	if stderr.include? "warning"
		puts "[OK]".green + tabs + "#{stderr}".yellow
	elsif stderr.include? "error"
		puts "[OK]".green + tabs + "#{stderr}".red
	elsif stderr.length > 0
		puts "[OK]".green + tabs + "#{stderr}".blue
	else
		puts "[FAIL]".red + tabs + "#{File.basename(cpp_file)}" + " no warnings / errors generated!".pink
		fails << File.basename(cpp_file)
	end
end

puts "----- FAILS -----"
fails.each do |f|
puts f.red
end
if fails.length == 0
	puts "NONE".green + " very well! :)"
end
puts ""
puts "'#{compile_command}': #{fails.length} penalty points (out of #{tests} tests)"