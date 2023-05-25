
module CategoriesHelper
  def child_list_color(child_categories, recent_child)
    final_class = "p-1 mr-4 text-sm border-b cursor-pointer w-24 sm:w-28 hover:bg-marche_pearl block"
    final_class += " text-marche_orange" if child_categories == recent_child.to_i
    return final_class
  end
end