class AddAsOfDateToTeamAverages < ActiveRecord::Migration
  def self.up
    add_column :team_averages, :as_of, :date
  end

  def self.down
    remove_column :team_averages, :as_of
  end
end
