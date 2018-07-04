module SalesTaxes
	class OrderParser
		def initialize(order)
			@order_hash = { items: []}
			parse_order order
		end

		def parse_order(order)
			#@basket_no = nil
			order.split(/\n/).each do |line|
				next if line.empty?
				next if parse_order_row line
				raise "Malformed file"
			end
		end

		def parse_order_row(line)
			# use a multiline regex so it's more readable
			regex = /
				^ # begin of line
				(?<quantity>\d+)
				\s+
				(?<item_name>[\w\s]+)
				\s+
				at
				\s+
				(?<item_price>\d+[,.]\d{2})
				$ # end of line
			/x
			if match = regex.match(line)
				captures = match.named_captures
				quantity = captures['quantity'].to_i
				item_name = captures['item_name'].gsub(/imported\s+/, '')
				imported = !!(/imported/ =~ captures['item_name'])
				item_price_cents = captures['item_price'].gsub(/,|\./, '').to_i
				item = { quantity: quantity, imported: imported, \
					item_name: item_name, item_price_cents: item_price_cents}
				@order_hash[:items] << item
				return true
			else
				return false
			end
		end

		def to_hash()
			return @order_hash
		end
	end
end
