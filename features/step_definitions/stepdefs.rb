Given("that I have the host {string}") do |host|
  @host = host
end

When("I send the API call GET {string}") do |controller|
  @placeholders ||= {}
  @placeholders.each do |key, value|
    controller.sub!(key, value)
  end

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

Then("that item should have the key {string}") do |key|
  expect(JSON.parse(@response.body).has_key? key).to be true
end

Then("response should start with {string}") do |myfunction|
  expect(@response.body).to start_with myfunction
end

Given("I retrieve the ID of the first job") do
  @placeholders ||= {}
  @placeholders["{{RetrievedJobID}}"] = JSON.parse(@response.body)[0]["id"]
end

Then("the description and how_to_apply fields should appear as markdown") do
  expect(JSON.parse(@response.body)["description"]).not_to match(/<.?>/)
  expect(JSON.parse(@response.body)["how_to_apply"]).not_to match(/<.?>/)
end

Then("the description and how_to_apply fields should not appear as markdown") do
  expect(JSON.parse(@response.body)["description"]).to match(/<.?>/)
  expect(JSON.parse(@response.body)["how_to_apply"]).to match(/<.?>/)
end

Then("the path {string} in the response should be equal to the value {string}") do |jsonpath, value|
  path = JsonPath.new(jsonpath)
  path_arr = path.on(JSON.parse(@response.body))

  path_arr.each do |element|
    expect(element).to eq(value)
  end
end

Then("the retrieved job ID should not appear in the response") do
  expect(@response.body).not_to include @placeholders["{{RetrievedJobID}}"]
end
