module Releasecop
  class Cli < Thor
    map %w[--version -v] => :version

    def self.exit_on_failure?
      true
    end

    desc "edit", "Open manifest file for editing"
    def edit
      editor = ENV['EDITOR']
      raise Thor::Error, "To open manifest, first set $EDITOR" if editor.nil? || editor.empty?
      command = Shellwords.split(editor) + [Releasecop::MANIFEST_PATH]
      initialize_manifest! unless File.exist?(Releasecop::MANIFEST_PATH)
      system(*command)
    end

    desc "check [PROJECT]", "Check the release status of one or all projects"
    option :all, desc: 'Check all projects listed in manifest'
    option :verbose, desc: 'Output results for up-to-date projects'
    def check(project = nil)
      raise Thor::Error, "Must specify a PROJECT or --all" if project.nil? && !options[:all]

      initialize_manifest! unless File.exist?(Releasecop::MANIFEST_PATH)
      selected = options[:all] ? manifest['projects'] : manifest['projects'].select{|k,v| k == project }
      raise Thor::Error, "No projects found." if selected.empty?

      checkers = selected.map { |name, envs| Releasecop::Checker.new(name, envs) }

      for checker in checkers
        checker.check
        checker.puts_message(options[:verbose])
      end

      unreleased = checkers.map(&:unreleased).inject(&:+)
      $stderr.puts "#{selected.size} project(s) checked. #{unreleased} environment(s) out-of-date."
      exit 1 if unreleased > 0
    end

    desc "--version, -v", "Print the version"
    def version
      puts Releasecop::VERSION
    end

    private

    def manifest
      JSON.parse(File.read(Releasecop::MANIFEST_PATH))
    end

    def initialize_dir!
      FileUtils.mkdir_p(Releasecop::CONFIG_DIR)
    end

    def initialize_manifest!
      initialize_dir!
      File.open(Releasecop::MANIFEST_PATH, 'w') { |f| f.write(Releasecop::DEFAULT_MANIFEST) }
    end
  end
end
