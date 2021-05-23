module ApplicationHelper
    # Return full title based on what page parameter it is provided
    def full_title(page_title = "")
        base_title = "DrDelivery"
        if page_title.empty?
            base_title
        else
            page_title + " | " + base_title
        end
    end
end
