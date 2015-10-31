# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.new
user.email = 'test@example.com'
user.password = '12345678'
user.password_confirmation = '12345678'
user.save!

profile = Profile.new
profile.name = 'Test'
profile.user_id = user.id
profile.save!
