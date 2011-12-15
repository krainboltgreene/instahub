class Readme

  field :slug
  field :content
  field :md5
  field :build, type: Boolean

  validates :content, presence: true
  validates :md5, presence: true
  validates :slug, presence: true, format: %r{\w+/\w+}, uniqueness: true
end
