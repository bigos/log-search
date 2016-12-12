# class for splitting the log file into examples
class LogData
  attr_reader :prelude, :examples

  def initialize
    @prelude = []
    @examples = []
  end

  def log_load(fh)
    lines = fh.read.lines
    puts lines[0]

    @prelude = []
    @examples = []

    li = 0
    parts = []
    lines.each do |l|
      # beginning of example
      if l[0, 3] == '==='
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
      li = 0
      e.each do |el|
        $A += 1
        # binding.pry if $A == 1007

        query = SplitLogLine.new(el).q3
        if query && query.index(s)
          found << [e, li]
        end
        li += 1
      end

      if found.any?

        puts e[0]
        puts e[1].split('[]:').last
        puts e[2].split('[]:').last

        found.each do |l|
          puts l[0][l[1]]
        end
      end
    end
  end
end
