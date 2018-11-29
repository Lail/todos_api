require 'rails_helper'

RSpec.describe "Tasks API", type: :request do

  let(:title) { "I'm a valid title" }
  let(:tag) { "ValidTag" }

  let(:valid_attributes) {
    {
      title: title,
      tags: [tag]
    }
  }

  let(:invalid_attributes) {
    { title: "" } # too short :(
  }

  describe "#index GET /api/v1/tasks" do

    before do
      task = Task.create! valid_attributes
      get api_v1_tasks_path
    end

    it "returns a success response" do
      expect(response.content_type).to eq('application/json')
      expect(response).to have_http_status(200)
    end

    it "returns list of existing Tasks" do
      expect(response.body).to have_json_size(1).at_path('data')
      expect(response.body).to include_json(title.to_json).at_path('data/0/attributes/title')
    end

    it "returns related tags" do
      tag_id = Tag.find_by(title: tag).to_param
      expect(response.body).to include_json(tag_id.to_json).at_path('data/0/relationships/tags/data/0/id')
    end

    context "respond with a defined JSON Format" do
      subject { response.body }

      it "includes 'data' Array" do
        is_expected.to have_json_path('data')
        is_expected.to have_json_type(Array).at_path('data')
      end

      it "includes 'data' Array of Hashes" do
        is_expected.to have_json_path('data/0')
        is_expected.to have_json_type(Hash).at_path('data/0')
      end

      it "includes 'id' in Hashes" do
        is_expected.to have_json_path('data/0/id')
        is_expected.to have_json_type(String).at_path('data/0/id')
      end

      it "includes 'type' in Hashes" do
        is_expected.to have_json_path('data/0/type')
        is_expected.to have_json_type(String).at_path('data/0/type')
        is_expected.to include_json("tasks".to_json).at_path('data/0/type')
      end

      it "includes 'attributes' in Hashes" do
        is_expected.to have_json_path('data/0/type')
        is_expected.to have_json_type(Hash).at_path('data/0/attributes')
      end

      it "includes 'title' in attributes" do
        is_expected.to have_json_path('data/0/attributes/title')
        is_expected.to have_json_type(String).at_path('data/0/attributes/title')
      end
    end

  end

  describe "#create POST /api/v1/tasks" do
    context "with valid params" do
      it "creates a new Task" do
        expect {
          post api_v1_tasks_path, params: {data: {attributes: valid_attributes}}
        }.to change(Task, :count).by(1)
      end

      it "creates a new related Tag" do
        expect {
          post api_v1_tasks_path, params: {data: {attributes: valid_attributes}}
        }.to change(Tag, :count).by(1)
      end

      it "renders a JSON response with the new task and tag" do
        post api_v1_tasks_path, params: {data: {attributes: valid_attributes}}
        expect(response).to have_http_status(201) #created
        expect(response.content_type).to eq('application/json')
        expect(response.body).to include_json(title.to_json).at_path('data/attributes/title')
        expect(response.body).to include_json("tags".to_json).at_path('data/relationships/tags/data/0/type')
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new task" do
        post api_v1_tasks_path, params: {data: {attributes: invalid_attributes}}
        expect(response).to have_http_status(422) #unprocessable_entity
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe "#update PUT /api/v1/tasks/:id" do
    context "with valid params" do
      let(:new_title) { "Updated title" }
      let(:new_tag) { "New Tag" }

      let(:new_attributes) {
        {
          title: new_title,
          tags: [new_tag]
        }
      }

      it "renders a JSON response with the updated task and tags" do
        task = Task.create! valid_attributes
        put api_v1_task_path(task), params: {data: {attributes: new_attributes}}
        new_tag_id = Tag.find_by(title: new_tag).id.to_s
        expect(response).to have_http_status(200) #ok
        expect(response.content_type).to eq('application/json')
        expect(response.body).to include_json(new_title.to_json).at_path('data/attributes/title')
        expect(response.body).to include_json(new_tag_id.to_json).at_path('data/relationships/tags/data/0/id')
      end

      it "updates the requested Task and tags" do
        task = Task.create! valid_attributes
        put api_v1_task_path(task), params: {data: {attributes: new_attributes}}
        task.reload
        expect(task.title).to eq(new_title)
        expect(task.tags.first.title).to eq(new_tag)
        expect(response.body).to include_json("tags".to_json).at_path('data/relationships/tags/data/0/type')
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the task" do
        task = Task.create! valid_attributes
        put api_v1_task_path(task), params: {data: {attributes: invalid_attributes}}
        expect(response).to have_http_status(422) #unprocessable_entity
        expect(response.content_type).to eq('application/json')
      end

      it "does not update the requested Task" do
        task = Task.create! valid_attributes
        put api_v1_task_path(task), params: {data: {attributes: invalid_attributes}}
        task.reload
        expect(task.title).not_to eq(invalid_attributes['title'])
        expect(task.title).to eq(title)
      end
    end
  end

  describe "#destroy DELETE /api/v1/tasks/:id" do
    it "destroys the requested task" do
      task = Task.create! valid_attributes
      expect {
        delete api_v1_task_path(task)
      }.to change(Task, :count).by(-1)
    end

    it "responds with no_content status" do
      task = Task.create! valid_attributes
      delete api_v1_task_path(task)
      expect(response).to have_http_status(204) #no_content
    end

    it "does not delete Tags when it deletes parent" do
      task = Task.create! valid_attributes
      expect(Tag.all.count).to eq(1)
      delete api_v1_task_path(task)
      expect(Tag.all.count).to eq(1)
    end
  end

end
