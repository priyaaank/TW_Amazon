Feature: find out who wins

Scenario: see winning bid
          given an open auction
          Then I cannot see the winning bid

          Given	a closed auction
		  Then I can see the winning bid
          Given	the following bids
 	      | Bids |
	      | 1 |
	      | 100 |
	      | 50 |
          When I see the winning bid
          Then it is 100
