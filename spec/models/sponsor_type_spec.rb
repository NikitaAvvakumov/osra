require 'rails_helper'

describe SponsorType, type: :model do
  subject(:sponsor_type) { build_stubbed(:sponsor_type) }

  it { is_expected.to be_valid }

  describe 'validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :code }
    it { is_expected.to validate_uniqueness_of :name }
    it { is_expected.to validate_uniqueness_of :code }
  end
end
