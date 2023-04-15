module ProductsHelper
  def format_date(date)
    date.strftime('%Y/%-m/%-d')
  end
end
