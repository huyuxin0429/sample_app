# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


require "#{Rails.root}/lib/SG random address generator/generate_new_address.rb"
include GenerateNewAddress

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
3.times do |n|
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
3.times do |n|
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
customers = Customer.all
merchants = Merchant.all

# 2.times do
#     content = Faker::Lorem.sentence(word_count: 5)
#     customers.each{ |customer| customer.microposts.create!(content: content) }
# end

3.times do
    
    customGenerated = GenerateNewAddress.new
    street_address = Faker::Address.street_address() 
    city = Faker::Address.city() 
    country =  customGenerated[0]
    postcode =  customGenerated[1]
    building_no =  Faker::Number.between(from: 1, to: 10)  
    unit_number = "#23-233"
    name =  Faker::Address.community 
    # byebug
    customers.each{|customer| add = customer.addresses.new(
        street_address: street_address,
        city: city,
        country: country,
        postcode: postcode,
        building_no: building_no,
        unit_number: unit_number,
        name: name
        )
        # byebug
        add.save!

        }

    
end

1.times do
    customGenerated = GenerateNewAddress.new
    street_address = Faker::Address.street_address() 
    city = Faker::Address.city() 
    country =  customGenerated[0]
    postcode =  customGenerated[1]
    building_no =  Faker::Number.between(from: 1, to: 10)  
    unit_number = "#23-233"
    name =  Faker::Address.community 

    merchants.each{|merchant| add = merchant.addresses.create!(
        street_address: street_address,
        city: city,
        country: country,
        postcode: postcode,
        building_no: building_no,
        unit_number: unit_number,
        name: name
        )
        # byebug
        add.save!
        }

    
end



merchants.each{|merchant| 
    6.times do
        # Faker::Config.random = rand()
        description =  Faker::Lorem.sentence(word_count: 5)
        quantity =  Faker::Number.between(from: 1, to: 10)  
        price = Faker::Commerce.price()
        name =  Faker::Commerce.product_name()
        merchant.products.create!(
        description: description,
        quantity: quantity,
        price: price,
        name: name
        )
    end
}
    
    


customers = Customer.all 

10.times do
    customers.each{|customer|
        merchant = Merchant.order("RANDOM()").first
        order = Order.new()
        order.merchant = merchant
        order.customer = customer
        order.pick_up_address_id = merchant.addresses.first.id
        order.drop_off_address_id = customer.addresses.first.id
        total_price = 0
        merchant.products.each{|product|
            entry = OrderEntry.new
            units_bought = rand(1..100)
            total_unit_price = units_bought * product.price
            entry.product = product
            entry.units_bought = units_bought
            entry.total_unit_price = total_unit_price
            entry.order = order
            entry.save!
            total_price += total_unit_price
            order.order_entries << entry
        }
        order.total_price = total_price
        order.save!
    }
end


# Create following relationships.
# users = User.all
# user = users.first
# following = users[2..50]
# followers = users[3..40]
# following.each { |followed| user.follow(followed) }
# followers.each { |follower| follower.follow(user) }