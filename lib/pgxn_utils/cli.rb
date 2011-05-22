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

    def skeleton(extension_name)
      self.set_accessors extension_name

      directory "root", extension_name
    end

    no_tasks do

      def config_options
        file = "#{self.target}/#{self.extension_name}/META.json"
        if File.exist?(file)
          @@config_options ||= JSON.load(File.read(file))
        else
          {}
        end

      end

      def set_accessors(extension_name="your_extension_name")
        self.extension_name = extension_name

        self.target          = options[:target]
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
