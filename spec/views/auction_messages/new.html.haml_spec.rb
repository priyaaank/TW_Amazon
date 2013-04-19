require 'spec_helper'

describe "auction_messages/new" do
  before(:each) do
    assign(:auction_message, stub_model(AuctionMessage,
      :silent_auction_id => 1,
      :message => "MyText",
      :creator => "MyString",
      :message_date => ""
    ).as_new_record)
  end

  it "renders new auction_message form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
      assert_select "form[action=?][method=?]", new_silent_auction_auction_message_path, "post" do
      assert_select "input#auction_message_silent_auction_id[name=?]", "auction_message[silent_auction_id]"
      assert_select "textarea#auction_message_message[name=?]", "auction_message[message]"
      assert_select "input#auction_message_creator[name=?]", "auction_message[creator]"
      assert_select "input#auction_message_message_date[name=?]", "auction_message[message_date]"
    end
  end
end
