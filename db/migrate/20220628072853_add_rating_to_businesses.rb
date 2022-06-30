class AddRatingToBusinesses < ActiveRecord::Migration[6.1]
  def change
    add_column :businesses, :rating, :integer
  end
end
