class AttributeKind < ActiveRecord::Base
  acts_as_list

  delegate :brand?, :model?, :year?, :fuel_type?,
           :motor?, :weight?, :transmission?, :gender?,
           :wheel_diameter?, :country?, :manufacturer?,
           to: :policy

  has_and_belongs_to_many :categories
  has_many :characteristics
  has_many :items, through: :characteristics

  private

  def policy
    @policy ||= AttributeKindPolicy.new(self)
  end

end

# == Schema Information
#
# Table name: attribute_kinds
#
#  id         :integer          not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  position   :integer
#
