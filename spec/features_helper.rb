require 'rails_helper'

def parse_data
  table = page.find('table').all('tr').map do |tr|
    tr = tr.all('td').map { |td| td.text }
  end
  table.drop(1)
end
