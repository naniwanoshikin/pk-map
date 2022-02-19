require 'spec_helper'

describe ApplicationHelper, type: :helper  do

  describe 'full_title' do # 5.3
    it 'should include the page title' do
      expect(full_title('foo')).to match(/foo/)
      expect(full_title('foo')).to match(/^foo | Ruby on Rails Tutorial Sample App/)
      expect(full_title('')).not_to match(/\|/)
    end
  end
end
