require "rails_helper"

RSpec.describe "Users login", type: :system do
  let!(:user) { create(:user, email_address: 'user@example.com', password: 'securepass123') }

  it "logs in with valid credentials" do
    visit new_session_path

    expect(page).to have_content("Prove your identity to the ancient tomes.")

    fill_in "Your True Name", with: "user@example.com"
    fill_in "Secret Sigil", with: "securepass123"
    click_button "Cross the Threshold"

    expect(page).to have_content("Successfully signed in!")
    expect(current_path).to eq(root_path)
  end

  it "shows error for invalid credentials" do
    visit new_session_path

    fill_in "Your True Name", with: "wrong@example.com"
    fill_in "Secret Sigil", with: "wrongpass"
    click_button "Cross the Threshold"

    expect(page).to have_content("Try another email address or password.")
  end
end
