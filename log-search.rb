require 'pg_query'
require 'pry'

class LogData
  attr_reader :prelude, :examples

  def initialize
    @prelude = []
    @examples = []
  end

  def log_load(fh)
    lines = fh.read.lines
    # binding.pry
    puts   lines[0]

    @prelude = []
    @examples = []

    li = 0
    parts = []
    lines.each do |l|
      # beginning of example
      if l[0,3] == '==='
        if prelude.empty?
          @prelude << parts
        else
          @examples << parts
        end
        parts = []
        parts << l
      else
        parts << l
      end
      li += 1
    end
    @examples << parts
  end

  def search(s)
    @examples.each do |e|
      found = []
      e.each do |el|
        if el.index(s)
          found << el
        end
      end
      if found.any?
        puts e[0]
        puts e[1]
        found.each do |l|
          puts l
        end
      end
    end
  end
end

# ----------------------------------------------
def loader
  lg = LogData.new
  path = ARGV[0]
  table = ARGV[1]
  if path.nil?
    puts 'You forgot to give me a path to the log file'
  elsif table.nil?
    puts 'You forgot to give me a a table name'
  elsif File.exist?(path)
    puts "File exists, going to load it"
    fh = File.open(path)
    lg.log_load(fh)
    lg.search(table)
  else
    puts "File #{path} does not exist"
  end
end


loader
