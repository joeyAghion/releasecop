class Result
  def initialize(name, comparisons)
    @name = name
    @comparisons = comparisons
  end

  def puts_message(verbose_flag)
    if verbose_flag
      puts message
    else
      puts message if unreleased?
    end
  end

  def unreleased
    @comparisons.select(&:unreleased?).count
  end

  private

  def message
    [header, *comparison_messages].join "\n"
  end

  def header
    "#{@name}..."
  end

  def unreleased?
    unreleased > 0
  end

  def comparison_messages
    @comparisons.map &:message
  end
end
