# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create(mail: 'a@a.a', password: '12345678', name: 'チンパンジー', is_deleted: true)
User.create(mail: 'b@b.b', password: '87654321', name: 'バンバンジー', is_deleted: false)
