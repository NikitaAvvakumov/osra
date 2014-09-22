require 'rails_helper'

describe Province, type: :model do

  it 'should have a valid factory' do
    expect(build_stubbed :province).to be_valid
  end

  it 'should be able to call the factory many times' do
    13.times { build_stubbed :province }
    expect(build_stubbed(:province).code).to eq 29
    expect(build_stubbed(:province).code).to eq 11
  end

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of :name }
  it { is_expected.to validate_presence_of :code }
  it { is_expected.to validate_uniqueness_of :code }
  it { is_expected.to ensure_inclusion_of(:code).in_array Province::PROVINCE_CODES }
end
