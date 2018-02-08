require 'rails_helper'

def parse_data
  row_count = page.find('table').all('tr').count
  col_count = page.find('table').all("th").count
  all_td = page.find('table').all("td").map { |e| e.text() }

  table = []
  row_count.times { table << all_td.shift(col_count) }
  table
end
