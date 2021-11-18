class CreateVideo < ActiveRecord::Migration[6.1]
  def change
    create_table :videos do |t|
      t.string :video
      t.string :email
      t.string :number

      t.timestamps
    end
  end
end
