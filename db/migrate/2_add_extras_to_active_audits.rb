class AddExtrasToActiveAudits < ActiveRecord::Migration
  add_column :audits, :extras, :text
end