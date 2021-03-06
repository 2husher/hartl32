# == Schema Information
#
# Table name: microposts
#
#  id         :integer          not null, primary key
#  content    :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_microposts_on_user_id_and_created_at  (user_id,created_at)
#

class Micropost < ActiveRecord::Base
  belongs_to :user

  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true

  default_scope { order('microposts.created_at DESC') }
end
