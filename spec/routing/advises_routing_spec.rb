require "spec_helper"

describe AdvisesController do
  describe "routing" do

    it "routes to #index" do
      get("/advises").should route_to("advises#index")
    end

    it "routes to #create" do
      post("/advises").should route_to("advises#create")
    end
  end
end
