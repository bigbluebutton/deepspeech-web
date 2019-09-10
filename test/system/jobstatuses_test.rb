# frozen_string_literal: true

require 'application_system_test_case'

class JobstatusesTest < ApplicationSystemTestCase
  setup do
    @jobstatus = jobstatuses(:one)
  end

  test 'visiting the index' do
    visit jobstatuses_url
    assert_selector 'h1', text: 'Jobstatuses'
  end

  test 'creating a Jobstatus' do
    visit jobstatuses_url
    click_on 'New Jobstatus'

    fill_in 'Jobid', with: @jobstatus.jobID
    fill_in 'Status', with: @jobstatus.status
    click_on 'Create Jobstatus'

    assert_text 'Jobstatus was successfully created'
    click_on 'Back'
  end

  test 'updating a Jobstatus' do
    visit jobstatuses_url
    click_on 'Edit', match: :first

    fill_in 'Jobid', with: @jobstatus.jobID
    fill_in 'Status', with: @jobstatus.status
    click_on 'Update Jobstatus'

    assert_text 'Jobstatus was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Jobstatus' do
    visit jobstatuses_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Jobstatus was successfully destroyed'
  end
end
