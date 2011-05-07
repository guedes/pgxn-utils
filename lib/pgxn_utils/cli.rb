module PgxnUtils
  class CLI < Thor
    desc "create_extension EXTENSION_NAME", "creates an extension skeleton in current directory"
    def create_extension(extension_name)
      %x[bash -c "mkdir -p #{extension_name}/{sql,doc,test/{sql,expected}}"]
      %x[bash -c "touch #{extension_name}/{sql/{#{extension_name},uninstall_#{extension_name}}.sql,doc/#{extension_name}.md,test/{sql/base.sql,expected/base.out}}"]
      %x[echo "results/" > #{extension_name}/.gitignore]
      %x[touch #{extension_name}/META.json]
      %x[touch #{extension_name}/Makefile]
      %x[touch #{extension_name}/#{extension_name}.control]
    end
  end
end
