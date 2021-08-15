require 'rails_helper'

RSpec.describe "order_maps/index", type: :view do
  before(:each) do
    assign(:order_maps, [
      OrderMap.create!(
        words: "Words"
      ),
      OrderMap.create!(
        words: "Words"
      )
    ])
  end

  it "renders a list of order_maps" do
    render
    assert_select "tr>td", text: "Words".to_s, count: 2
  end
end
