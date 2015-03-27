module Releasecop
  class Checker
    attr_accessor :name, :envs

    def initialize(name, envs)
      self.name = name
      self.envs = envs
    end

    # Reports status of individual project. Returns count of out-of-date environments.
    def check
      puts "#{name}..."
      unreleased = 0
      Dir.chdir(CONFIG_DIR) do
        `git clone #{envs.first['git']} --bare #{name} > /dev/null 2>&1`
        Dir.chdir(name) do
          envs.each do |env|
            `git remote add #{env['name']} #{env['git']} > /dev/null 2>&1`
            `git fetch #{env['name']} > /dev/null 2>&1`
          end
          envs.each_cons(2) do |ahead, behind|
            log = `git log #{behind['name']}/#{behind['branch'] || 'master'}..#{ahead['name']}/#{ahead['branch'] || 'master'} --pretty=format:"%h %ad %s (%an)" --date=short --no-merges`
            if log == ''
              puts "  #{behind['name']} is up-to-date with #{ahead['name']}\n"
            else
              puts "  #{behind['name']} is behind #{ahead['name']} by:"
              log.lines.each { |l| puts "    #{l}" }
              unreleased += 1
            end
          end
        end
      end
      unreleased
    end

  end
end
