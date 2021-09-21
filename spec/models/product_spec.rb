require 'rails_helper'

RSpec.describe Product, type: :model do
    describe 'Validations' do
      # validation tests/examples here
      before(:each) do
        @product = Product.new
        @category = category.new name: 'Apparel'
    end
    it 'saves with all fields filled in' do
        @full_product = Product.new(name: 'a', price: 3449, quantity: 3, category: @category)
        @full_product.save!
        expect(@full_product).to be_persisted
      end
    
      it 'is invalid without a name' do
        expect(@product).to_not be_valid
        expect(@product.errors.messages[:name]).to include('can\'t be blank')
      end
    
      it 'is invalid without a price' do
        expect(@product).to_not be_valid
        expect(@product.errors.messages[:price]).to include('can\'t be blank')
      end
    
      it 'is invalid without a quantity' do
        expect(@product).to_not be_valid
        expect(@product.errors.messages[:quantity]).to include('can\'t be blank')
      end
    
      it 'invalid without a category' do
        expect(@product).to_not be_valid
        expect(@product.errors.messages[:category]).to include("can\'t be blank")
      end
  end