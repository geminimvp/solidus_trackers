require 'spec_helper'

describe "Analytics Tracker", type: :feature do
  stub_authorization!
  let!(:store1) { create(:store) }
  let!(:tracker1) { create(:tracker, store: store1) }
  let!(:store2) { create(:store) }
  let!(:tracker2) { create(:tracker, analytics_id: 'B100', tracker_type: 'facebook_pixel', active: false, store: store2) }

  context "index" do
    before(:each) do
      visit spree.admin_path
      click_link "Settings"
      click_link "Analytics Tracker"
    end

    it "should have the right content" do
      expect(page).to have_content("Analytics Trackers")
    end

    it "should have the right tabular values displayed for the current store" do
      within_row(1) do
        expect(column_text(1)).to eq(tracker1.analytics_id)
        expect(column_text(2)).to eq(tracker1.tracker_type.split('_').map(&:capitalize).join(' '))
        expect(column_text(3)).to eq(tracker1.boolean_to_string)
      end
    end

    it "should not have the tabular values displayed for the other store" do
      within_row(1) do
        expect(column_text(1)).to_not eq(tracker2.analytics_id)
        expect(column_text(2)).to_not eq(tracker2.tracker_type.split('_').map(&:capitalize).join(' '))
        expect(column_text(3)).to_not eq(tracker2.boolean_to_string)
      end
    end
  end

  context "create" do
    before(:each) do
      visit spree.admin_path
      click_link "Settings"
      click_link "Analytics Tracker"
      click_link "admin_new_tracker_link"
      fill_in "tracker_analytics_id", with: tracker1.analytics_id
      select all("#tracker_tracker_type option")[1].text, from: "tracker_tracker_type"
      click_button "Create"
    end

    it "should be able to create a new analytics tracker for the current store only" do
      expect(page).to have_content("Tracker created")
      within_row(1) do
        expect(column_text(1)).to eq(tracker1.analytics_id)
        expect(column_text(2)).to eq(tracker1.tracker_type.split('_').map(&:capitalize).join(' '))
        expect(column_text(3)).to eq(tracker1.boolean_to_string)
      end
    end

    it "should not be able to create a new analytics tracker for the other store only" do
      within_row(1) do
        expect(column_text(1)).to_not eq(tracker2.analytics_id)
        expect(column_text(2)).to_not eq(tracker2.tracker_type.split('_').map(&:capitalize).join(' '))
        expect(column_text(3)).to_not eq(tracker2.boolean_to_string)
      end
    end
  end

  context "store" do
    it "should display the script tag if a tracking id is provided for the current store only" do
      create(:tracker, store: store1)

      visit spree.root_path
      expect(page).to have_css('#solidus_trackers_google_analytics', visible: false)
    end
  end
end
