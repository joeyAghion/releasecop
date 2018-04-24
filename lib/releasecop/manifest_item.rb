class ManifestItem
  attr_reader :git, :branch, :name, :hokusai_tag

  def initialize(repo_name, item)
    @repo_name = repo_name
    @git = item['git']
    @name = item['name']
    @branch = item['branch'] || 'master'
    @hokusai_tag = item['hokusai']
  end

  def for_rev_range
    @sha ||= find_hokusai_sha if @hokusai_tag
    @sha || [@name, @branch].join('/')
  end

  private

  def working_dir
    "#{@repo_name}-#{@name}-working"
  end

  def find_hokusai_sha
    images_output = `hokusai registry images`
    tags = images_output.lines.grep(/\d{4}.* | .* | .*/).map{|l| l.split(' | ').last.split(',').map(&:strip)}
    tags.detect{|t| t.include?(@hokusai_tag) }.detect{|t| t[/^[0-9a-f]{40}$/]}
  end
end