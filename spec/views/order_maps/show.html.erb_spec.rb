require 'rails_helper'

RSpec.describe "order_maps/show", type: :view do
  before(:each) do
    @order_map = assign(:order_map, OrderMap.create!(
      words: "Words"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Words/)
  end
end
