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

Obtaining help:
 type help or ?
doc
    puts help_string
  end

  def prompt_input(prompt)
    puts prompt
    STDIN.gets.strip
  end

  def ui_loop
    prompt = "\n> "
    help
    loop do
      puts prompt
      input = STDIN.gets.strip
      break if input == 'exit'

      help if input == 'help' || input == '?'
    end
    puts "\n exiting...\n"
  end

end

# ----------------------------------------------
def arg_error(path, table)
  return 'You forgot to give me a path to the log file' unless path
  return "File #{path} does not exist" unless File.exist?(path)
  return 'You forgot to give me a a table name' unless table
  nil
end

def loader
  lg = LogData.new
  path = ARGV[0]
  table = ARGV[1]

  err = arg_error(path, table)
  puts err
  return if err

  lg.log_load File.open(path)

  app = Application.new(lg)
  app.log_data.search(table)
  app.ui_loop
end

loader
