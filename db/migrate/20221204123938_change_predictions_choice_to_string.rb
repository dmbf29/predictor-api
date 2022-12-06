class ChangePredictionsChoiceToString < ActiveRecord::Migration[6.1]
  def up
    rename_column :predictions, :choice, :choice_integer
    add_column :predictions, :choice, :string

    say_with_time "Converting integer enum to string" do
      predictions = Prediction.where.not(choice_integer: nil)
      bar = ProgressBar.new(predictions.count)
      predictions.find_each do |prediction|
        prediction.update_columns(choice: %w[home away draw][prediction.choice_integer])
        bar.increment!
      end
    end

    remove_column :predictions, :choice_integer
  end

  def down
    rename_column :predictions, :choice, :choice_string
    add_column :predictions, :choice, :integer

    say_with_time "Converting string enum to integer" do
      predictions = Prediction.where.not(choice_string: nil)
      bar = ProgressBar.new(predictions.count)
      predictions.find_each do |prediction|
        prediction.update_columns(choice: %w[home away draw].index(prediction.choice_string))
        bar.increment!
      end
    end

    remove_column :predictions, :choice_string
  end
end
