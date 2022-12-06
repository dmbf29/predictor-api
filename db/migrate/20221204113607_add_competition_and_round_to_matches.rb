class AddCompetitionAndRoundToMatches < ActiveRecord::Migration[6.1]
  def up
    add_reference :matches, :competition, foreign_key: true

    Match.reset_column_information
    Match.find_each do |match|
      match.update_columns(round_id: match.group.round.id) if match.round.blank?
      match.update_columns(competition_id: match.round.competition.id) if match.competition.blank?
    end

    change_column_null :matches, :competition_id, false
    change_column_null :matches, :round_id, false
  end

  def down
    remove_reference :matches, :competition, foreign_key: true
    change_column_null :matches, :round_id, true
    Match.where.not(group: nil).find_each do |match|
      match.update_columns(round_id: nil)
    end
  end
end
