require 'rails_helper'

RSpec.describe "order_maps/edit", type: :view do
  before(:each) do
    @order_map = assign(:order_map, OrderMap.create!(
      words: "MyString"
    ))
  end

  it "renders the edit order_map form" do
    render

    assert_select "form[action=?][method=?]", order_map_path(@order_map), "post" do

      assert_select "input[name=?]", "order_map[words]"
    end
  end
end
