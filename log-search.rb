require 'pg_query'
require 'pry'

def log_load(fh)
  lines = fh.read.lines
  # binding.pry
  puts   lines[0]

  prelude = []
  examples = []

  li = 0
  parts = []
  lines.each do |l|
    # beginning of example
    if l[0,3] == '==='
      if prelude.empty?
        prelude << parts
      else
        examples << parts
      end
      parts = []
      parts << l
    else
      parts << l
    end
    li += 1
  end
  examples << parts

  binding.pry
  [prelude, examples]
end

def sesarch(s)

end

# ----------------------------------------------
def loader
  path = ARGV[0]
  table = ARGV[1]
  if path.nil?
    puts 'You forgot to give me a path to the log file'
  elsif table.nil?
    puts 'You forgot to give me a a table name'
  elsif File.exist?(path)
    puts "File exists, going to load it"
    fh = File.open(path)
    s = log_load(fh)
    search(s)
  else
    puts "File #{path} does not exist"
  end
end

loader
