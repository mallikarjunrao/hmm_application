class PrintSizePrice < ActiveRecord::Base
  validates_presence_of :print_size_id,  :message => "is required"
  validates_presence_of :price,  :message => "is required"
  validates_numericality_of :price, :message => "should be a number"
  validates_presence_of :quantity, :message => "is required"
  validates_presence_of :aspect_ratio, :message => "is required"
  validates_numericality_of :quantity,  :message => "should be a number"

  def validate
  if self.pricelt72 < 1
    self.errors.add_to_base("Price within 72 hours must be greater than 0.")
  end
end
end
