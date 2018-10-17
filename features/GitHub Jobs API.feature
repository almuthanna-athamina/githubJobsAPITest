Feature: GitHub Jobs API


  Scenario: Retrieve all available positions
    Given that I have the host "http://jobs.github.com"
    When I send the API call GET "/positions.json"
    Then the response code should be 200
    And response array to include more than one item
