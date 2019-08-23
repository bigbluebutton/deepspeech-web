require 'test_helper'

class JobstatusesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @jobstatus = jobstatuses(:one)
  end

  test "should get index" do
    get jobstatuses_url
    assert_response :success
  end

  test "should get new" do
    get new_jobstatus_url
    assert_response :success
  end

  test "should create jobstatus" do
    assert_difference('Jobstatus.count') do
      post jobstatuses_url, params: { jobstatus: { jobID: @jobstatus.jobID, status: @jobstatus.status } }
    end

    assert_redirected_to jobstatus_url(Jobstatus.last)
  end

  test "should show jobstatus" do
    get jobstatus_url(@jobstatus)
    assert_response :success
  end

  test "should get edit" do
    get edit_jobstatus_url(@jobstatus)
    assert_response :success
  end

  test "should update jobstatus" do
    patch jobstatus_url(@jobstatus), params: { jobstatus: { jobID: @jobstatus.jobID, status: @jobstatus.status } }
    assert_redirected_to jobstatus_url(@jobstatus)
  end

  test "should destroy jobstatus" do
    assert_difference('Jobstatus.count', -1) do
      delete jobstatus_url(@jobstatus)
    end

    assert_redirected_to jobstatuses_url
  end
end
