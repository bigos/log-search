require 'pg_query'
require 'pry'

require './split_log_line.rb'
require './log_data.rb'

# the application takes input from the console and performs various searches in the log file
class Application
  attr_reader :log_data

  def initialize(log_data)
    @log_data = log_data
  end

  def help
    help_string = <<-doc

Quitting:
  type exit

Search:
  type s

Obtaining help:
 type help or ?
doc
    puts help_string
  end

  def search
    log_data.search prompt_input 'Enter text you want to find'
  end

  def prompt_input(prompt)
    puts prompt
    STDIN.gets.strip
  end

  def ui_loop
    prompt = " \nready > "
    help
    loop do
      puts prompt
      input = STDIN.gets.strip
      break if input == 'exit'

      help if input == 'help' || input == '?'
      search if input == 's'

    end
    puts "\n exiting...\n"
  end

end

# ----------------------------------------------
def arg_error(path)
  return 'You forgot to give me a path to the log file' unless path
  return "File #{path} does not exist" unless File.exist?(path)
  nil
end

def loader
  lg = LogData.new
  path = ARGV[0]
  table = ARGV[1]

  err = arg_error path
  puts err
  return if err

  lg.log_load File.open(path)

  app = Application.new(lg)
  app.ui_loop
end

$A = 0
loader
