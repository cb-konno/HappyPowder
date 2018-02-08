require 'rails_helper'

def parse_data(return_row_count: false, included_th: true)
  row_count = page.find('table').all('tr').count
  col_count = page.find('table').all("th").count
  all_td = page.find('table').all("td").map { |e| e.text() }

  table = []
  !included_th ? row_count = row_count - 1 : row_count

  for row in 0..(row_count - 1)
    table << all_td.shift(col_count)
  end

  return_row_count ? [ table, row_count ] : table
end
