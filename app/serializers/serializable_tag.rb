class SerializableTag < JSONAPI::Serializable::Resource
  type 'tags'

  attributes :title

  has_many :tasks do
    meta do
      { count: @object.tasks.count }
    end
  end

end
