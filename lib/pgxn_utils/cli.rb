module PgxnUtils
  class CLI < Thor
    attr_accessor :extension_name, :author_name, :author_mail
    attr_accessor :short_description, :long_description, :tags

    include Thor::Actions

    desc "create_extension", "Creates an extension skeleton in current directory. Accepts a full path as extension name."
    method_option :extension_name, :aliases => "-e", :required => true
    method_option :author_name, :aliases => "-n", :type => :string, :default => "Your Name Here"
    method_option :author_mail, :aliases => "-m", :type => :string, :default => "your@email.here"
    method_option :tags, :aliases => "-t", :type => :array
    method_option :short_description, :aliases => "-s", :type => :string, :default => "A short description"
    method_option :long_description, :aliases => "-l", :type => :string , :default => "A long description"

    def create_extension
      self.set_accessors
      directory "root", extension_name
    end

    no_tasks do
      def set_accessors
        self.destination_root = File.dirname(options[:extension_name]) || destination_root
        self.extension_name = File.basename(options[:extension_name]) 
        self.author_name = options[:author_name] 
        self.author_mail = options[:author_mail] 
        self.tags = options[:tags] 
        self.short_description = options[:short_description] 
        self.long_description = options[:long_description]
      end
    end

    def self.source_root
      @_source_root ||= File.expand_path('../templates', __FILE__)
    end
  end
end
