class AttributeKind < ActiveRecord::Base
  acts_as_list

  delegate :brand?, :model?, :year?, :fuel_type?,
           :type_of_engine?, :weight?, :transmission?, :gender?,
           :wheel_diameter?, :country?, :country_of_using?, :country_of_manufacture?,
           :car_subcategory?, :type_of_body?, :type_of_complete_set?, :engine_displacement?,
           :number_of_gears?, :bicycle_subcategory?, :frame_material?, :tractor_subcategory?,
           :front_end_loader?, :temperature_control?, :yacht_subcategory?, :material?,
           to: :policy

  has_and_belongs_to_many :categories
  has_many :characteristics
  has_many :items, through: :characteristics

  scope :brand, ->{ where(title: AttributeKindPolicy::BRAND) }

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
