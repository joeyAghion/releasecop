module Comparer
  class Hokusai < Base
    private

    def log
      `hokusai pipeline gitlog`
    end

    def summary_message
      if unreleased?
        "  production is behind staging by:\n"
      else
        "  production is up-to-date with staging"
      end
    end

    def detail_messages
      lines.map { |l| "    #{l}" }
    end
  end
end