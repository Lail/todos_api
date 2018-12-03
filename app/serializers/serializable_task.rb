class SerializableTask < JSONAPI::Serializable::Resource
  type 'tasks'

  attributes :title

  has_many :tags do
    meta do
      { count: @object.tags.count }
    end
  end

end
