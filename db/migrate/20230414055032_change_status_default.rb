class ChangeStatusDefault < ActiveRecord::Migration[6.1]
  def change
    change_column_default :products, :status, 0
  end
end
