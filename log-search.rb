require 'pg_query'
require 'pry'

require './split_log_line.rb'
require './log_data.rb'

# the application takes input from the console and performs various searches in the log file
class Application
  attr_reader :log_data

  def initialize(log_data)
    @log_data = log_data
    @prompt = ' > '
    @commands = { 't' => :table_search,
                  's' => :string_search }

    ui_loop
  end

  def help
    help_string = <<-doc

Quitting:
  type exit

Obtaining help:
 type help or ?

Search:
type t to search for queries affecting table t

type s to search for log line containing string s
doc
    puts help_string
  end

  def prompt_input(prompt = '')
    print prompt + @prompt
    STDIN.gets.strip
  end

  def table_search
    @log_data.search(:table, prompt_input('enter the part of table name to search for'))
  end

  def string_search
    raise 'not implemented'
  end

  def ui_loop
    help
    loop do
      input = prompt_input
      break if input == 'exit'
      help if input == 'help' || input == '?'

      @commands.each do |k, v|
        if input == k
          send v
          break
        end
      end # end of @commands loop
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
  Application.new(lg)
end

loader
