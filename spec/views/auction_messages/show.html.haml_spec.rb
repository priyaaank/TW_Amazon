require 'spec_helper'

describe "auction_messages/show" do
  before(:each) do
    @auction_message = assign(:auction_message, stub_model(AuctionMessage,
      :silent_auction_id => 1,
      :message => "MyText",
      :creator => "Creator",
      :message_date => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/MyText/)
    rendered.should match(/Creator/)
    rendered.should match(//)
  end
end
