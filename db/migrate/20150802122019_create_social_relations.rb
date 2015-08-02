class CreateSocialRelations < ActiveRecord::Migration
  def change
    create_table :social_relations do |t|
      t.integer :user_id
      t.string :name
      t.string :social_id
      t.string :access_token
      t.date :expiration

      t.timestamps null: false
    end
  end
end
