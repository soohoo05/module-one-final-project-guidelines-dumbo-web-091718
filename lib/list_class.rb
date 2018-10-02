class List < ActiveRecord::Base
  belongs_to :user
  has_many :movies_on_list
end
