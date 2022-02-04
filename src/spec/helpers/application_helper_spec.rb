require 'spec_helper'

describe ApplicationHelper do

  # full_titleヘルパーに対するテスト (5.3)
  describe "full_title" do
    it "should include the page title" do
      expect(full_title("foo")).to match(/foo/)
      expect(full_title("foo")).to match(/^foo | Ruby on Rails Tutorial Sample App/)
    end

    it "should not include a bar for the home page" do
      expect(full_title("")).not_to match(/\|/)
    end
  end
end
