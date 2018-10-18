@functional_test
Feature: GitHub Jobs API

  Background:
    Given that I have the host "http://jobs.github.com"

  @smoke_test
  Scenario: Retrieve all available positions in HTML format
    When I send the API call GET "/positions"
    Then the response code should be 200

  @smoke_test
  Scenario: Retrieve all available positions in JSON format with the correct value names in each element
    When I send the API call GET "/positions.json"
    Then the response code should be 200
    And response array to include more than one item
    And each element should have the key "id"
    And each element should have the key "created_at"
    And each element should have the key "title"
    And each element should have the key "location"
    And each element should have the key "type"
    And each element should have the key "description"
    And each element should have the key "how_to_apply"
    And each element should have the key "company"
    And each element should have the key "company_url"
    And each element should have the key "company_logo"
    And each element should have the key "url"

  @smoke_test
  Scenario: Check API support for JSONP
    When I send the API call GET "/positions.json?callback=myFunction"
    Then the response code should be 200
    And response should start with "myFunction"

  Scenario Outline: Retrieve available positions in JSON format with a valid filter that returns results
    When I send the API call GET "/positions.json?<filter>"
    Then the response code should be 200
    And response array to include more than one item
    Examples:
      |filter|
      |description=github|
      |search=github|
      |location=new+york|
      |lat=40.7128&long=74.0060|
      |full_time=true|
      |full_time=false|

  Scenario Outline: Retrieve available positions in JSON format with a valid filter that does not return results
    When I send the API call GET "/positions.json?<filter>"
    Then the response code should be 200
    And response array should be empty
    Examples:
      |filter|
      |description=thiswillnotreturnresults|
      |search=neitherwillthis|
      |location=Arstotzka|
      |lat=15.326572&long=-76.157227|

  Scenario: Retrieve results that contain a word in the description
    When I send the API call GET "/positions.json?description=QA"
    Then the response code should be 200
    And the path "$..description" in the response should include the value "QA"
