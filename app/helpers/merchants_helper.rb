module MerchantsHelper
    def mgravatar_for(merchant, options = {size: 80})
        gravatar_id = Digest::MD5::hexdigest(merchant.email.downcase)
        size = options[:size]
        gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
        image_tag(gravatar_url, alt: merchant.company_name, class: "gravatar")
    end
end
