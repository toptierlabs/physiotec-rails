class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :message_id
      t.string :topic_arn
      t.string :subject
      t.text :message
      t.text :extra

      t.timestamps
    end
  end
end
