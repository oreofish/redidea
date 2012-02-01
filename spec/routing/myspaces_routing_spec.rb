require "spec_helper"

describe MyspacesController do
  describe "routing" do

    it "routes to #index" do
      get("/myspaces").should route_to("myspaces#index")
    end

    it "routes to #new" do
      get("/myspaces/new").should route_to("myspaces#new")
    end

    it "routes to #show" do
      get("/myspaces/1").should route_to("myspaces#show", :id => "1")
    end

    it "routes to #edit" do
      get("/myspaces/1/edit").should route_to("myspaces#edit", :id => "1")
    end

    it "routes to #create" do
      post("/myspaces").should route_to("myspaces#create")
    end

    it "routes to #update" do
      put("/myspaces/1").should route_to("myspaces#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/myspaces/1").should route_to("myspaces#destroy", :id => "1")
    end

  end
end
