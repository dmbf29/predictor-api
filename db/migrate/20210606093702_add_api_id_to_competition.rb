class AddApiIdToCompetition < ActiveRecord::Migration[6.1]
  def change
    add_column :competitions, :api_id, :integer
    Competition.find_each do |competition|
      next if competition.api_id

      # Live-Score API ID for the the Euros
      competition.api_id = 387
      competition.save
    end
  end
end
