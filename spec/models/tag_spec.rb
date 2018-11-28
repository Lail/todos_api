require 'rails_helper'

RSpec.describe Tag, type: :model do

  context "when created" do
    it "is valid with a long title" do
      tag = Tag.new(title: "This is a valid title")
      expect(tag).to be_valid
    end

    it "is invalid with an empty title" do
      tag = Tag.new(title: "")
      expect(tag).to be_invalid
    end

    it "is invalid with no title present" do
      tag = Tag.new
      expect(tag).to be_invalid
    end
  end

end
