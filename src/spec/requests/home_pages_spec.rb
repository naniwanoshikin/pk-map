# frozen_string_literal: true

require 'rails_helper'

describe 'Home pages', type: :request do
  describe 'GET /' do
    it 'トップページが正常に表示されること' do
      get root_path
      expect(response).to have_http_status(:ok)
    end
  end
end
