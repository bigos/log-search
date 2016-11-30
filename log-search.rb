require 'pg_query'
require 'pry'

class SplitLogLine
  attr_reader :q1, :q2, :q3, :tables
  def initialize(s)
    begin
    @q1 = split_on_esc(s)
    @q2 = @q1[2]

    ris = ' [["'
    query_end = @q2.rindex(ris) || -1
    @q3 = @q2[0..query_end]
    @tables = PgQuery.parse(@q3).tables
    rescue
    end
  end

  private

  def split_on_esc(s)
    s.split("\e")
      .collect { |a| a.split(/\[\d+m/) }
      .collect(&:last)
      .reject(&:nil?)
      .collect(&:strip)
      .reject(&:empty?)
  end
end

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
      end
      parts << l
      li += 1
    end
    @examples << parts
  end

  def search(s)
    @examples.each do |e|
      found = []
      e.each do |el|
        sl = SplitLogLine.new el

        if sl.tables && sl.tables.collect { |x| x.index s }.any?
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
