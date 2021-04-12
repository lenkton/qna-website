class Subscribing < ApplicationRecord
  belongs_to :subscriber, class_name: 'User'
  belongs_to :subscription, class_name: 'Question'
end
