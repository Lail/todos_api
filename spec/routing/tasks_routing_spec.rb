require "rails_helper"

RSpec.describe Api::V1::TasksController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/api/v1/tasks").to route_to("api/v1/tasks#index")
    end

    it "routes to #create" do
      expect(:post => "/api/v1/tasks").to route_to("api/v1/tasks#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/api/v1/tasks/1").to route_to("api/v1/tasks#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/api/v1/tasks/1").to route_to("api/v1/tasks#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/api/v1/tasks/1").to route_to("api/v1/tasks#destroy", :id => "1")
    end
  end
end
