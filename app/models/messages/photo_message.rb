# == Schema Information
#
# Table name: photo_messages
#
#  id            :integer         not null, primary key
#  thread_id     :integer         not null
#  message_id    :integer         not null
#  created_by_id :integer         not null
#  photo_uid     :string(255)     not null
#  caption       :string(255)
#  description   :text
#  created_at    :datetime        not null
#

class PhotoMessage < MessageComponent
  # Core associations defined in MessageComponent

  image_accessor :photo do
    storage_path :generate_photo_path
  end

  validates :photo, presence: true

  def photo_preview
    photo.thumb("200x200>")
  end

  def photo_thumbnail
    photo.thumb("50x50>")
  end

  protected

  def generate_photo_path
    hash = Digest::SHA1.file(photo.path).hexdigest
    "message_photos/#{hash[0..2]}/#{hash[3..5]}/#{hash}"
  end
end