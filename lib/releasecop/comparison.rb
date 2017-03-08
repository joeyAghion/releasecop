class Comparison
  attr_accessor :lines

  def initialize(ahead, behind)
    @ahead = ahead
    @behind = behind
  end

  def check
    @lines = log.lines
  end

  def message
    [summary_message, *detail_messages].join
  end

  def unreleased?
    !lines.empty?
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

  def detail_messages
    lines.map { |l| "    #{l}" }
  end
end
