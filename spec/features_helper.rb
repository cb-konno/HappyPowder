require 'rails_helper'

def parse_data(included_th: true)
  row_count = page.find('table').all('tr').count
  col_count = page.find('table').all("th").count
  all_td = page.find('table').all("td").map { |e| e.text() }

  table = []
  row_count -= 1 unless included_th

  for row in 0..(row_count - 1)
    table << all_td.shift(col_count)
  end
  table
end
