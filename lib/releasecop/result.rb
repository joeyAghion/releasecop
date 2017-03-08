class Result
  def initialize(name, comparisons)
    @name = name
    @comparisons = comparisons
  end

  def message
    [header, *comparison_messages].join "\n"
  end

  def unreleased
    @comparisons.select(&:unreleased?).count
  end

  private

  def header
    "#{@name}..."
  end

  def comparison_messages
    @comparisons.map &:message
  end
end
