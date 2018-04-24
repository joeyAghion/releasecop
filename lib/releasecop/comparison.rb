class Comparison
  attr_accessor :lines, :behind, :ahead

  def initialize(ahead, behind)
    @ahead = ahead
    @behind = behind
  end

  def check
    @lines = log.lines
  end

  def unreleased?
    !lines.empty?
  end

  private

  def log
    `git log #{@ahead.for_rev_range}..#{@behind.for_rev_range} --pretty=format:"%h %ad %s (%an)" --date=short --no-merges`
  end
end
