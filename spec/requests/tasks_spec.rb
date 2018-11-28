require 'rails_helper'

RSpec.describe "Tasks API", type: :request do

  let(:valid_attributes) {
    { title: "I'm a valid title" }
  }

  let(:invalid_attributes) {
    { title: "" } # too short :(
  }

  describe "#index GET /api/v1/tasks" do
    it "returns a success response" do
      get api_v1_tasks_path
      expect(response).to have_http_status(200)
    end

    it "returns a list of tasks" do
      task = Task.create! valid_attributes
      get api_v1_tasks_path
      tasks = JSON(response.body)['data']
      expect(tasks.size).to eq(1)
      tasks.each do |task|
        expect(task.keys.size).to eq(3)
        expect(task.has_key?('id')).to be(true)
        expect(task.has_key?('attributes')).to be(true)
        expect(task['type']).to eq('tasks')
      end
      expect(tasks.first['attributes']['title']).to eq(valid_attributes[:title])
    end
  end

  describe "#create POST /api/v1/tasks" do
    context "with valid params" do
      it "creates a new Task" do
        expect {
          post api_v1_tasks_path, params: {data: {attributes: valid_attributes }}
        }.to change(Task, :count).by(1)
      end

      it "renders a JSON response with the new task" do
        post api_v1_tasks_path, params: {data: {attributes: valid_attributes }}
        expect(response).to have_http_status(201) #created
        expect(response.content_type).to eq('application/json')
        expect(JSON(response.body)['data']['attributes']['title']).to eq(valid_attributes[:title])
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new task" do
        post api_v1_tasks_path, params: {data: {attributes: invalid_attributes }}
        expect(response).to have_http_status(422) #unprocessable_entity
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe "#update PUT /api/v1/tasks/:id" do
    context "with valid params" do
      let(:new_attributes) {
        { title: "Updated title" }
      }

      it "renders a JSON response with the updated task" do
        task = Task.create! valid_attributes
        put api_v1_task_path(task), params: {data: {attributes: new_attributes }}
        expect(response).to have_http_status(200) #ok
        expect(response.content_type).to eq('application/json')
        expect(JSON(response.body)['data']['attributes']['title']).to eq(new_attributes[:title])
      end

      it "updates the requested task" do
        task = Task.create! valid_attributes
        put api_v1_task_path(task), params: {data: {attributes: new_attributes }}
        task.reload
        expect(task.title).to eq(new_attributes[:title])
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the task" do
        task = Task.create! valid_attributes
        put api_v1_task_path(task), params: {data: {attributes: invalid_attributes }}
        expect(response).to have_http_status(422) #unprocessable_entity
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe "#destroy DELETE /api/v1/tasks/:id" do
    it "destroys the requested task" do
      task = Task.create! valid_attributes
      expect {
        delete api_v1_task_path(task), params: {id: task.to_param}
      }.to change(Task, :count).by(-1)
    end

    it "responds with no_content status" do
      task = Task.create! valid_attributes
      delete api_v1_task_path(task), params: {id: task.to_param}
      expect(response).to have_http_status(204) #no_content
      expect(response.content_type).to eq('application/json')
    end
  end

end
