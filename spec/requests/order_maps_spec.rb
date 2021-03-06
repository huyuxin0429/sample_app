 require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/order_maps", type: :request do
  
  # OrderMap. As you add validations to OrderMap, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      OrderMap.create! valid_attributes
      get order_maps_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      order_map = OrderMap.create! valid_attributes
      get order_map_url(order_map)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_order_map_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      order_map = OrderMap.create! valid_attributes
      get edit_order_map_url(order_map)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new OrderMap" do
        expect {
          post order_maps_url, params: { order_map: valid_attributes }
        }.to change(OrderMap, :count).by(1)
      end

      it "redirects to the created order_map" do
        post order_maps_url, params: { order_map: valid_attributes }
        expect(response).to redirect_to(order_map_url(OrderMap.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new OrderMap" do
        expect {
          post order_maps_url, params: { order_map: invalid_attributes }
        }.to change(OrderMap, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post order_maps_url, params: { order_map: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested order_map" do
        order_map = OrderMap.create! valid_attributes
        patch order_map_url(order_map), params: { order_map: new_attributes }
        order_map.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the order_map" do
        order_map = OrderMap.create! valid_attributes
        patch order_map_url(order_map), params: { order_map: new_attributes }
        order_map.reload
        expect(response).to redirect_to(order_map_url(order_map))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        order_map = OrderMap.create! valid_attributes
        patch order_map_url(order_map), params: { order_map: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested order_map" do
      order_map = OrderMap.create! valid_attributes
      expect {
        delete order_map_url(order_map)
      }.to change(OrderMap, :count).by(-1)
    end

    it "redirects to the order_maps list" do
      order_map = OrderMap.create! valid_attributes
      delete order_map_url(order_map)
      expect(response).to redirect_to(order_maps_url)
    end
  end
end
