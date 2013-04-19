require "spec_helper"

describe AuctionMessagesController do
  describe "routing" do

    it "routes to #index" do
      get("/auction_messages").should route_to("auction_messages#index")
    end

    it "routes to #new" do
      get("/auction_messages/new").should route_to("auction_messages#new")
    end

    it "routes to #show" do
      get("/auction_messages/1").should route_to("auction_messages#show", :id => "1")
    end

    it "routes to #edit" do
      get("/auction_messages/1/edit").should route_to("auction_messages#edit", :id => "1")
    end

    it "routes to #create" do
      post("/auction_messages").should route_to("auction_messages#create")
    end

    it "routes to #update" do
      put("/auction_messages/1").should route_to("auction_messages#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/auction_messages/1").should route_to("auction_messages#destroy", :id => "1")
    end

  end
end
