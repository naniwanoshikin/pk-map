require 'rails_helper'

describe 'Home pages', type: :request do

  include ApplicationHelper

  let(:base_title) { 'PK マップ' }

  subject { page }

  shared_examples 'all home pages' do |heading, page_title|
    it '正常なレスポンスを返し、正しい文言が含まれている' do
      expect(response).to have_http_status(:success)
      expect(response).to include(heading)
      expect(response).to include(full_title(page_title))
    end
  end

  describe 'Home page' do
    before { get root_path }
    let(:heading)    { '外' }
    let(:page_title) { '' }
    it_behaves_like 'all home pages'
    it { should_not have_title('Home') }
    it { should have_selector('h1', text: '外に出よう') }
  end

  describe 'Help page' do
    before { get help_path }
    let(:heading)    { 'Help' }
    let(:page_title) { 'Help' }
    it_behaves_like 'all home pages'
  end

  describe 'About page' do
    before { get about_path }
    let(:heading)    { 'About' }
    let(:page_title) { 'About' }
    it_behaves_like 'all home pages'
  end

end
