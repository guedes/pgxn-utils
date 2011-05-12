module PgxnUtils
  class CLI < Thor
    attr_accessor :extension_name, :target, :author_name, :author_mail
    attr_accessor :short_description, :long_description, :tags

    include Thor::Actions

    desc "skeleton extension_name", "Creates an extension skeleton in current directory."
    method_option :target,            :aliases => "-p", :default => "."
    method_option :author_name,       :aliases => "-n", :type => :string,   :default => "Your Name Here"
    method_option :author_mail,       :aliases => "-m", :type => :string,   :default => "your@email.here"
    method_option :tags,              :aliases => "-t", :type => :array
    method_option :short_description, :aliases => "-s", :type => :string,   :default => "A short description"
    method_option :long_description,  :aliases => "-l", :type => :string ,  :default => "A long description"

    def skeleton(extension_name)
      self.set_accessors extension_name

      directory "root", extension_name
    end

    no_tasks do
      def set_accessors(extension_name="your_extension_name")
        self.extension_name = extension_name

        self.target = options[:target]
        self.author_name = options[:author_name]
        self.author_mail = options[:author_mail]
        self.tags = options[:tags]
        self.short_description = options[:short_description]
        self.long_description = options[:long_description]

        self.destination_root = target
      end
    end

    def self.source_root
      @_source_root ||= File.expand_path('../templates', __FILE__)
    end
  end
end
