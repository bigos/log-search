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

  def search(s, type)
    @examples.each do |e|
      found = []
      li = 0
      e.each do |el|
        query = SplitLogLine.new(el).q3
        log_text = el.split('[]:')[1]

        if type == :table
          begin
            if query && PgQuery.parse(query).tables.include?(s)
              found << [e, li]
            end
          rescue
            # found << [e, li]
          end
        else # :text
          if log_text && log_text.index(s)
            found << [e, li]
          end
        end
        li += 1
      end

      if found.any?

        puts e[0]
        puts e[1].split('[]:').last
        puts e[2].split('[]:').last

        found.each do |l|
          line = l[0][l[1]]
          if line.index 'ALTER TABLE "schema_migrations"'
            puts "migrations containing #{s} #{line[0, 120]}\e[m"
          else
            puts line
          end
        end
      end
    end
  end
end
