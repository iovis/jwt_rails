class CreateJwtTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :jwt_tokens do |t|
      t.references :user, index: {:unique=>true}, foreign_key: true
      t.string :token

      t.timestamps
    end
    add_index :jwt_tokens, :token
  end
end
