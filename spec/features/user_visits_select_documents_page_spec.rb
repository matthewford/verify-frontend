require 'feature_helper'
require 'i18n'

RSpec.describe 'When the user visits the select documents page' do
  def expect_evidence_params(evidence)
    current_uri = URI.parse(page.current_url)
    query = CGI::parse(current_uri.query)
    query_evidence = Set.new(query['selected-evidence'])
    expect(query_evidence).to eql(Set.new(evidence))
  end

  before(:each) do
    set_session_cookies!
  end

  it 'displays the page in Welsh', pending: true do
    visit '/dewiswch-ddogfennau'
    expect(page).to have_title 'Dewiswch yr holl ddogfennau sydd gennych - GOV.UK Verify - GOV.UK'
    expect(page).to have_css 'html[lang=cy]'
  end

  it 'includes the appropriate feedback source' do
    visit '/select-documents'

    expect_feedback_source_to_be(page, 'SELECT_DOCUMENTS_PAGE')
  end

  it 'redirects to the select phone page when user has a driving licence' do
    stub_federation
    visit '/select-documents'

    choose 'select_documents_form_driving_licence_true'
    click_button 'Continue'

    expect(page).to have_current_path(select_phone_path, only_path: true)
  end

  it 'redirects to the select phone page when no docs checked' do
    stub_federation_no_docs
    visit '/select-documents'

    check I18n.translate('hub.select_documents.question.no_docs')
    click_button 'Continue'

    expect(page).to have_current_path(select_phone_path, only_path: true)
  end

  context 'without javascript', js: false do
    it 'will show an error message when no selections have been made' do
      visit 'select-documents'

      click_button 'Continue'

      expect(page).to have_css '.validation-message', text: 'Please select the documents you have'
      expect(page).to have_css '.form-group.error'
    end
  end

  it 'will redirect user to a unlikely to verify page when no eligible profiles match selected evidence' do
    stub_federation
    visit 'select-documents'
    check 'select_documents_form_no_docs'

    click_button 'Continue'

    expect(page).to have_current_path(unlikely_to_verify_path)
  end

  it 'reports to Piwik' do
    stub_request(:get, INTERNAL_PIWIK.url).with(query: hash_including({}))
    piwik_request = {
        'action_name' => 'Select Documents Next'
    }

    visit 'select-documents'
    click_button 'Continue'

    expect(a_request(:get, INTERNAL_PIWIK.url).with(query: hash_including(piwik_request))).to have_been_made.once
  end

  context 'when redirecting to the select phone page' do
    it 'sets selected-evidence param to no-documents when no docs checked' do
      stub_federation_no_docs
      visit '/select-documents'

      check 'select_documents_form_no_docs'
      click_button 'Continue'

      expect(page).to have_current_path(select_phone_path, only_path: true)
      expect_evidence_params(%w(no_documents))
    end

    # The RackTest driver doesn't report multiple query params with the same key in page.current_url
    # We set js to true so that the test runs in a real browser (using Selenium) instead
    context 'with selenium', js: true do
      it 'includes selected-evidence params for all selected documents' do
        stub_federation
        visit '/select-documents'

        choose 'select_documents_form_driving_licence_true'
        choose 'select_documents_form_passport_true'
        choose 'select_documents_form_non_uk_id_document_true'
        click_button 'Continue'

        expect(page).to have_current_path(select_phone_path, only_path: true)
        expect_evidence_params(%w(driving_licence passport non_uk_id_document))
      end
    end
  end
end
