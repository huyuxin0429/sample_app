# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


require "#{Rails.root}/lib/SG random address generator/generate_new_address.rb"
require "#{Rails.root}/lib/drone_handler.rb"
include DroneHandler
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
puts 'created admin'
5.times do |n|
    name = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password = "password"
    contact_no = 12341234
    cust = Customer.new(name: name,
        email: email,
        password: password,
        password_confirmation: password,
        contact_no: contact_no,
        activated: true,
        activated_at: Time.zone.now
    )

    while !cust.save
        name = Faker::Name.name
        email = "example-#{n+1}@railstutorial.org"
        password = "password"
        contact_no = 12341234
        cust = Customer.new(name: name,
            email: email,
            password: password,
            password_confirmation: password,
            contact_no: contact_no,
            activated: true,
            activated_at: Time.zone.now
        )

    end
end
puts 'created customer'
# Generate a bunch of additional merchants.
5.times do |n|
    name = Faker::Company.name
    email = "merchant-#{n+1}@railstutorial.org"
    password = "password"
    contact_no = 12341234
    merc = Merchant.new(name: name,
        email: email,
        password: password,
        password_confirmation: password,
        contact_no: contact_no,
        activated: true,
        activated_at: Time.zone.now)
    while !merc.save
        name = Faker::Company.name
        email = "merchant-#{n+1}@railstutorial.org"
        password = "password"
        contact_no = 12341234
        merc = Merchant.new(name: name,
            email: email,
            password: password,
            password_confirmation: password,
            contact_no: contact_no,
            activated: true,
            activated_at: Time.zone.now
        )
    end
end

puts 'created merchant'



# Generate micropost for a subset of users.activated
customers = Customer.all
merchants = Merchant.all

# 2.times do
#     content = Faker::Lorem.sentence(word_count: 5)
#     customers.each{ |customer| customer.microposts.create!(content: content) }
# end

2.times do
    
    # customGenerated = GenerateNewAddress.new
    # street_address = Faker::Address.street_address() 
    # city = Faker::Address.city() 
    # country =  customGenerated[0]
    # postcode =  customGenerated[1]
    # building_no =  Faker::Number.between(from: 1, to: 10)  
    # unit_number = "#23-233"
    # name =  Faker::Address.community 
    # byebug
customers.each{|customer| 
    
    customGenerated = GenerateNewAddress.new
    street_address = Faker::Address.street_address() 
    city = Faker::Address.city() 
    country =  customGenerated[0]
    postcode =  customGenerated[1]
    building_no =  Faker::Number.between(from: 1, to: 10)  
    unit_number = "#23-233"
    name =  Faker::Address.community 
    search_data =  [country, postcode].compact.join(', ')
    result = Geocoder.search(search_data).first
    while result.nil?
        # byebug
        puts 'geocoder looping'
        customGenerated = GenerateNewAddress.new
        country =  customGenerated[0]
        postcode =  customGenerated[1]
        search_data =  [country, postcode].compact.join(', ')
        result = Geocoder.search(search_data).first
    end
    result = result.coordinates

    add = customer.addresses.new(
        latitude: result[0],
        longitude: result[1],
        street_address: street_address,
        city: city,
        country: country,
        postcode: postcode,
        building_no: building_no,
        unit_number: unit_number,
        name: name
    )
    # byebug
    while !add.save
        customGenerated = GenerateNewAddress.new
        street_address = Faker::Address.street_address() 
        city = Faker::Address.city() 
        country =  customGenerated[0]
        postcode =  customGenerated[1]
        building_no =  Faker::Number.between(from: 1, to: 10)  
        unit_number = "#23-233"
        name =  Faker::Address.community 
        search_data =  [country, postcode].compact.join(', ')
        result = Geocoder.search(search_data).first
        while result.nil?
            # byebug
            puts 'geocoder looping'
            customGenerated = GenerateNewAddress.new
            country =  customGenerated[0]
            postcode =  customGenerated[1]
            search_data =  [country, postcode].compact.join(', ')
            result = Geocoder.search(search_data).first
        end
        result = result.coordinates

        add = customer.addresses.new(
            latitude: result[0],
            longitude: result[1],
            street_address: street_address,
            city: city,
            country: country,
            postcode: postcode,
            building_no: building_no,
            unit_number: unit_number,
            name: name
        )
    end

    }

    
end

puts 'created cust address'

3.times do |n|
    customGenerated = GenerateNewAddress.new
    country =  customGenerated[0]
    postcode =  customGenerated[1]
    drone = Drone.new()
    # byebug
    result = Geocoder.search(country + ',' + postcode)[0]
    while result.nil?
        customGenerated = GenerateNewAddress.new
        country =  customGenerated[0]
        postcode =  customGenerated[1]
        result = Geocoder.search(country + ',' + postcode)[0]
    end
    # byebug
    address = Address.new(
        latitude: result.latitude,
        longitude: result.longitude
    )
    address.addressable = drone
    # byebug
    drone.current_address = address
    drone.save!
    address.save!
    
    # drone.current_address.addressable = drone

end
puts 'created drones'

5.times do
    # customGenerated = GenerateNewAddress.new
    # street_address = Faker::Address.street_address() 
    # city = Faker::Address.city() 
    # country =  customGenerated[0]
    # postcode =  customGenerated[1]
    # building_no =  Faker::Number.between(from: 1, to: 10)  
    # unit_number = "#23-233"
    name =  Faker::Address.community 

    merchants.each{|merchant| 
        
        customGenerated = GenerateNewAddress.new
        street_address = Faker::Address.street_address() 
        city = Faker::Address.city() 
        country =  customGenerated[0]
        postcode =  customGenerated[1]
        building_no =  Faker::Number.between(from: 1, to: 10)  
        unit_number = "#23-233"
        name =  Faker::Address.community 
        search_data =  [country, postcode].compact.join(', ')
        result = Geocoder.search(search_data).first 
        while result.nil?
            # byebug
            puts 'geocoder looping'
            customGenerated = GenerateNewAddress.new
            country =  customGenerated[0]
            postcode =  customGenerated[1]
            search_data =  [country, postcode].compact.join(', ')
            result = Geocoder.search(search_data).first
        end
        result = result.coordinates

        add = merchant.addresses.new(
            latitude: result[0],
            longitude: result[1],
            street_address: street_address,
            city: city,
            country: country,
            postcode: postcode,
            building_no: building_no,
            unit_number: unit_number,
            name: name
        )
        # byebug
        while !add.save
            customGenerated = GenerateNewAddress.new
            street_address = Faker::Address.street_address() 
            city = Faker::Address.city() 
            country =  customGenerated[0]
            postcode =  customGenerated[1]
            building_no =  Faker::Number.between(from: 1, to: 10)  
            unit_number = "#23-233"
            name =  Faker::Address.community 
            search_data =  [country, postcode].compact.join(', ')
            result = Geocoder.search(search_data).first 
            while result.nil?
                # byebug
                puts 'geocoder looping'
                customGenerated = GenerateNewAddress.new
                country =  customGenerated[0]
                postcode =  customGenerated[1]
                search_data =  [country, postcode].compact.join(', ')
                result = Geocoder.search(search_data).first
            end
            result = result.coordinates
    
            add = merchant.addresses.new(
                latitude: result[0],
                longitude: result[1],
                street_address: street_address,
                city: city,
                country: country,
                postcode: postcode,
                building_no: building_no,
                unit_number: unit_number,
                name: name
            )
        end
    }

    
end

puts 'created merchant address'



merchants.each{|merchant| 
    20.times do
        # Faker::Config.random = rand()
        description =  Faker::Lorem.sentence(word_count: 5)
        quantity =  Faker::Number.between(from: 1, to: 10)  
        price = Faker::Commerce.price()
        name =  Faker::Commerce.product_name()
        prod = merchant.products.new(
            description: description,
            quantity: quantity,
            price: price,
            name: name
        )

        while !prod.save
            description =  Faker::Lorem.sentence(word_count: 5)
            quantity =  Faker::Number.between(from: 1, to: 10)  
            price = Faker::Commerce.price()
            name =  Faker::Commerce.product_name()
            prod = merchant.products.new(
                description: description,
                quantity: quantity,
                price: price,
                name: name
            )
        end
    end
}

puts 'created merchant products'
    
    


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
        # DroneHandler.addOrderToDroneQueue(order)
        order.total_price = total_price
        order.save!
        # puts 'added order'
    }
end

puts 'created orders'


# Create following relationships.
# users = User.all
# user = users.first
# following = users[2..50]
# followers = users[3..40]
# following.each { |followed| user.follow(followed) }
# followers.each { |follower| follower.follow(user) }