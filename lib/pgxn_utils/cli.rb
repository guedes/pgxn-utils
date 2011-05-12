module PgxnUtils
  class CLI < Thor
    attr_accessor :extension_name, :target, :maintainer, :maintainer_mail
    attr_accessor :abstract, :description, :version, :tags
    attr_accessor :license, :release_status, :generated_by

    include Thor::Actions

    desc "skeleton extension_name", "Creates an extension skeleton in current directory."

    method_option :target,            :aliases => "-p", :default => ".",    :desc => "Define the target directory"

    # META required fields
    method_option :maintainer,        :aliases => "-m", :type => :string,   :default => "The maintainer's name", :desc => "Maintainer's name"
    method_option :maintainer_mail,   :aliases => "-e", :type => :string,   :default => "maintainer@email.here", :desc => "Maintainer's mail"
    method_option :abstract,          :aliases => "-a", :type => :string,   :default => "A short description",   :desc => "Defines a short description to abstract"
    method_option :license,           :aliases => "-l", :type => :string,   :default => "postgresql",            :desc => "The extension license."
    method_option :version,           :aliases => "-v", :type => :string,   :default => "0.0.1",                 :desc => "Initial version"

    # META optional fields
    method_option :description,       :aliases => "-d", :type => :string,  :default => "A long description",     :desc => "A long text that contains more information about extension"
    method_option :generated_by,      :aliases => "-b", :type => :string,                                        :desc => "Name of extension's generator"
    method_option :tags,              :aliases => "-t", :type => :array,                                         :desc => "Defines extension's tags"
    method_option :release_status,    :aliases => "-r", :type => :string,  :default => "unstable",               :desc => "Initial extension's release status"

    def skeleton(extension_name)
      self.set_accessors extension_name

      directory "root", extension_name
    end

    no_tasks do
      def set_accessors(extension_name="your_extension_name")
        self.extension_name = extension_name

        self.target = options[:target]
        self.maintainer = options[:maintainer]
        self.maintainer_mail = options[:maintainer_mail]
        self.abstract = options[:abstract]
        self.license = options[:license]
        self.version = options[:version]

        self.description = options[:description]
        self.generated_by = options[:generated_by]
        self.tags = options[:tags]
        self.release_status = options[:release_status]

        self.destination_root = target
      end
    end

    def self.source_root
      @_source_root ||= File.expand_path('../templates', __FILE__)
    end
  end
end
