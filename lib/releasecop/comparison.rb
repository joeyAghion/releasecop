module Releasecop
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
      `git log #{@behind.for_rev_range}..#{@ahead.for_rev_range} --pretty=format:"%h %ad %s (%an, %ae)" --date=short --no-merges`
    end
  end
end
