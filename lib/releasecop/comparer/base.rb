module Comparer
  class Base
    attr_accessor :lines
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

    def summary_message
      raise NotImplementedError
    end

    def detail_messages
      lines.map { |l| "    #{l}" }
    end
  end
end