class AddExtrasToActiveAudits < ActiveRecord::Migration
  def change
    add_column :audits, :extras, :text
  end
end