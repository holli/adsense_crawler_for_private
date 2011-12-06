require File.dirname(__FILE__) + '/../../test_helper'

class FilteringHelperTest < ActionDispatch::IntegrationTest
  fixtures :all

  setup do
    @crawler_name = AdsenseCrawlerForPrivate.crawler_name = "craw_name_TEST"
    @crawler_password = AdsenseCrawlerForPrivate.crawler_password = "crawler_password_TEST"
    #@ip_ranges = AdsenseCrawlerForPrivate.crawler_password =
  end

  def login
    get 'adsense_crawler_for_private/login',  :crawler_name => @crawler_name, :crawler_password => @crawler_password
    assert_response :success
    assert_equal 'crawler login ok', @response.body
  end

  test "normal_render as normal" do
    get 'normal_render'
    assert_response :success
    assert_equal "this is rendered normally", @response.body

    login
    get 'normal_render'
    assert_response :success
    assert_equal "this is rendered normally", @response.body
  end

  test "forbidden_render" do

    get 'forbidden_render'
    assert_redirected_to "http://www.you-were-not-logged-in.inv"

    login
    get 'forbidden_render'
    assert_response :success
    assert_equal "private page for adsense", @response.body
    
  end

end
