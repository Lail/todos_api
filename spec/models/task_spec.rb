require 'rails_helper'

RSpec.describe Task, type: :model do

  context "when created" do
    it "is valid with a long title" do
      task = Task.new(title: "This is a valid title")
      expect(task).to be_valid
    end

    it "is invalid with an empty title" do
      task = Task.new(title: "")
      expect(task).to be_invalid
    end

    it "is invalid with no title present" do
      task = Task.new
      expect(task).to be_invalid
    end
  end

end
