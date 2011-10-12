$:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)

require 'rspec'
require 'simplecov'
SimpleCov.start
require 'pgxn_utils'

$counter = 0

LIB_PATH = File.expand_path('../../lib', __FILE__)
BIN_PATH = File.expand_path('../../bin/pgxn-utils', __FILE__)

DESTINATION_ROOT = File.expand_path('../pgxn_utils', __FILE__)
FileUtils.rm_rf(DESTINATION_ROOT)

RSpec.configure do |config|
  # capture method from https://github.com/wycats/thor/blob/master/spec/spec_helper.rb#L36-47
  def capture(stream)
    begin
      stream = stream.to_s
      eval "$#{stream} = StringIO.new"
      yield
      result = eval("$#{stream}").string
    ensure
      eval("$#{stream} = #{stream.upcase}")
    end

    result
  end
end


def next_extension
  $counter += 1
  "extension.#{$counter}"
end

def skeleton(extension_name, args=[])
	capture(:stdout) { PgxnUtils::CLI.start([ "skeleton", extension_name ] + args) }
end

def change(extension_name, args=nil)
  #run_pgxn_utils(:skeleton, "#{extension_name} #{args}")
end

def run_pgxn_utils(task, args)
  #system "#{BIN_PATH} #{task.to_s} #{args}"
end
