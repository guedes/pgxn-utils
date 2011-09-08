require File.expand_path('spec/spec_helper')

describe PgxnUtils::NoTasks do
  include PgxnUtils::NoTasks
  include FileUtils

  after(:all) do
    rm_r("/tmp/teste")
    rm_r("/tmp/teste2")
  end

  context "#resolve_extension_path_and_name" do
    it "should raise error when no extension name was supplied" do
      PgxnUtils::NoTasks.send(:define_method, :options) do
        { :target => "/something" }
      end
      extension_name = "."
      lambda {resolve_extension_path_and_name(extension_name)}.should raise_error(ArgumentError)
    end

    it "should return correctly if target is '.'" do
      PgxnUtils::NoTasks.send(:define_method, :options) do
        { :target => "." }
      end

      original_dir = File.expand_path(".")
      destination_dir = "/tmp/teste"
      mkdir destination_dir
      cd destination_dir

      extension_name = "teste"
      resolved_path, resolved_name = resolve_extension_path_and_name(extension_name)

      cd original_dir

      resolved_path.should == "#{destination_dir}/#{extension_name}"
      resolved_name.should == extension_name
    end

    it "should return correctly when target are not '.' and a extension name was specified" do
      PgxnUtils::NoTasks.send(:define_method, :options) do
        { :target => "/tmp" }
      end

      original_dir = File.expand_path(".")
      destination_dir = "/tmp/teste2"
      mkdir destination_dir
      cd destination_dir

      extension_name = "teste2"
      resolved_path, resolved_name = resolve_extension_path_and_name(extension_name)

      cd original_dir

      resolved_path.should == destination_dir
      resolved_name.should == extension_name
    end
  end
end
