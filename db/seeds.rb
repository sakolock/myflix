# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Category.create(name: 'Action')
Category.create(name: 'Drama')
Category.create(name: 'Comedy')

Video.create(title: 'South Park', description: 'This is a show about a family with strong moral character', small_cover_url: '/tmp/south_park.jpg', large_cover_url: 'http://placehold.it/450x300', category_id: 1)
Video.create(title: 'Family Guy', description: 'A new great show about a family with strong moral character', small_cover_url: '/tmp/family_guy.jpg', large_cover_url: 'http://placehold.it/450x300', category_id: 1)
Video.create(title: 'Monk', description: 'A show about a family with strong moral character', small_cover_url: '/tmp/monk.jpg', large_cover_url: '/tmp/monk_large.jpg', category_id: 1)
Video.create(title: 'Futurama', description: 'A show about a family with strong moral character', small_cover_url: '/tmp/futurama.jpg', large_cover_url: 'http://placehold.it/450x300', category_id: 1)
Video.create(title: 'Futurama', description: 'A show about a family with strong moral character', small_cover_url: '/tmp/futurama.jpg', large_cover_url: 'http://placehold.it/450x300', category_id: 2)
Video.create(title: 'Futurama', description: 'A show about a family with strong moral character', small_cover_url: '/tmp/futurama.jpg', large_cover_url: 'http://placehold.it/450x300', category_id: 3)
Video.create(title: 'Futurama', description: 'A show about a family with strong moral character', small_cover_url: '/tmp/futurama.jpg', large_cover_url: 'http://placehold.it/450x300', category_id: 3)
Video.create(title: 'South Park', description: 'This is a show about a family with strong moral character', small_cover_url: '/tmp/south_park.jpg', large_cover_url: 'http://placehold.it/450x300', category_id: 1)
Video.create(title: 'Family Guy', description: 'A new great show about a family with strong moral character', small_cover_url: '/tmp/family_guy.jpg', large_cover_url: 'http://placehold.it/450x300', category_id: 1)
monk = Video.create(title: 'Monk', description: 'A show about a family with strong moral character', small_cover_url: '/tmp/monk.jpg', large_cover_url: '/tmp/monk_large.jpg', category_id: 1)
futurama = Video.create(title: 'Futurama', description: 'A show about a family with strong moral character', small_cover_url: '/tmp/futurama.jpg', large_cover_url: 'http://placehold.it/450x300', category_id: 1)

u = User.create(email: 'test123@mail.com', password: 'password', full_name: 'Test User')

Review.create(rating: 4, video: futurama, user: u, content: 'Great flixk, loved the purple one')
Review.create(rating: 1, video: monk, user: u, content: 'Could\'ve been better.')
Review.create(rating: 5, video: monk, user: u, content: 'Hi.')
Review.create(rating: 5, video: futurama, user: u, content: 'The absolute best')
