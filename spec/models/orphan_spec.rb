require 'rails_helper'

describe Orphan, type: :model do

  it 'should have a valid factory' do
    create :orphan_status, name: 'Active'
    expect(build_stubbed :orphan).to be_valid
  end

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :father_name }
  it { is_expected.to_not allow_value(nil).for(:father_is_martyr) }

  it { is_expected.to validate_presence_of :father_date_of_death }
  it { is_expected.to allow_value(Date.today - 5, Date.current).for(:father_date_of_death) }
  it { is_expected.to_not allow_value(Date.today + 5).for(:father_date_of_death) }
  [7, 'yes', true].each do |bad_date_value|
    it { is_expected.to_not allow_value(bad_date_value).for :father_date_of_death }
  end

  it { is_expected.to validate_presence_of :mother_name }
  it { is_expected.to_not allow_value(nil).for(:mother_alive) }

  it { is_expected.to allow_value(Date.today - 5, Date.current).for(:date_of_birth) }
  it { is_expected.to_not allow_value(Date.today + 5).for(:date_of_birth) }
  [7, 'yes', true].each do |bad_date_value|
    it { is_expected.to_not allow_value(bad_date_value).for :date_of_birth }
  end

  it { is_expected.to validate_presence_of :gender }
  it { is_expected.to ensure_inclusion_of(:gender).in_array %w(Male Female) }

  it { is_expected.to validate_presence_of :contact_number }

  it { is_expected.to_not allow_value(nil).for(:sponsored_by_another_org) }

  it { is_expected.to validate_numericality_of(:minor_siblings_count).only_integer.is_greater_than_or_equal_to(0) }

  it { is_expected.to validate_presence_of :original_address }

  it { is_expected.to validate_presence_of :current_address }

  it { is_expected.to have_one(:original_address).class_name 'Address' }
  it { is_expected.to have_one(:current_address).class_name 'Address' }

  it { is_expected.to validate_presence_of :orphan_status }
  it { is_expected.to have_many(:sponsors).through :sponsorships }

  describe 'initializers, methods & scopes' do
    let!(:active_status) { create(:orphan_status, name: 'Active') }
    let!(:unsponsored_status) { create(:orphan_sponsorship_status, name: 'Unsponsored') }

    describe 'initializers' do

      it 'defaults orphan_status to Active' do
        expect(Orphan.new.orphan_status).to eq active_status
      end

      it 'defaults orphan_sponsorship_status to Unsponsored' do
        expect(Orphan.new.orphan_sponsorship_status).to eq unsponsored_status
      end
    end

    describe 'methods & scopes' do
      let!(:sponsored_status) { create :orphan_sponsorship_status, name: 'Sponsored' }
      let!(:inactive_status) { create :orphan_status, name: 'Inactive' }

      address = FactoryGirl.create :address
      orphan_hash = { original_address: address, current_address: address }

      let!(:active_unsponsored_orphan) do
        orphan_hash.merge! orphan_status: active_status, orphan_sponsorship_status: unsponsored_status
        create :orphan, orphan_hash
      end
      let!(:inactive_unsponsored_orphan) do
        orphan_hash.merge! orphan_status: inactive_status, orphan_sponsorship_status: unsponsored_status
        create :orphan, orphan_hash
      end
      let!(:active_sponsored_orphan) do
        orphan_hash.merge! orphan_status: active_status, orphan_sponsorship_status: sponsored_status
        create :orphan, orphan_hash
      end

      describe 'methods' do
        it '#set_status_to_sponsored' do
          orphan = active_unsponsored_orphan
          orphan.set_status_to_sponsored
          expect(orphan.reload.orphan_sponsorship_status).to eq sponsored_status
        end

        it '#set_status_to_unsponsored' do
          orphan = active_sponsored_orphan
          orphan.set_status_to_unsponsored
          expect(orphan.reload.orphan_sponsorship_status).to eq unsponsored_status
        end
      end

      describe 'scopes' do

        it '.active should correctly select active orphans only' do
          expect(Orphan.active.to_a).to eq [active_sponsored_orphan, active_unsponsored_orphan]
        end

        it '.unsponsored should correctly select unsponsored orphans only' do
          expect(Orphan.unsponsored.to_a).to eq [active_unsponsored_orphan, inactive_unsponsored_orphan]
        end

        it '.active.unsponsored should correctly return active unsponsored orphans only' do
          expect(Orphan.active.unsponsored.to_a).to eq [active_unsponsored_orphan]
        end
      end
    end
  end
end
