module PgxnUtils
  class CLI < Thor
    attr_accessor :extension_name, :target, :maintainer #, :maintainer_mail
    attr_accessor :abstract, :description, :version, :tags
    attr_accessor :license, :release_status, :generated_by

    include Thor::Actions

    desc "skeleton extension_name", "Creates an extension skeleton in current directory."

    method_option :target,            :aliases => "-p", :default => ".",  :desc => "Define the target directory"

    # META required fields
    method_option :maintainer,        :aliases => "-m", :type => :string, :desc => "Maintainer's name <maintainer@email>"
    #method_option :maintainer_mail,   :aliases => "-e", :type => :string, :desc => "Maintainer's mail"
    method_option :abstract,          :aliases => "-a", :type => :string, :desc => "Defines a short description to abstract"
    method_option :license,           :aliases => "-l", :type => :string, :desc => "The extension license."
    method_option :version,           :aliases => "-v", :type => :string, :desc => "Initial version"

    # META optional fields
    method_option :description,       :aliases => "-d", :type => :string, :desc => "A long text that contains more information about extension"
    method_option :generated_by,      :aliases => "-b", :type => :string, :desc => "Name of extension's generator"
    method_option :tags,              :aliases => "-t", :type => :array,  :desc => "Defines extension's tags"
    method_option :release_status,    :aliases => "-r", :type => :string, :desc => "Initial extension's release status"

    def skeleton(extension_name,target=nil)
      self.target = options[:target] || target || "."
      self.set_accessors extension_name

      directory "root", extension_name
    end

    desc "change [extension_name]", "Change META's attributes in current extension."

    # META required fields
    method_option :maintainer,        :aliases => "-m", :type => :string, :desc => "Maintainer's name <maintainer@email>"
    #method_option :maintainer_mail,   :aliases => "-e", :type => :string, :desc => "Maintainer's mail"
    method_option :abstract,          :aliases => "-a", :type => :string, :desc => "Defines a short description to abstract"
    method_option :license,           :aliases => "-l", :type => :string, :desc => "The extension license."
    method_option :version,           :aliases => "-v", :type => :string, :desc => "Initial version"

    # META optional fields
    method_option :description,       :aliases => "-d", :type => :string, :desc => "A long text that contains more information about extension"
    method_option :generated_by,      :aliases => "-b", :type => :string, :desc => "Name of extension's generator"
    method_option :tags,              :aliases => "-t", :type => :array,  :desc => "Defines extension's tags"
    method_option :release_status,    :aliases => "-r", :type => :string, :desc => "Initial extension's release status"

    def change(extension_name=".")
      path = File.expand_path(extension_name)

      target = File.expand_path('..', path)
      extension_name = File.basename(path)

      skeleton(extension_name, target)
    end

    desc "bundle [extension_name]", "Bundles an extension."

    def bundle(extension_name=".")
      unless is_extension?(extension_name)
        say "'#{extension_name}' isn't a valid extension"
      else
        path = File.expand_path(extension_name)
        extension_name = File.basename(path)

        self.target = path
        archive_name = "#{path}-#{config_options['version']}"
        ext = "zip"
        archive = "#{archive_name}.#{ext}"

        if can_zip?(archive)
          Zippy.create(archive) do |zip|
            Dir["#{path}/**/**"].each do |file|
              zip["#{extension_name}-#{config_options['version']}/#{file}"] = File.open(file) unless File.directory?(file)
            end
          end
          say "Extension generated at: #{archive}"
        end
      end
    end

    no_tasks do
      def can_zip?(archive)
        can_zip = false

        if File.exists?(archive)
          if yes? "#{archive} found! Overwrite? [yN]"
            can_zip = true
          else
            can_zip = false
          end
        else
          can_zip = true
        end
      end

      def is_extension?(dir=".")
        File.directory?(dir) && File.exists?("#{dir}/META.json")
      end

      def config_options
        file = ""
        file = File.join(file, self.target) if self.target != "."
        file = File.join(file, self.extension_name) if self.extension_name
        file = File.join(file, "META.json")

        if File.exist?(file)
          @@config_options ||= JSON.load(File.read(file))
        else
          {}
        end
      end

      def set_accessors(extension_name="your_extension_name")
        self.extension_name = extension_name

        self.maintainer      = options[:maintainer]      || config_options["maintainer"]      || "The maintainer's name"
        #self.maintainer_mail = options[:maintainer_mail] || config_options["maintainer_mail"] || "maintainer@email.here"
        self.abstract        = options[:abstract]        || config_options["abstract"]        || "A short description"
        self.license         = options[:license]         || config_options["license"]         || "postgresql"
        self.version         = options[:version]         || config_options["version"]         || "0.0.1"

        self.description     = options[:description]     || config_options["description"]     || "A long description"
        self.generated_by    = options[:generated_by]    || config_options["generated_by"]    || maintainer
        self.tags            = options[:tags]            || config_options["tags"]
        self.release_status  = options[:release_status]  || config_options["release_status"]  || "unstable"

        self.destination_root = target
      end
    end

    def self.source_root
      @_source_root ||= File.expand_path('../templates', __FILE__)
    end
  end
end
