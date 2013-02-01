class AddAcmIdToPaper < ActiveRecord::Migration
  def change
    add_column :papers,:acm_id,:string
  end
end
