require 'sales_taxes/order_parser'

module SalesTaxes
	BASIC_SALES_TAX = 0.10 # 10%
	SALES_TAX_WHITELIST = [/book/, /chocolate/, /headache pills/]
	IMPORT_DUTY = 0.05 # 5%

	class Recipit
		def initialize(order)
			@order_hash = OrderParser.new(order).to_hash
			compute_grand_total_with_tax
		end

		def to_hash
			@order_hash
		end

		def compute_grand_total_with_tax
			grand_total_no_tax = 0
			grand_total_sale_taxes = 0
			@order_hash[:items].each do |item|
				total_price_no_tax = item[:item_price_cents] * item[:quantity]
				grand_total_no_tax += total_price_no_tax

				basic_sale_tax = compute_basic_sale_tax(item)
				import_duty = compute_import_duty(item)

				total_sale_taxes = basic_sale_tax + import_duty
				grand_total_sale_taxes += total_sale_taxes

				item[:total_price] = total_price_no_tax + total_sale_taxes
			end

			grand_total = grand_total_no_tax + grand_total_sale_taxes
			@order_hash[:grand_total] = grand_total
			@order_hash[:grand_total_sale_taxes] = grand_total_sale_taxes
		end

		def compute_basic_sale_tax(item)
			if whitlisted_item? item then
				0
			else
				(item[:item_price_cents] * BASIC_SALES_TAX / 5).ceil * 5 * item[:quantity]
			end
		end

		def compute_import_duty(item)
			if item[:imported]
				(item[:item_price_cents] * IMPORT_DUTY / 5).ceil * 5 * item[:quantity]
			else
				0
			end
		end

		def whitlisted_item?(item)
			SALES_TAX_WHITELIST.any? { |e| e.match(item[:item_name]) }
		end
	end
end
