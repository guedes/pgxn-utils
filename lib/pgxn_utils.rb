require 'thor'
require 'json'
require 'zip/zip'
require 'zippy'
require 'net/http/post/multipart'
require 'net/https'
require 'highline/import'

module PgxnUtils
 autoload :CLI, 'pgxn_utils/cli'
 autoload :VERSION, 'pgxn_utils/version'
 autoload :Constants, 'pgxn_utils/constants'
 autoload :NoTasks, 'pgxn_utils/no_tasks'
end
