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

Then("response array should be empty") do
  expect(JSON.parse(@response.body).length).to eq(0)
end

Then("the path {string} in the response should include the value {string}") do |jsonpath, value|
  path = JsonPath.new(jsonpath)
  path_arr = path.on(JSON.parse(@response.body))

  path_arr.each do |element|
    expect(element).to include(value)
  end
end

Then("each element should have the key {string}") do |key|
  JSON.parse(@response.body).each do |element|
    expect(element.has_key? key).to be true
  end
end

Then("response should start with {string}") do |myfunction|
  expect(@response.body).to start_with myfunction
end
