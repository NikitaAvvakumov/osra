require 'rails_helper'

describe Sponsor, type: :model do
  subject(:sponsor) { build_stubbed(:sponsor) }

  it { is_expected.to be_valid }

  describe 'validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :country }
    it { is_expected.to validate_presence_of :sponsor_type }
    it { is_expected.to ensure_inclusion_of(:gender).in_array %w(Male Female) }
    it { is_expected.to belong_to :status }
    it { is_expected.to belong_to :sponsor_type }

    context 'when start_date is set in the future' do
      before { sponsor.sponsorship_start_date = Date.tomorrow }
      it { is_expected.not_to be_valid }
    end
  end

  describe 'before_create callback' do
    # Need non-persisted sponsor to trigger before_create callback
    let(:callback_sponsor) { build(:sponsor, sponsor_type: build_stubbed(:sponsor_type)) }

    describe '#set_defaults' do
      describe 'status' do
        let!(:under_revision_status) { create(:status, name: 'Under Revision', code: 4) }
        let(:active_status) { build_stubbed(:status, name: 'Active', code: 1) }

        it 'defaults status to Under Revision' do
          callback_sponsor.save!
          expect(callback_sponsor.status).to eq under_revision_status
        end

        it 'sets non-default status when specified' do
          callback_sponsor.status = active_status
          callback_sponsor.save!
          expect(callback_sponsor.status).to eq active_status
        end
      end

      describe 'start_date' do
        it 'defaults start_date to current date' do
          callback_sponsor.save!
          expect(callback_sponsor.sponsorship_start_date).to eq Date.current
        end

        it 'sets non-default date when specified' do
          callback_sponsor.sponsorship_start_date = Date.yesterday
          callback_sponsor.save!
          expect(callback_sponsor.sponsorship_start_date).to eq Date.yesterday
        end
      end
    end
  end
end
