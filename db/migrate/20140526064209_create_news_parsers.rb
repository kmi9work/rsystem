class CreateNewsParsers < ActiveRecord::Migration
  def change
    create_table :news_parsers do |t|
    	t.text :contents
    	t.text :queries
      	t.timestamps
    end
  end
end
