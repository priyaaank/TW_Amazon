require 'spec_helper'

describe "auction_messages/edit" do
  before(:each) do
    @auction_message = assign(:auction_message, stub_model(AuctionMessage,
      :silent_auction_id => 1,
      :message => "MyText",
      :creator => "MyString",
      :message_date => ""
    ))
  end

  it "renders the edit auction_message form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", auction_message_path(@auction_message), "post" do
      assert_select "input#auction_message_silent_auction_id[name=?]", "auction_message[silent_auction_id]"
      assert_select "textarea#auction_message_message[name=?]", "auction_message[message]"
      assert_select "input#auction_message_creator[name=?]", "auction_message[creator]"
      assert_select "input#auction_message_message_date[name=?]", "auction_message[message_date]"
    end
  end
end
