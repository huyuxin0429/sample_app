require 'rails_helper'

RSpec.describe "order_maps/new", type: :view do
  before(:each) do
    assign(:order_map, OrderMap.new(
      words: "MyString"
    ))
  end

  it "renders new order_map form" do
    render

    assert_select "form[action=?][method=?]", order_maps_path, "post" do

      assert_select "input[name=?]", "order_map[words]"
    end
  end
end
