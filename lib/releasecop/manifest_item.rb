class ManifestItem
  attr_reader :git, :branch, :name

  def initialize(repo_name, item)
    @repo_name = repo_name
    @git = item['git']
    @name = item['name']
    @branch = item['branch'] || 'master'
    @hokusai_tag = item['hokusai']
    @sha = find_hokusai_sha if @hokusai_tag
  end

  def for_rev_range
    @sha || [@name, @branch].join('/')
  end

  private

  def working_dir
    "#{@repo_name}-#{@name}-working"
  end

  def find_hokusai_sha
    # @TODO: hokusai expects `hokusai/config.yaml` to be there to work
    # for that we need to clone the app again with actual code and cannot use
    # bare clone of repo, we maybe able to avoid this.
    Dir.chdir(Releasecop::CONFIG_DIR) do
      `git clone #{@git} #{working_dir} > /dev/null 2>&1`
      Dir.chdir(working_dir) do
        images_output = `hokusai registry images`
        tags = images_output.lines.grep(/\d{4}.* | .* | .*/).map{|l| l.split(' | ').last.split(',').map(&:strip)}
        tags.detect{|t| t.include?(@hokusai_tag) }.detect{|t| t[/^[0-9a-f]{40}$/]}
      end
    end
  end

end