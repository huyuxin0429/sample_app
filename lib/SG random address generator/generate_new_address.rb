# require 'sg_addresses.txt'
module GenerateNewAddress
    @@file = File.open("#{Rails.root}/lib/SG random address generator/sg_addresses.txt")
    @@file_data = @@file.readlines.map(&:chomp)
    def new
        # byebug
        @@file_data.sample.split
    end
    # byebug
    @@file.close
end