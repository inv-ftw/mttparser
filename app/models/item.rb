class Item < ActiveRecord::Base
  BRANDS = %w{ Vinzer Granchio }

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      item = find_by_id(row["id"]) || new
      item.attributes = row.to_hash
      item.save!
    end
  end

end
