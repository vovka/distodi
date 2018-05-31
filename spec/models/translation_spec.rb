require 'rails_helper'

RSpec.describe Translation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: translations
#
#  id             :integer          not null, primary key
#  locale         :string
#  key            :string
#  value          :text
#  interpolations :text
#  is_proc        :boolean          default("false")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
