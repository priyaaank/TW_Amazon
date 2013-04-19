require 'spec_helper'

describe "auction_messages/index" do
  before(:each) do
    assign(:auction_messages, [
      stub_model(AuctionMessage,
        :silent_auction_id => 1,
        :message => "MyText",
        :creator => "Creator",
        :message_date => ""
      ),
      stub_model(AuctionMessage,
        :silent_auction_id => 1,
        :message => "MyText",
        :creator => "Creator",
        :message_date => ""
      )
    ])
  end

  it "renders a list of auction_messages" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Creator".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
