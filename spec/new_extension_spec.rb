require File.expand_path('spec/spec_helper')

describe PgxnUtils::CLI do
  context "create extension" do
    it "should generates an skeleton"
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
