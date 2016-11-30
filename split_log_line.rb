# class for splitting log file into parts
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
      # silent exception
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
