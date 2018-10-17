Given("that I have the host {string}") do |host|
  @host = host
end

When("I send the API call GET {string}") do |controller|
  @response = RestClient.get(@host + controller)
end

Then("the response code should be {int}") do |int|
  expect(@response.code).to eq(int)
end

Then("the JSON response should include the following") do |expected|
  expect(JSON.parse(@response.body)).to include_json(JSON.parse(expected))
end

Then("response array to include more than one item") do
  expect(JSON.parse(@response.body).length).to be > 1
end
