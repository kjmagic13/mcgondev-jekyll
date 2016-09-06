Jekyll::Hooks.register :site, :pre_render do |site|
	# code to call after Jekyll writes the site
	theme = Development::Theme.new(site)
end

module Development

	class Theme
		def initialize(site)
			@site = site
			@sass_dir = "#{@site.in_source_dir}/_sass"
			@theme_file = "#{@sass_dir}/_theme.scss"
			@theme_dir = "#{@sass_dir}/theme"
			@files = Dir["#{@theme_dir}/**/*.scss"]

			edit_file
			# puts list_var_of('properties', 'category')
		end

		private

		def edit_file
			f = File.open @theme_file, "w+"
			@files.each do |file|
				filename = File.basename(file, ".*")
				filename.slice!(0)
				f.write "@import \"theme/#{filename}\";\n" unless filename == '_variables'
			end
			f.close
		end

		def list_var_of(collection, var, unique=true)
			vars = []
			dir = @site.collections[collection].directory
			@site.collections[collection].entries.each do |file|
				frontmatter_vars = YAML.load File.read("#{dir}/#{file}")
				vars << frontmatter_vars[var]
			end
			unique ? vars.uniq : vars
		end

	end

end
