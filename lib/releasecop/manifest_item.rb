class ManifestItem
  OPTION_KEYS = %w[hokusai tag_pattern]
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

  def working_dir
    "#{@repo_name}-#{@name}-working"
  end

  def find_hokusai_sha
    images_output = `hokusai registry images`
    tags = images_output.lines.grep(/\d{4}.* | .* | .*/).map{|l| l.split(' | ').last.split(',').map(&:strip)}
    tags.detect{|t| t.include?(@options['hokusai']) }.detect{|t| t[/^[0-9a-f]{40}$/]}
  end

  def find_tag_pattern_sha
    `git for-each-ref --format='%(objectname)' --count=1 --sort=-authordate --sort=-committerdate 'refs/tags/#{@options['tag_pattern']}'`.strip
  end
end
