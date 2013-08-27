require 'fluent/plugin'
require 'fluent/config'
require 'fluent/input'
require 'active_record'
require 'fluent/mixin/config_placeholders'
require 'fluent/mixin/plaintextformatter'

module Fluent


class TermtterInput < Input
  Plugin.register_input('termtter-db', self)

  config_param :db_path, :string, :default => 'sqlite3.db'
  config_param :tag, :string, :default => 'twitter.statuses'
  config_param :load_protected, :bool, :default => false

  include Fluent::Mixin::ConfigPlaceholders
  include Fluent::Mixin::PlainTextFormatter

  def initialize
    super
  end

  def configure(conf)
    super
  end

  def start
    statuses = Termtter::Storage.new(@db_path).get
    statuses.each {|status|

      Engine.emit(@tag,
        Engine.now, {
          "uid"                     => status.uid,
          "screen_name"             => status.screen_name,
          "text"                    => status.text.force_encoding("utf-8"),
          "created_at"              => status.created_at,
          "protected"               => status.protected,
          "in_reply_to_status_id"   => status.in_reply_to_status_id,
          "in_reply_to_user_id"     => status.in_reply_to_user_id,
          "in_reply_to_screen_name" => status.in_reply_to_user_id,
          "statuses_count"          => status.statuses_count,
          "friends_count"           => status.friends_count,
          "followers_count"         => status.followers_count,
          "source"                  => status.source.force_encoding("utf-8"),
        }
      ) if status.protected == false or @load_protected == true

    }
  end
end


module Termtter


class Status < ActiveRecord::Base
end

class Storage
  def initialize(db_path)
    @db_path = db_path
  end

  def get
    prepare_database
    model_class.all
  end

  def drop
    prepare_database
    drop_table
  end

  private
  def prepare_database
    db = File.join(File.expand_path(@db_path))
    ActiveRecord::Base.establish_connection(
      :adapter  => "sqlite3",
      :database => db
    )
    create_table unless model_class.table_exists?
  end

  def model_class
    Status
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


end


end
