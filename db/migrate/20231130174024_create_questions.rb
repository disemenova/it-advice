class CreateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.integer :number
      t.string :name
      t.references :quiz, null: false, foreign_key: true

      t.timestamps
    end
  end
end
