module PgxnUtils
  class CLI < Thor
    attr_accessor :extension_name
    attr_accessor :author_name
    attr_accessor :author_mail

    include Thor::Actions

    def self.source_root
      @_source_root ||= File.expand_path('../templates', __FILE__)
    end

    desc "create_extension EXTENSION_PATH [AUTHOR_NAME] [AUTHOR_MAIL]", "Creates an extension skeleton in current directory. A full path is accepted."
    def create_extension(extension_name, author_name="Your Name", author_mail="your@email.here")
      self.destination_root = File.dirname(extension_name) || destination_root
      self.extension_name = File.basename(extension_name)
      self.author_name = author_name
      self.author_mail = author_mail

      directory "root", extension_name
    end
  end
end
