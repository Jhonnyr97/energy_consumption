class CreateConsumptions < ActiveRecord::Migration[8.0]
  def change
    create_table :consumptions do |t|
      t.integer :energy_type
      t.decimal :value, null: false
      t.string :unit
      t.date :measured_at
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
