# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create a main sample user.
User.create!(name: "Example User",
    email: "example@railstutorial.org",
    password: "foobar",
    password_confirmation: "foobar",
    address: 'Singapore',
    contact_no: 12341234,
    admin: true,
    activated: true,
    activated_at: Time.zone.now )
# Generate a bunch of additional users.
99.times do |n|
    name = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password = "password"
    address = "Singapore"
    contact_no = 12341234
    User.create!(name: name,
        email: email,
        password: password,
        password_confirmation: password,
        address: Faker::Address,
        contact_no: contact_no,
        admin: false)
        activated: true,
        activated_at: Time.zone.now )
end


Merchant.create!(company_name: "Example Merchant",
    email: "example@railstutorial.org",
    password: "foobar",
    password_confirmation: "foobar",
    address: 'Singapore',
    contact_no: 12341234 )
# Generate a bunch of additional users.
99.times do |n|
    company_name = Faker::Name.name
    email = "company-#{n+1}@railstutorial.org"
    password = "password"
    address = "Singapore"
    contact_no = 12341234
    Merchant.create!(company_name: company_name,
        email: email,
        password: password,
        password_confirmation: password,
        address: Faker::Address,
        contact_no: contact_no)
end