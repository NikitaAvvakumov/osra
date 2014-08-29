require 'rails_helper'

describe Status, type: :model do
  subject(:status) { build_stubbed(:status) }

  it { is_expected.to be_valid }

  describe 'validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :code }
    it { is_expected.to validate_uniqueness_of :name }
    it { is_expected.to validate_uniqueness_of :code }
  end
end
