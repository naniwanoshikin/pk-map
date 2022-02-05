require 'rails_helper'

describe "Static pages" do

  it "should have the right links on the layout" do
    visit root_path
    
    click_link "About"
    expect(page).to have_title(full_title('About'))
    click_link "Help"
    expect(page).to have_title(full_title('Help'))
    click_link "Contact"
    expect(page).to have_title(full_title('Contact'))
    click_link "Home"
    click_link "Sign up now!"
    # expect(page).to have_title(full_title('Sign up'))
    click_link "sample app"
    expect(page).to have_title(full_title(''))
  end

end