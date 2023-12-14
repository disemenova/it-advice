class AddRole < ActiveRecord::Migration[7.1]
  def change
    change_table :users do |t|
      t.string :role, default: 'user'
    end
  end
end