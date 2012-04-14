module PgxnUtils
  module NoTasks

    include PgxnUtils::Constants
	include Grit

	def selected_template
		template = options[:template]

		unless [ 'sql', 'c', 'fdw' ].include?(template)
			if Dir["#{template}/*"].include?("#{template}/META.json") or
			   Dir["#{template}/*"].include?("#{template}/META.json.tt")
				template = File.expand_path(options[:template])
			else
				raise "invalid template: #{template}"
			end
		end
		template
	end

	def init_repository(extension_dir)
		repo = Repo.init(extension_dir)
		original_dir = File.expand_path "."

		if repo
			say_status :init, "#{extension_dir}", :green

			FileUtils.chdir extension_dir
			repo.add "."
			if repo.commit_index("initial commit")
				say_status :commit, "initial commit", :green
			else
				say_status :failed, "initial commit", :red
			end
		else
			say_status :error, " initializing #{extension_dir}", :red
		end

		FileUtils.chdir original_dir
	end

	def is_dirty?(extension_dir)
		repo = Repo.init(extension_dir)
		repo.status.map(&:type).uniq != [nil]
	end

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
      begin
        http = Net::HTTP.new(UPLOAD_URL.host, UPLOAD_URL.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        say "Trying to release #{File.basename(filename)} ... "
        http.request(request)
      rescue SocketError
        say "Please, check your connection.", :red
        exit(1)
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

	def has_scm?(path)
		begin
			Repo.new(path)
		rescue Grit::InvalidGitRepositoryError
			false
		end
	end

	def scm_archive(path, archive, prefix, treeish='master')
		git = Git.new(Repo.new(path).path)
		git.archive({:format => "zip", :prefix => prefix, :output => archive}, treeish)
	end

	def zip_archive(path, archive, prefix)
		Zip::ZipFile.open(archive, Zip::ZipFile::CREATE) do |zip|
			Dir["#{path}/**/**"].each do |file|
				zip.add("#{prefix}#{file.sub(path+'/','')}", file) unless File.directory?(file)
			end
		end
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
      is_dir?(dir) && File.exists?("#{dir}/META.json")
    end

    def is_dir?(dir)
      File.directory?(dir)
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
end
