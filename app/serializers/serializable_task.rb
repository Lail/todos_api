class SerializableTask < JSONAPI::Serializable::Resource
  type 'tasks'

  attributes :title

  has_many :tags

end
