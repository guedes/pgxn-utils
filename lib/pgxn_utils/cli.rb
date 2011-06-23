module PgxnUtils
  class CLI < Thor
    attr_accessor :extension_name, :target, :maintainer #, :maintainer_mail
    attr_accessor :abstract, :description, :version, :tags
    attr_accessor :license, :release_status, :generated_by
    attr_accessor :pgxn_username, :pgxn_password

    include Thor::Actions
    include PgxnUtils::Constants

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

      if is_extension?("#{self.target}/#{extension_name}")
        raise ArgumentError, "'#{extension_name}' already exists. Please, use 'change' instead 'skeleton'."
      elsif is_extension?(".")
        raise ArgumentError, "You are inside a extension directory, already. Consider use 'change' instead."
      else
        self.set_accessors extension_name

        directory "root", extension_name
      end
    end

    desc "change [extension_name]", "Change META's attributes in current extension."

    method_option :target,            :aliases => "-p", :type => :string, :default => ".", :desc => "Define the target directory"

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
      extension_path, extension_name = resolve_extension_path_and_name(extension_name)

      self.target = extension_path
      self.extension_name = extension_name

      set_accessors(extension_name)

      if is_extension?(extension_path)
        template "root/META.json.tt", "#{extension_path}/META.json"
        template "root/%extension_name%.control.tt", "#{extension_path}/%extension_name%.control"
      else
        raise ArgumentError, "'#{extension_name}' doesn't appears to be an extension. Please, supply the extension's name"
      end
    end

    desc "bundle [extension_name]", "Bundles an extension."

    def bundle(extension_name=".")
      unless is_extension?(extension_name)
        raise ArgumentError, "'#{extension_name}' doesn't appears to be an extension. Please, supply the extension's name"
      else
        path = File.expand_path(extension_name)
        extension_name = File.basename(path)

        self.target = path
        archive_name = "#{path}-#{config_options['version']}"
        ext = "zip"
        archive = "#{archive_name}.#{ext}"

        puts path
        if can_zip?(archive)
          make_dist_clean(path)

          Zippy.create(archive) do |zip|
            Dir["#{path}/**/**"].each do |file|
              zip["#{extension_name}-#{config_options['version']}/#{file.sub(path+'/','')}"] = File.open(file) unless File.directory?(file)
            end
          end
          say_status :create, archive, :green
        end
      end
    end

    desc "release filename", "Release a extension"
    def release(filename)
      send_file_to_pgxn(filename)
    end

    no_tasks do
      def make_dist_clean(path)
        inside path do
          run 'make distclean', :capture => true
        end
      end

      def ask_for_pgxn_credential
        self.pgxn_username = ENV["PGXN_USER"] || HighLine.ask("Enter your PGXN username: ") { |q| q.validate = /^[a-z]([-a-z0-9]{0,61}[a-z0-9])?$/ }
        self.pgxn_password = ENV["PGXN_PASS"] || HighLine.ask("Enter your PGXN password: ") { |q| q.echo =  '*' }
      end

      def check_response(response)
        case response
        when Net::HTTPUnauthorized then 
          say "oops!", :red
          say "It seems that you entered a wrong username or password.", :red
        when Net::HTTPConflict then
          say "conflict!", :yellow
          say "Distribution already exists! Please, check your META.json.", :yellow
        when Net::HTTPSeeOther then
          say "released successfully!", :green
          say "Visit: #{URI.parse(response['Location'])}", :green
        else
          say "Unknown error. (#{response})"
        end
      end

      def prepare_multipart_post_for(filename)
        file_basename = File.basename(filename)
        zip_file = File.open(filename)
        Net::HTTP::Post::Multipart.new(
          UPLOAD_URL.path,
          "archive" => UploadIO.new(zip_file, "application/zip", file_basename),
          "Expect" => ""
        )
      end

      def try_send_file(request, filename)
        Net::HTTP.start(UPLOAD_URL.host, UPLOAD_URL.port) do |http|
          say "Trying to release #{File.basename(filename)} ... "
          http.request(request)
        end
      end

      def send_file_to_pgxn(filename)
        request = prepare_multipart_post_for(filename)
        ask_for_pgxn_credential

        request.basic_auth pgxn_username, pgxn_password
        response = try_send_file(request, filename)
        check_response(response)
      end

      def resolve_extension_path_and_name(extension_name)
        target = options[:target]
        extension_path = "."

        if target != "." && extension_name == "."
          raise ArgumentError, "Please, supply a extension name"
        elsif target == "."
          extension_path = File.expand_path(extension_name)
          extension_name = File.basename(extension_path)
        else
          extension_path = "#{target}/#{extension_name}"
        end
        [ extension_path, extension_name ]
      end

      def can_zip?(archive)
        can_zip = false

        if File.exists?(archive)
          say_status :conflict, archive, :red
          if yes? "Overwrite #{archive}? [yN]"
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
        file = File.join(target, "META.json")

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
