module ProductsHelper
  def format_date(date)
    date.strftime('%Y/%-m/%-d')
  end
  def format_date_with_time(date)
    date.strftime('%Y/%-m/%-d %-H:%-M:%-S')
  end
end
