class CreateActiveAudits < ActiveRecord::Migration
  def change
    create_table :audits do |t|
      t.integer :obj_id
      t.string :obj_type
      t.integer :user_id
      t.text :activity

      t.timestamps
    end
    add_index :audits, :obj_id
    add_index :audits, :user_id
  end
end