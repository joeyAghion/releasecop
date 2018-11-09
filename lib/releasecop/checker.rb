module Releasecop
  class Checker
    attr_accessor :name, :envs, :working_dir

    def initialize(name, envs, working_dir = Releasecop::CONFIG_DIR)
      self.name = name
      self.envs = envs.map { |e| Releasecop::ManifestItem.new(name, e) }
      self.working_dir = working_dir
    end

    def check
      Dir.chdir(working_dir) do
        `git clone #{envs.first.git} #{'--bare' if envs.all?(&:bare_clone?)} #{name} > /dev/null 2>&1`

        Dir.chdir(name) do
          envs.each do |env|
            `git remote add #{env.name} #{env.git} > /dev/null 2>&1`
            `git fetch #{env.name} > /dev/null 2>&1`
          end

          comparisons = []
          envs.each_cons(2) do |ahead, behind|
            comparisons << Releasecop::Comparison.new(ahead, behind)
          end

          comparisons.each &:check
          @result = Releasecop::Result.new(name, comparisons)
        end
      end
    end

    def puts_message(verbose_flag)
      @result.puts_message(verbose_flag)
    end

    def unreleased
      @result.unreleased
    end
  end
end
