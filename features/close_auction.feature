Feature: close auction

Scenario: close auction
		  Given	an open silent auction
          And there is at least one bid
          When I close the auction
          Then the auction is closed
          And no more bids are allowed

Scenario: admin can close auction
		  Given	I am an admin
		  When I close an auction
		  Then it is closed
