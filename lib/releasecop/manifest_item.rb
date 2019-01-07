module Releasecop
  class ManifestItem
    OPTION_KEYS = %w[hokusai tag_pattern aws_access_key_id aws_secret_access_key]
    attr_reader :git, :branch, :name

    def initialize(repo_name, item)
      @repo_name = repo_name
      @git = item['git']
      @name = item['name']
      @branch = item['branch'] || 'master'
      @options = item.select { |k, _v| OPTION_KEYS.include?(k) }
    end

    def for_rev_range
      @sha ||= find_tag_pattern_sha if @options['tag_pattern']
      @sha ||= find_hokusai_sha if @options['hokusai']
      @sha || [@name, @branch].join('/')
    end

    def bare_clone?
      !@options.key?('hokusai')
    end

    private

    def find_hokusai_sha
      images_output = with_aws_env { `hokusai registry images` }
      tags = images_output.lines.grep(/\d{4}.* | .* | .*/).map{|l| l.split(' | ').last.split(',').map(&:strip)}
      tags.detect{|t| t.include?(@options['hokusai']) }.detect{|t| t[/^[0-9a-f]{40}$/]}
    end

    def find_tag_pattern_sha
      `git for-each-ref --format='%(objectname)' --count=1 --sort=-authordate --sort=-committerdate --sort=-creatordate 'refs/tags/#{@options['tag_pattern']}'`.strip
    end

    # not thread-safe
    def with_aws_env(&block)
      ENV.update(
        'AWS_ACCESS_KEY_ID' => @options['aws_access_key_id'],
        'AWS_SECRET_ACCESS_KEY' => @options['aws_secret_access_key']
      )
      yield
    ensure
      ENV.update('AWS_ACCESS_KEY_ID' => nil, 'AWS_SECRET_ACCESS_KEY' => nil)
    end
  end
end
