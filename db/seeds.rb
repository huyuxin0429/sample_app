# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create a main sample user.
user = User.create!(
    name: "Example User",
    email: "example@railstutorial.org",
    password: "foobar",
    password_confirmation: "foobar",
    contact_no: 12341234,
    admin: true,
    activated: true,
    activated_at: Time.zone.now)
# Generate a bunch of additional customers.
99.times do |n|
    name = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password = "password"
    contact_no = 12341234
    Customer.create!(name: name,
        email: email,
        password: password,
        password_confirmation: password,
        contact_no: contact_no,
        activated: true,
        activated_at: Time.zone.now
    )
end
# Generate a bunch of additional merchants.
99.times do |n|
    name = Faker::Company.name
    email = "merchant-#{n+1}@railstutorial.org"
    password = "password"
    contact_no = 12341234
    Merchant.create!(name: name,
        email: email,
        password: password,
        password_confirmation: password,
        contact_no: contact_no,
        activated: true,
        activated_at: Time.zone.now)
end

# Generate micropost for a subset of users.activated
customers = Customer.order(:created_at).take(6)
merchants = Merchant.all

50.times do
    content = Faker::Lorem.sentence(word_count: 5)
    customers.each{ |customer| customer.microposts.create!(content: content) }
end

3.times do
    street_address = Faker::Address.street_address() 
    city = Faker::Address.city() 
    country =  Faker::Address.country() 
    postcode =  Faker::Address.postcode() 
    building_no =  Faker::Number.between(from: 1, to: 10)  
    unit_number = "#23-233"
    name =  Faker::Address.community 

    customers.each{|customer| customer.addresses.create!(
        street_address: street_address,
        city: city,
        country: country,
        postcode: postcode,
        building_no: building_no,
        unit_number: unit_number,
        name: name
    )}

    
end

1.times do
    street_address = Faker::Address.street_address() 
    city = Faker::Address.city() 
    country =  Faker::Address.country() 
    postcode =  Faker::Address.postcode() 
    building_no =  Faker::Number.between(from: 1, to: 10)  
    unit_number = "#23-233"
    name =  Faker::Address.community 

    merchants.each{|merchant| merchant.addresses.create!(
        street_address: street_address,
        city: city,
        country: country,
        postcode: postcode,
        building_no: building_no,
        unit_number: unit_number,
        name: name
    )}

    
end

# Create following relationships.
users = User.all
user = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }