# frozen_string_literal: true

require 'spec_helper'

describe 'Trackers Controller', type: :request do
  describe 'GET /admin/trackers' do
    context 'when multiple stores with trackers exist' do
      stub_authorization!

      let!(:store1) { create(:store) }
      let!(:tracker1) { create(:tracker, store: store1) }
      let!(:store2) { create(:store) }
      let!(:tracker2) { create(:tracker, store: store2) }

      before do
        get '/admin/trackers'
      end

      it 'loads trackers for the current store' do
        expect(assigns(:trackers)).to include(tracker1)
      end

      it 'does not load trackers for the other store' do
        expect(assigns(:trackers)).to_not include(tracker2)
      end
    end
  end

  describe 'POST /admin/trackers/new' do
    context 'when multiple stores exist' do
      stub_authorization!

      let!(:tracker) {
        create(:tracker, store: store1)
      }
      let!(:store1) { create(:store) }
      let!(:tracker1) {
        create(:tracker, store: store1)
      }

      let!(:store2) { create(:store) }

      let(:create_params) {
        {
          tracker: tracker_params,
        }
      }
      let(:tracker_params) {
        {
          name: "Tracker",
          tracker_id: tracker.id,
          store_id: store1.id,
        }
      }

      it 'associates the tracker with the current store' do
        expect {
          post "/admin/trackers", params: create_params
        }.to change {
          Spree::Tracker.count
        }.by(1)
      end
    end
  end

  describe 'PUT /admin/trackers' do
    context 'when the tracker belongs to another store' do
      stub_authorization!

      let!(:tracker) {
        create(:tracker)
      }
      let!(:store1) { create(:store) }
      let!(:store2) { create(:store) }
      let!(:tracker2) {
        create(:tracker, store: store2)
      }

      let(:update_params) {
        {
          tracker: tracker_params,
        }
      }

      let(:tracker_params) {
        {
          name: 'Another Tracker',
          tracker_id: tracker.id,
          store_id: store1.id,
        }
      }

      before do
        put "/admin/trackers/#{tracker2.id}", params: update_params
      end

      it 'redirects to the trackers index page' do
        expect(response.status).to redirect_to('/admin/trackers')
      end

      it "does not update the other stores' tracker" do
          expect(tracker2.reload.name).to_not eq('Another Tracker')
      end
    end
  end
end
