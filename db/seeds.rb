# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# TODO all seeds should be idempotent

# "upload" example files for bicrypt:
begin
  %w( gk.db3 MasterGK.key prnd.db3 sign_02150110.key uz.db3 ).each do |name|
    Uploads::BicryptFile.find_or_create_by_uploaded_file_name(name) do |upload|
      upload.uploaded = File.open(Rails.root.join("samples", "rbc_tools", "private", name))
    end
  end
rescue => e
  puts "Some files are not seeded: #{e.message}"
end
