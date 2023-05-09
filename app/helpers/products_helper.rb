module ProductsHelper
  def format_date(date)
    date.strftime('%Y/%-m/%-d')
  end
  def format_date_with_time(date)
    date.strftime('%Y/%-m/%-d %-H:%-M:%-S')
  end
  def parent_categories
    Category.where(parent_id: nil).pluck(:id, :content) 
  end
  def convert_category_name(name)
    name.gsub('/','_')
  end
end
