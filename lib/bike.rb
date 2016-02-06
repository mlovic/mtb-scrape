require 'active_record'

class Bike < ActiveRecord::Base
  scope :ordered_by_last_message,  -> { joins(:post).order('last_message_at DESC') }
  scope :ordered_by_last_posted,   -> { joins(:post).order('posted_at DESC') }

  scope :min_travel, ->(val) { where 'models.travel >= ?', val }
  scope :max_travel, ->(val) { where 'models.travel <= ?', val }
  scope :min_price,  ->(val) { where 'price >= ?', val }
  scope :max_price,  ->(val) { where 'price <= ?', val }
  scope :size,       ->(val) { where size: val }
  scope :brand_id,   ->(val) { where brand_id: val }
  scope :model_id,   ->(val) { where model_id: val }

  # TODO use price and travel ranges? could use slider

  # CV - whole commit
  def self.filter(attrs)
    # TODO strings or syms?
    supported_filters = [:min_travel, :max_travel, :min_price, :max_price, 
                         :size, :brand_id, :model_id].map(&:to_s)
    attrs.slice(*supported_filters).reduce(all.joins(:model)) do |scope, (key, value)|
      value.present? ? scope.send(key, value) : scope
    end  
    # TODO is above 'all' making query?
  end

  def self.order_by(order)
    # TODO fix map to_s
    supported_orders = [:last_message, :last_posted].map(&:to_s)
    return ordered_by_last_message unless supported_orders.include? order 
    send("ordered_by_#{order}")
  end

  #scope :ordered_by_last_message, -> { joins(:post).order('last_message_at DESC') }
  #scope :

  belongs_to :post
  belongs_to :brand
  belongs_to :model
  #delegate post methods to post
  delegate :title,     to: :post
  delegate :thread_id, to: :post
  delegate :name, to: :brand, prefix: true, allow_nil: true
  delegate :name, to: :model, prefix: true, allow_nil: true
  delegate :id, to: :model, prefix: true, allow_nil: true
  delegate :time_since_last_message, to: :post, allow_nil: true
  delegate :time_since_posted, to: :post, allow_nil: true

  def generated_attributes
    attributes.slice %i(name brand_id price frame_only size model_id is_sold)
  end

  def sold?
    is_sold
  end

  #validates :name, presence: true
end
