require 'active_record'

class Bike < ActiveRecord::Base
  scope :ordered_by_last_message, -> { joins(:post).order('last_message_at DESC') }

  belongs_to :post
  belongs_to :brand
  belongs_to :model
  #delegate post methods to post
  delegate :title,     to: :post
  delegate :thread_id, to: :post
  delegate :name, to: :brand, prefix: true, allow_nil: true
  delegate :name, to: :model, prefix: true, allow_nil: true
  delegate :id, to: :model, prefix: true, allow_nil: true

  #validates :name, presence: true
end
