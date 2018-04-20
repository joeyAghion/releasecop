module Comparer
  class Git < Base
    def initialize(ahead, behind)
      @ahead = ahead
      @behind = behind
    end

    private

    def log
      `git log #{from_rev}..#{to_rev} --pretty=format:"%h %ad %s (%an)" --date=short --no-merges`
    end

    def from_rev
      [behind_name, behind_branch].join '/'
    end

    def to_rev
      [ahead_name, ahead_branch].join '/'
    end

    def behind_name
      @behind['name']
    end

    def behind_branch
      @behind['branch'] || 'master'
    end

    def ahead_name
      @ahead['name']
    end

    def ahead_branch
      @ahead['branch'] || 'master'
    end

    def summary_message
      if unreleased?
        "  #{behind_name} is behind #{ahead_name} by:\n"
      else
        "  #{behind_name} is up-to-date with #{ahead_name}"
      end
    end
  end
end