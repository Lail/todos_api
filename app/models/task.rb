class Task < ApplicationRecord

  # no need for has_many :through at this point
  has_and_belongs_to_many :tags, autosave: true

  validates :title, presence: true, length: { minimum: 1 }

  def tags= arg_array
    # can optionaly pass an array of strings
    if arg_array[0].is_a? String
      combined_tags = []
      exiting_tags = Tag.where('title IN (?)', arg_array)
      arg_array.each do |title|
        if existing_tag = exiting_tags.detect {|t| t.title == title }
          combined_tags << existing_tag
        else
          combined_tags << Tag.new(title: title)
        end
      end
      self.tags.delete_all # removes Tags without destroying
      self.tags << combined_tags
    else
      self.tags.delete_all # removes Tags without destroying
      self.tags << arg_array
    end

  end

end
