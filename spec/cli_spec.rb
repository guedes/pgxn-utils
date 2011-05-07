require File.expand_path('spec/spec_helper')

describe PgxnUtils::CLI do
  before(:each) do
      @cli = PgxnUtils::CLI.new
      @extension_name = "extension_test.#{$$}"
  end
  context "create extension" do
    it "should accepts a path and extracts destination and extension name"

    it "should generates an skeleton" do
      @cli.create_extension(@extension_name)
      Dir["#{@extension_name}/**/*"].sort.should be_eql([
        "#{@extension_name}/META.json", 
        "#{@extension_name}/Makefile",
        "#{@extension_name}/doc", 
        "#{@extension_name}/doc/#{@extension_name}.md", 
        "#{@extension_name}/sql", 
        "#{@extension_name}/sql/#{@extension_name}.sql", 
        "#{@extension_name}/sql/uninstall_#{@extension_name}.sql", 
        "#{@extension_name}/test", 
        "#{@extension_name}/test/expected", 
        "#{@extension_name}/test/expected/base.out", 
        "#{@extension_name}/test/sql", 
        "#{@extension_name}/test/sql/base.sql", 
        "#{@extension_name}/#{@extension_name}.control"
      ].sort)
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
