class AddIndexesToTeamAverages < ActiveRecord::Migration
  def self.up
    add_index :team_averages, :team_id
    add_index :team_foe_averages, :team_id
    add_index :team_averages, [:team_id, :as_of]
    add_index :team_foe_averages, [:team_id, :as_of]
  end

  def self.down
    remove_index :team_averages, [:team_id, :as_of]
    remove_index :team_foe_averages, [:team_id, :as_of]
    remove_index :team_foe_averages, :team_id
    remove_index :team_averages, :team_id
  end
end
