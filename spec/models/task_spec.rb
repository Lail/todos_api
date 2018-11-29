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

    it "creates new Tags from an array of titles" do
      task = Task.create(title: "valid title", tags: ["Won't exist", "Also no"])
      expect(task.tags.count).to eq(2)
      expect(Tag.all.count).to eq(2)
    end

    it "relates existing Tags from an array of titles" do
      tag = Tag.create(title: "Will exist")
      expect(Tag.all.count).to eq(1)
      task = Task.create(title: "valid title", tags: ["Will exist"])
      expect(task.tags.length).to eq(1)
      expect(Tag.all.count).to eq(1)
    end

    it "relates both new and existing Tags from an array of titles" do
      tag = Tag.create(title: "Will exist")
      expect(Tag.all.count).to eq(1)
      task = Task.create(title: "valid title", tags: ["Will exist", "Won't exist"])
      expect(task.tags.length).to eq(2)
      expect(Tag.all.count).to eq(2)
    end
  end

  context "when updated" do
    context "when updating tags" do
      it "removes old associations but doesn't destroy tag" do
        og_tag = Tag.create(title: "Will remove")
        task = Task.create(title: "valid title", tags: [og_tag])
        expect(task.tags.first).to be(og_tag)
        task.update_attributes({tags: ["New tag"]})
        expect(task.tags.first.title).to eq("New tag")
        expect(task.tags.count).to eq(1)
        expect(Tag.find_by(id: og_tag.to_param).present?).to be true
      end

      it "removes all tags when passed an empty []" do
        og_tag = Tag.create(title: "Will remove")
        task = Task.create(title: "valid title", tags: [og_tag])
        expect(task.tags.first).to be(og_tag)
        task.update_attributes({tags: []})
        expect(task.tags.count).to eq(0)
      end

      it "does not remove tags if no tag value is passed" do
        og_tag = Tag.create(title: "Will remove")
        task = Task.create(title: "valid title", tags: [og_tag])
        expect(task.tags.first).to be(og_tag)
        task.update_attributes({title: "Just changing the title"})
        expect(task.tags.first).to be(og_tag)
      end
    end
  end

end
