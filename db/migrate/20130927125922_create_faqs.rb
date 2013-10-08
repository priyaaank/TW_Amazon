class CreateFaqs < ActiveRecord::Migration
  class Faq < ActiveRecord::Base
    attr_accessible :question, :answer
  end

  def up
    create_table :faqs do |t|
      t.string :question
      t.string :answer
      t.timestamps
    end

    Faq.create question: 'How do I change my email notification options?',
      answer: 'At the top-right corner of the page, inside the Login/Logout menu, there is "Email Notification Setting" that will give you multiple options. However, you will still get an email as a reminder when you put an item on sale and the sale period of the item is about to end. '

    Faq.create question:  'What kinds of selling options are available?',
      answer: 'On Garage Sale, you can sell your items as a silent auction, a normal auction or a quick sale. In an auction, other ThoughtWorkers will be able to place bids, which cannot be less than your specified minimum price for the item. While a quick sale can be used as a board to advertise your item (your email address will be written together with the details of your item or you may also put other contact details under the description of the item) so that any interested buyers can contact you directly.'

    Faq.create question:  'How do I make a payment for an item I have bought or get paid for an item I have sold?',
    answer: 'It is up to the seller and buyer to arrange the payment and transfer of the item. It is also a good idea to contact the seller first and talk about the payment options before making any decision. As the seller put up some information about how payment and delivery options you prefer either within the item description or as a Message in the item details.<br/>
    In particular for TW laptops, the payment is usually made by a deduction from your salary.'

Faq.create question:  'What is the duration of an auction/sale?',
  answer: <<-eos
* Every auction/sale starts on will start on the day specified as the start date.<br/>
* You can also set an auction/sale to start sometime in the future. In this case, the starting time will be around 00:00 o'clock on the specified starting date, according to the timezone associated with the region of the auction/sale.<br/>
* The ending time will be at 23:59 o'clock on the specified ending date, according to the timezone associated with the region of the auction/sale.<br/>
* This timezone is according to the regional time of a major city in your country, for example: the regional time of Melbourne is used for Australia, and the regional time of New Delhi is used for India.<br/>
eos


Faq.create question:  'Does the system cover additional regions?',
  answer: 'There may be more regions added to the system and you will be able to see items in other regions by changing the selected region associated with your account (by clicking the flag icon at the top part of the webpage).<br/>
However, please be aware that if you join in an auction in regions other than yours, you will need to face and handle the complexity of making a payment in a different currency, as well as the shipping of the item across regions.'

Faq.create question:  'How many times can I place a bid on a auction of an item?',
  answer: "On a silent auction, you can only place a bid once. If you want, you may withdraw the bid you have placed, but you won't be able to place another bid on the same item.<br/>
On a normal auction, you can place a bid and withdraw it multiple times."

Faq.create question:  'Can I withdraw my bid from a auction of an item?',
  answer: "On a silent auction, if you want, you may withdraw the bid you have placed, but you won't be able to place another bid on the same item.<br/>
On a normal auction, you can place a bid and withdraw it multiple times."

Faq.create question:  'How can I see the bids that I have placed on an auction?',
  answer: 'At the top-right corner of the page, inside the Login/Logout menu, there is "My Bid" link that will display all bids you have made.'

Faq.create question:  'How do I find out if I have won an auction?',
  answer: 'If your email notification setting is turned on, Garage Sale will send a notification email to your ThoughtWorks email account, otherwise you can simply check the website and go to the "Closed Auction" page that will list all the auctions that have ended together with the winner for each item.'

Faq.create question:  'How can I delete the auction of my item?',
  answer: 'At the top-right corner of the page, inside the Login/Logout menu, there is "My Auctions" or "My Sales" that will display the list of items you have posted onto the system. At the farthest right hand side of the details for each item you will see a button with a cross symbol ("X") or a menu button titled "Manage" that will allow you to delete an item. However you wont be able to remove the auction if it has one or more bids placed on it.'

Faq.create question:  'How can I close the auction I have created before the ending date?',
  answer: 'At the top-right corner of the page, inside the Login/Logout menu, there is "My Auctions" that will display the list of items you have put on auctions. At the farthest right hand side of the details for each item you will see a menu button titled "Manage" that will allow you to close an action sooner. However, this can only be done under one condition, the item must have atleast one bid on it for you to be able to close it early.'

Faq.create question:  'How can I change the details of an auction or a sale I have created?',
  answer: 'At the top-right corner of the page, inside the Login/Logout menu, there is "My Auctions" or "My Sales" that will display the list of items you have posted onto the system. At the farthest right hand side of the details for each item you will see a menu button titled "Manage" that will allow you to edit the details of an item. However, particularly for an auction, you wont be able to edit the details of an item that has one or more bids placed on it. But you can still inform people about changes to your items in the auction messages.'

Faq.create question:  'What happens to the auction that I want to start sometime in the future?',
  answer: 'If you specify the start date of an auction or sale of an item to be at sometime in the future, then other ThoughtWorkers will not be able to see your item on Garage Sale until the starting date specified for the auction or sale of that item.'

  end

  def down
    drop_table :faqs
  end
end
