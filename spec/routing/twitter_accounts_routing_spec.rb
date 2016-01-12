require "spec_helper"

describe TwitterAccountsController do
  describe "routing" do

    it "routes to #index" do
      get("/twitter_accounts").should route_to("twitter_accounts#index")
    end

    it "routes to #new" do
      get("/twitter_accounts/new").should route_to("twitter_accounts#new")
    end

    it "routes to #show" do
      get("/twitter_accounts/1").should route_to("twitter_accounts#show", :id => "1")
    end

    it "routes to #edit" do
      get("/twitter_accounts/1/edit").should route_to("twitter_accounts#edit", :id => "1")
    end

    it "routes to #create" do
      post("/twitter_accounts").should route_to("twitter_accounts#create")
    end

    it "routes to #update" do
      put("/twitter_accounts/1").should route_to("twitter_accounts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/twitter_accounts/1").should route_to("twitter_accounts#destroy", :id => "1")
    end

  end
end
