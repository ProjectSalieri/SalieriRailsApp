class Admin::StringTable < ActiveRecord::Base
  self.table_name = 'admin_string_tables'

  def self.key_file ; return "CreateFile" ; end
end
