require 'pg_query'
require 'pry'

require './split_log_line.rb'
require './log_data.rb'

# the application takes input from the console and performs various searches in the log file
class Application
  attr_reader :log_data

  def initialize(log_data, log_path)
    @log_data = log_data
    @log_path = log_path
  end

  def help
    help_string = <<-doc

Quitting:
  type exit

Search:
  type s for text search
  type t for table search
  type reload to reload the log

Obtaining help:
 type help or ?
doc
    puts help_string
  end

  def search
    log_data.search prompt_input('Enter text you want to find'), :text
  end

  def table_search
    log_data.search prompt_input('Enter table you want to find'), :table
  end

  def reload_log
    @log_data.log_load File.open @log_path
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
      table_search if input == 't'
      reload_log if input == 'reload'
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

  err = arg_error path
  puts err
  return if err

  lg.log_load File.open(path)

  app = Application.new(lg, path)
  app.ui_loop
end

loader
