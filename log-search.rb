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
    puts "\n\nsearch results"
    @examples[10..11].each do |e|
      found = []
      e.each do |el|
        q1 = el.split("\e[0m").last.strip
        q2 = el.split("\e[1m").last.split("[[").first.strip.split("\e[0m").first




        query_part = q1
        query_part = q2 if query_part.empty?
        begin
          if PgQuery.parse(query_part).tables.collect{|x| x.index(s)}.any?

            found << el
          end
        rescue
          puts el
          # we are not interested in parsing errors
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
    puts "\n\n\n\n"


  end # def
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
    print "File #{path} does not exist"
  end
end


loader
