class CreateNotificationRecipients < ActiveRecord::Migration
  def change
    create_table :notification_recipients do |t|
      t.string :phone

      t.timestamps
    end
  end
end
