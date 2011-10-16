require File.expand_path('spec/spec_helper')

describe PgxnUtils::CLI do

  before(:all) do
	FileUtils.mv "META.json", "meta.json"
  end

  after(:all) do
	FileUtils.mv "meta.json", "META.json"
    system "rm -rf /tmp/extension.*"
    system "rm -rf extension.*"
  end

  context "#skeleton" do
    before(:each) do
		system "rm -rf /tmp/extension.*"
		system "rm -rf extension.*"
    end

    it "should accepts or not a target" do
      expected_extension = next_extension

      File.should_not exist(expected_extension)
      skeleton "#{expected_extension}", %w|-p /tmp|
      File.should exist("/tmp/#{expected_extension}")

      File.should_not exist(expected_extension)
      skeleton "#{expected_extension}"
      File.should exist(expected_extension)
    end

    it "should store author's name, email, short_description, long_desctiption, tags" do
      expected_extension = next_extension
      expected_name = "Guedes"
      expected_mail = "guedes@none.here"
      expected_abstract = "Short description"
      expected_description = "Very Long description for my cool extension"
      expected_version = "1.0.0"

      skeleton expected_extension, %W|-p /tmp -m #{expected_name} -e #{expected_mail} -t one two tree -a #{expected_abstract} -d #{expected_description} -v #{expected_version}|

      meta = File.read("/tmp/#{expected_extension}/META.json")
      meta.should match(/"name": "#{expected_extension}"/)
      meta.should match(/"abstract": "#{expected_abstract}"/)
      meta.should match(/"description": "#{expected_description}"/)
      meta.should match(/"version": "#{expected_version}"/)
      meta.should match(/"license": "postgresql"/)
      meta.should match(/"release_status": "unstable"/)
      #TODO: I want define how split this from META
      #meta.should match(/"#{expected_name} <#{expected_mail}>"/)
      meta.should match(/"#{expected_name}"/)
      meta.should match(/"file": "sql\/#{expected_extension}.sql"/)
      meta.should match(/"docfile": "doc\/#{expected_extension}.md"/)
      meta.should_not match(/"generated_by": #{expected_name}/)
      meta.should match(/"tags": \[ "one","two","tree" \],/)

      makefile = File.read("/tmp/#{expected_extension}/Makefile")
      makefile.should match(/EXTENSION    = #{expected_extension}/)

      control = File.read("/tmp/#{expected_extension}/#{expected_extension}.control")
      #control.should match(/module_pathname = '\$libdir\/#{expected_extension}'/)
      control.should match(/default_version = '#{expected_version}'/)
    end

    it "should generates a default skeleton" do
      extension = next_extension
      skeleton extension

      Dir["#{extension}/**/{*,.gitignore,.template}"].sort.should == [
        "#{extension}/.gitignore",
        "#{extension}/.template",
        "#{extension}/META.json",
        "#{extension}/Makefile",
        "#{extension}/README.md",
        "#{extension}/doc",
        "#{extension}/doc/#{extension}.md",
        "#{extension}/sql",
        "#{extension}/sql/#{extension}.sql",
        "#{extension}/sql/uninstall_#{extension}.sql",
        "#{extension}/test",
        "#{extension}/test/expected",
        "#{extension}/test/expected/base.out",
        "#{extension}/test/sql",
        "#{extension}/test/sql/base.sql",
        "#{extension}/#{extension}.control"
      ].sort

      template = File.read("#{extension}/.template").chomp
	  template.should == "sql"
    end

    it "should generates a skeleton for C extensions" do
      extension = next_extension
      skeleton extension, %w|--template c|

      Dir["#{extension}/**/{*,.gitignore,.template}"].sort.should == [
        "#{extension}/.gitignore",
        "#{extension}/.template",
        "#{extension}/META.json",
        "#{extension}/Makefile",
        "#{extension}/README.md",
        "#{extension}/doc",
        "#{extension}/doc/#{extension}.md",
        "#{extension}/sql",
        "#{extension}/sql/#{extension}.sql",
        "#{extension}/sql/uninstall_#{extension}.sql",
        "#{extension}/src",
        "#{extension}/src/#{extension}.c",
        "#{extension}/test",
        "#{extension}/test/expected",
        "#{extension}/test/expected/base.out",
        "#{extension}/test/sql",
        "#{extension}/test/sql/base.sql",
        "#{extension}/#{extension}.control"
      ].sort
      
	  makefile = File.read("#{extension}/Makefile")
	  makefile.should match(/EXTENSION    = #{extension}/)

	  control = File.read("#{extension}/#{extension}.control")
      control.should match(/module_pathname = '\$libdir\/#{extension}'/)
	
      template = File.read("#{extension}/.template").chomp
	  template.should == "c"

	  c_file = File.read("#{extension}/src/#{extension}.c")
	  c_file.should match(/#include "postgres.h"/)
	  c_file.should match(/#include "fmgr.h"/)
	  c_file.should match(/PG_MODULE_MAGIC;/)
	  c_file.should match(/PG_FUNCTION_INFO_V1\(#{extension}\);/)
      c_file.should match(/Datum #{extension}\(PG_FUNCTION_ARGS\);/)
    end

	it "should generates a git repo with --git" do
		expected_extension = next_extension
		skeleton "#{expected_extension}", %w|--git|

		File.should exist("#{expected_extension}/.git")
		lambda{ Grit::Repo.new(expected_extension) }.should_not raise_error
	end

	it "should not generates a git repo with --no-git" do
		expected_extension = next_extension
		skeleton "#{expected_extension}", %w|--no-git|

		File.should_not exist("#{expected_extension}/.git")
		lambda{ Grit::Repo.new(expected_extension) }.should raise_error
	end
  end

  context "#change" do
    it "should change things"
  end

  context "#bundle" do
    it "should bundle to zip by default"
    it "should create the name in semver spec"
  end

  context "#release" do
    it "should send the bundle to PGXN"
  end

end
