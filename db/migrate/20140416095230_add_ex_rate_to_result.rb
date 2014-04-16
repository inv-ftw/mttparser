class AddExRateToResult < ActiveRecord::Migration
  def change
    add_column :results, :ex_rate, :float
  end
end
