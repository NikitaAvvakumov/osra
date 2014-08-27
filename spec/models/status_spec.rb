require 'rails_helper'

describe Status, type: :model do
  subject(:status) { build_stubbed(:status) }

  it { is_expected.to be_valid }

  describe 'validations' do
    context 'when name is missing' do
      before { status.name = '' }
      it { is_expected.not_to be_valid }
    end

    context 'when code is missing' do
      before { status.code = '' }
      it { is_expected.not_to be_valid }
    end

    context 'when name is not unique' do
      before { create(:status, name: status.name) }
      it { is_expected.not_to be_valid }
    end

    context 'when code is not unique' do
      before { create(:status, code: status.code) }
      it { is_expected.not_to be_valid }
    end
  end
end
