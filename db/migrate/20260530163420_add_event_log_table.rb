class AddEventLogTable < ActiveRecord::Migration[8.1]
  def change
    create_table :event_logs do |t|
      t.string :name, null: false       # e.g., "search.query", "llm.response"
      t.jsonb :payload                  # Flexible data store
      t.timestamps
    end
    add_index :event_logs, :name
  end
end
