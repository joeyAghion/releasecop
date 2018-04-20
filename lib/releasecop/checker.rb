module Releasecop
  class Checker
    DEPLOY_STYLES = [
      HOKUSAI = 'hokusai',
      GIT = 'git'
    ]
    attr_accessor :name, :envs

    def initialize(name, envs)
      self.name = name
      self.envs = envs
    end

    def check
      Dir.chdir(CONFIG_DIR) do
        `git clone #{envs.first['git']} --bare #{name} > /dev/null 2>&1`

        Dir.chdir(name) do
          envs.each do |env|
            `git remote add #{env['name']} #{env['git']} > /dev/null 2>&1`
            `git fetch #{env['name']} > /dev/null 2>&1`
          end

          comparisons = []
          envs.each_cons(2) do |ahead, behind|
            comparisons <<
              case deploy_style
              when HOKUSAI
                Comparer::Hokusai.new
              when GIT
                Comparer::Git.new(ahead, behind)
              end
          end

          comparisons.each &:check
          @result = Result.new(name, comparisons)
        end
      end
    end

    def puts_message(verbose_flag)
      @result.puts_message(verbose_flag)
    end

    def unreleased
      @result.unreleased
    end

    def deploy_style
      Dir.exist?('hokusai') ? HOKUSAI : GIT
    end
  end
end
