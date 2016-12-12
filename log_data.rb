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
      e.each do |el|
        $A += 1
        binding.pry if $A > 1006
      end

      if found.any?
        binding.pry

        puts e[0]
        puts e[1]

        found.each do |l|
          puts l
        end
      end
    end
  end
end
