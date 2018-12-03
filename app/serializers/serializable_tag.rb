class SerializableTag < JSONAPI::Serializable::Resource
  type 'tags'

  attributes :title

  has_many :tasks

end
