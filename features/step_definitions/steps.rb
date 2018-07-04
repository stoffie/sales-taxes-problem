require 'sales_taxes'
require 'rspec'

Given("the following order:") do |string|
  @receipt = SalesTaxes::Receipt.new(string)
end

When("the receipt is computed") do
	@output = @receipt.to_s
end

Then("I should get the output:") do |string|
  expect(@output).to eq string
end
