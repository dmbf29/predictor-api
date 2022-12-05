class AddCompetitionAndRoundToMatches < ActiveRecord::Migration[6.1]
  def up
    add_reference :matches, :competition, foreign_key: true

    Match.reset_column_information
    Match.find_each do |match|
      match.round ||= match.group&.round
      match.competition ||= match.round&.competition
      match.save!(validate: false)
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
