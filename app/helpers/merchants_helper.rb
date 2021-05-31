module MerchantsHelper

    # Returns the Gravatar for the given merchant.
    def merchant_gravatar_for(merchant, options = { size: 80 })
        size = options[:size]
        gravatar_id = Digest::MD5::hexdigest(merchant.email.downcase)
        gravatar_url = "https://secure.gravatar.com/avatar/#
        {gravatar_id}?s=#{size}"
        image_tag(gravatar_url, alt: merchant.company_name, class: "gravatar")
    end
end
