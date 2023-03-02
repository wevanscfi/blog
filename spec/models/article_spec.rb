require 'rails_helper'

RSpec.describe Article, type: :model do
  describe "#dumb" do
    it "should return dedoo" do
      expect(Article.new.dumb).to eq("dedoo")
    end
  end
end
