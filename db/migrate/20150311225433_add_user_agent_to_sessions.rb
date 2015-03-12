class AddUserAgentToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :user_agent, :string
    add_column :sessions, :location, :string
  end
end
