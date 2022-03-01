require 'rails_helper'

describe 'Static pages', type: :request do

  let(:base_title) { 'PK Map' }

  subject { page }

  shared_examples 'all static pages' do
    it { should have_http_status(:success) }
    it { should have_content(heading) }
    it { should have_title(full_title(page_title)) } # (utility)
  end

  describe 'Home page' do
    before { visit root_path }
    let(:heading)    { '外' }
    let(:page_title) { '' }
    it_behaves_like 'all static pages'
    it { should_not have_title('Home') }
    it { should have_selector('h1', text: '外に出よう') }
  end

  describe 'Help page' do
    before { visit help_path }
    let(:heading)    { 'Help' }
    let(:page_title) { 'Help' }
    it_behaves_like 'all static pages'
  end

  describe 'About page' do
    before { visit about_path }
    let(:heading)    { 'About' }
    let(:page_title) { 'About' }
    it_behaves_like 'all static pages'
  end

end
