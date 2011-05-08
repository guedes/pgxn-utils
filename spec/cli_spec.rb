require File.expand_path('spec/spec_helper')

describe PgxnUtils::CLI do

  after(:all) do
    system "rm -rf /tmp/*.#{$$}"
  end

  context "create extension" do
    before(:each) do
      @cli = PgxnUtils::CLI.new
    end

    it "should set destination root and extension name when a path is supplied" do
      extension_path = "/tmp/my_cool_extension.#{$$}"
      @cli.create_extension(extension_path)
      @cli.extension_name.should == "my_cool_extension.#{$$}"
      @cli.destination_root.should == "/tmp"
    end

    it "should store author's name and email" do
      @cli.create_extension("/tmp/guedes.extension.#{$$}","Guedes","guedes@nonexistant")
      @cli.author_name.should == "Guedes"
      @cli.author_mail.should == "guedes@nonexistant"
    end

    it "should generates an skeleton" do
      extension_path = "/tmp/extension_test.#{$$}"

      @cli.create_extension(extension_path)

      extension_name = @cli.extension_name
      extension_root = @cli.destination_root

      Dir["#{extension_path}/**/*"].sort.should == [
        "#{extension_path}/META.json",
        "#{extension_path}/Makefile",
        "#{extension_path}/doc",
        "#{extension_path}/doc/#{extension_name}.md",
        "#{extension_path}/sql",
        "#{extension_path}/sql/#{extension_name}.sql",
        "#{extension_path}/sql/uninstall_#{extension_name}.sql",
        "#{extension_path}/test",
        "#{extension_path}/test/expected",
        "#{extension_path}/test/expected/base.out",
        "#{extension_path}/test/sql",
        "#{extension_path}/test/sql/base.sql",
        "#{extension_path}/#{extension_name}.control"
      ].sort
    end

    it "should generates a test skeleton"
    it "should accepts name and email as comand line"
    it "should accepts short and long description as command line"
  end

  context "tests" do
    it "should run tests and returns correct results"
  end

  context "invoke external tasks" do
    it "should execute sucessfuly"
    it "should ignores non-existant external tasks"
  end

  context "manage extension" do
    it "should update and tag version"
    it "should upload to pgxn.org"
  end
end
