module PgxnUtils
  class CLI < Thor
    attr_accessor :extension_name, :target, :maintainer #, :maintainer_mail
    attr_accessor :abstract, :description, :version, :tags
    attr_accessor :license, :release_status, :generated_by
    attr_accessor :pgxn_username, :pgxn_password

    include Thor::Actions
    include PgxnUtils::NoTasks

    option :target,            :aliases => "-p", :default => ".",  :desc => "Define the target directory"

    # META required fields
    option :maintainer,        :aliases => "-m", :type => :string, :desc => "Maintainer's name <maintainer@email>"
    option :abstract,          :aliases => "-a", :type => :string, :desc => "Defines a short description to abstract"
    option :license,           :aliases => "-l", :type => :string, :desc => "The extension license"
    option :version,           :aliases => "-v", :type => :string, :desc => "Initial version"

    # META optional fields
    option :description,       :aliases => "-d", :type => :string, :desc => "A long text that contains more information about extension"
    option :generated_by,      :aliases => "-b", :type => :string, :desc => "Name of extension's generator"
    option :tags,              :aliases => "-t", :type => :array,  :desc => "Defines extension's tags"
    option :release_status,    :aliases => "-r", :type => :string, :desc => "Initial extension's release status"
    option :git,               :type => :boolean, :default => false, :desc => "Initialize a git repository after create the extension"
    option :template,          :type => :string, :default => "sql", :desc => "The template that will be used to create the extension. Expected values are: sql, c, fdw"

    desc "skeleton extension_name", "Creates an extension skeleton in current directory"
    def skeleton(extension_name, target=nil, *args)
      self.target = options[:target] || target || "."

      if is_extension?("#{self.target}/#{extension_name}")
        say "'#{extension_name}' already exists. Please, use 'change' instead 'skeleton'.", :red
      elsif is_extension?(self.target)
        say "You are inside a extension directory, already. Consider use 'change' instead.", :red
      elsif is_dir?("#{self.target}/#{extension_name}")
        say "Can't create an extension overwriting an existing directory.", :red
      else
        self.set_accessors extension_name

        directory selected_template, extension_name

        init_repository("#{self.target}/#{extension_name}") if options[:git]
      end
    end

    option :target,            :aliases => "-p", :type => :string, :default => ".", :desc => "Define the target directory"

    # META required fields
    option :maintainer,        :aliases => "-m", :type => :string, :desc => "Maintainer's name <maintainer@email>"
    option :abstract,          :aliases => "-a", :type => :string, :desc => "Defines a short description to abstract"
    option :license,           :aliases => "-l", :type => :string, :desc => "The extension license."
    option :version,           :aliases => "-v", :type => :string, :desc => "Initial version"

    # META optional fields
    option :description,       :aliases => "-d", :type => :string, :desc => "A long text that contains more information about extension"
    option :generated_by,      :aliases => "-b", :type => :string, :desc => "Name of extension's generator"
    option :tags,              :aliases => "-t", :type => :array,  :desc => "Defines extension's tags"
    option :release_status,    :aliases => "-r", :type => :string, :desc => "Initial extension's release status"

    desc "change [extension_name]", "Changes META's attributes in current extension"
    def change(extension_name=".", *args)
      extension_path, extension_name = resolve_extension_path_and_name(extension_name)

      template_type = File.read("#{extension_path}/.template").chomp

      self.target = extension_path
      self.extension_name = extension_name

      set_accessors(extension_name)

      if is_extension?(extension_path)
        template "#{template_type}/META.json.tt", "#{extension_path}/META.json"
        template "#{template_type}/%extension_name%.control.tt", "#{extension_path}/%extension_name%.control"
      else
        say "'#{extension_name}' doesn't appears to be an extension. Please, supply the extension's name", :red
      end
    end

    desc "bundle [extension_name]", "Bundles the extension in a zip file"
    def bundle(extension_name=".")
      unless is_extension?(extension_name)
        say "'#{extension_name}' doesn't appears to be an extension. Please, supply the extension's name", :red
      else
        path = File.expand_path(extension_name)
        extension_name = File.basename(path)

        self.target = path
        archive_name = "#{path}-#{config_options['version']}"
        prefix_name  = "#{extension_name}-#{config_options['version']}/"

        archive = "#{archive_name}.zip"
        archived = false

        if has_scm?(path)
          if is_dirty?(path)
            say "Your repository is dirty! You should commit or stash before continue.", :red
          else
            if can_zip?(archive)
              scm_archive(path, archive, prefix_name)
              archived = true
            end
          end
        else
          if can_zip?(archive)
            make_dist_clean(path)
            zip_archive(path, archive, prefix_name)
            archived = true
          end
        end
        say_status(:create, archive, :green) if archived
      end
    end

    desc "release filename", "Release an extension to PGXN"
    def release(filename)
      send_file_to_pgxn(filename)
    end

    def self.source_root
      @_source_root ||= File.expand_path('../templates', __FILE__)
    end
  end
end
