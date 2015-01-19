require 'rails_helper'
require 'cgi'

RSpec.describe "hq/partners/_form.html.erb", type: :view do
  let(:partner) { build_stubbed :partner,
                  region: "Region1", contact_details: "CD123"}

  before :each do
    @facade = PartnerFacade.new(partner)
  end

  specify 'has a form' do
    render

    assert_select 'form'
  end

  describe '"Cancel" button' do
    specify 'when no :id' do
      allow(partner).to receive(:id).and_return nil
      render

      assert_select 'a[href=?]', hq_partners_path, text: 'Cancel'
    end

    specify 'when :id' do
      render

      assert_select 'a[href=?]', hq_partner_path(partner.id), text: 'Cancel'
    end
  end

  specify 'form values' do
    render

    assert_select "input#partner_name" do
      assert_select "[value=?]", CGI::escape_html(partner.name)
    end

    assert_select "input#partner_region" do
      assert_select "[value=?]",  CGI::escape_html(partner.region)
    end

    assert_select "input#partner_contact_details" do
      assert_select "[value=?]",  CGI::escape_html(partner.contact_details)
    end

    assert_select "select#partner_province_id" do
      assert_select "option", value: Province.first.id,
        html: CGI::escape_html(Province.first.name)
    end

    assert_select "select#partner_status_id" do
      assert_select "option", value: Status.first.id,
        html: CGI::escape_html(Status.first.name)
    end

    assert_select "input#partner_start_date" do
      assert_select "[value=?]", partner.start_date
    end

    assert_select "input", type: "submit"
  end

end

