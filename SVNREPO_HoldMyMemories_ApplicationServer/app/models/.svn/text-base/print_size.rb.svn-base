class PrintSize < ActiveRecord::Base
  validates_presence_of :label, :message => "is required"
  validates_presence_of :width,  :message => "is required"
  validates_presence_of :height, :message => "is required"
  validates_numericality_of :width,  :message => "should be a number"
  validates_numericality_of :height,  :message => "should be a number"
end