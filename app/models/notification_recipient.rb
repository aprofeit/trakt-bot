class NotificationRecipient < ActiveRecord::Base
  PHONE_REGEX = /\+1\d{10}/ # +18195551234

  validates :phone, format: { with: PHONE_REGEX }
end
