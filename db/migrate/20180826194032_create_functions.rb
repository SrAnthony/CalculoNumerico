class CreateFunctions < ActiveRecord::Migration[5.2]
  def change
    create_table :functions do |t|
      t.string :expression
      t.string :point_a
      t.string :point_b

      t.timestamps
    end
  end
end
