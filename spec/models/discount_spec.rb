require 'rails_helper'

describe Discount do
  describe "validations" do
    it { should validate_numericality_of(:quantity).only_integer }
    it { should validate_numericality_of(:percentage).only_integer }
    it { should validate_presence_of :applied }
  end
  describe "relationships" do
    it { should belong_to :merchant }
  end
end
