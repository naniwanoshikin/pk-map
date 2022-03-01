require 'spec_helper'

describe ApplicationHelper, type: :helper  do

  describe 'full_title' do # 5.3
    it 'should include the page title' do
      expect(full_title('foo')).to match(/foo/)
      expect(full_title('foo')).to match(/^foo | PK Map/)
      expect(full_title('')).not_to match(/\|/)
    end
  end
end
