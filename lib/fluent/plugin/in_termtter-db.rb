require 'fluent/plugin'
require 'fluent/config'
require 'fluent/input'
require 'active_record'

class TermtterInput < Fluent::Input
  Fluent::Plugin.register_input('termtter-db', self)

  def start
    statuses = Storage.new.get
    statuses.each {|status|
      Fluent::Engine.emit("termtter.status",
        Fluent::Engine.now, {
          "uid"                     => status.uid,
          "screen_name"             => status.screen_name,
          "text"                    => status.text,
          "created_at"              => status.created_at,
          "protected"               => status.protected,
          "in_reply_to_status_id"   => status.in_reply_to_status_id,
          "in_reply_to_user_id"     => status.in_reply_to_user_id,
          "in_reply_to_screen_name" => status.in_reply_to_user_id,
          "statuses_count"          => status.statuses_count,
          "friends_count"           => status.friends_count,
          "followers_count"         => status.followers_count,
          "source"                  => status.source,
        }
      )
    }
  end
end

class Status < ActiveRecord::Base
end

class Storage
  def get
    prepare_database
    model_class
     .where('created_at >= ?', '2013-06-01').limit(100)
  end

  def drop
    prepare_database
    drop_table
  end

  private
  def prepare_database
    db = File.join(db_dir, 'sqlite3.db')
    ActiveRecord::Base.establish_connection(
      :adapter  => "sqlite3",
      :database => db
    )
    create_table unless model_class.table_exists?
  end

  def model_class
    Status
  end

  def db_dir
    File.join(File.dirname(__FILE__), '..', '..', '..', 'db')
  end

  def column_definition
    {
      :uid => :integer,
      :screen_name => :string,
      :text => :string,
      :created_at => :datetime,
      :protected => :boolean,
      :in_reply_to_status_id => :integer,
      :in_reply_to_user_id => :integer,
      :in_reply_to_screen_name => :string,
      :statuses_count => :integer,
      :friends_count => :integer,
      :followers_count => :integer,
      :source => :string,
    }
  end

  def unique_key
    :id
  end

  def create_table
    ActiveRecord::Migration.create_table(model_class.table_name){|t|
      column_definition.each_pair {|column_name, column_type|
        t.column column_name, column_type
      }
    }
  end

  def drop_table
    ActiveRecord::Migration.drop_table(model_class.table_name)
  end
end
