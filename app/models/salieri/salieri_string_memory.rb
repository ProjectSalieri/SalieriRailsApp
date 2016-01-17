class Salieri::SalieriStringMemory < ActiveRecord::Base
  self.table_name = 'salieri_salieri_string_memories'

  scope :where_read_news, -> { where(:key => "ReadNews") }

  def self.mark_read(url)
    find_or_create_by({:key => "ReadNews", :value => url})
  end

  def self.is_already_read(url)
    return self.where_read_news.where(:value => url).blank? == false
  end
end
