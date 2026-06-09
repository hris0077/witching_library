require "rails_helper"

RSpec.describe "Users registration", type: :system do
  it "creates user" do
    visit new_registration_path

    expect(page).to have_content("Inscribe Your Name")


    fill_in "Your True Name", with: "user@example.com"
    fill_in "Given Name", with: "Elena"
    fill_in "House Name", with: "Vasilica"
    select "Hawaii", from: "Realm of Dwelling"
    fill_in "Secret Sigil", with: "securepass123"
    fill_in "Echo the Sigil", with: "securepass123"
    click_button "Seal the Covenant"

    expect(page).to have_content("Successfully signed up!")

    expect(User.find_by(email_address: "user@example.com")&.first_name).to eq("Elena")
  end

  it "redirects user to login" do
    visit new_registration_path

    expect(page).to have_content("Inscribe Your Name")
    click_link "Enter the Hut"
    expect(current_path).to eq(new_session_path)
  end
end
