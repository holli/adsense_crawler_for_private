require File.dirname(__FILE__) + '/../../test_helper'

class FilteringHelperTest < ActionDispatch::IntegrationTest

  def setup
    AdsenseCrawlerForPrivate.ip_ranges = nil

    @cookie_name = AdsenseCrawlerForPrivate.cookie_name = "adsense_crawler"
    @cookie_domain = AdsenseCrawlerForPrivate.cookie_domain = :all

    @crawler_name = AdsenseCrawlerForPrivate.crawler_name = "craw_name_TEST"
    @crawler_password = AdsenseCrawlerForPrivate.crawler_password = "crawler_password_TEST"
  end

  test "normal_render as normal for testing dummy application itself" do
    get 'normal_render'
    assert_response :success
    assert_equal "this is rendered normally", @response.body
  end

  test "forbidden_render" do
    get 'forbidden_render'
    assert_redirected_to "http://www.you-were-not-logged-in.inv"
  end


  test "specific render for logged crawler" do
    set_login_cookie

    get 'forbidden_render'

    assert_response :success
    assert_equal "private render for crawler", @response.body
  end

  ####################################
  # INVALID IP TESTS

  test "specific render for logged crawler but with not allowed ip" do
    AdsenseCrawlerForPrivate.ip_ranges = [IPAddr.new("199.199.199.199")]
    set_login_cookie(@crawler_name, @crawler_password, "199.199.199.199")

    get 'forbidden_render'

    assert_response :redirect, "should not render private page"
  end

  #####################################
  # INVALID COOKIES TEST

  test "specific render for expired cookie" do
    cookies[AdsenseCrawlerForPrivate.cookie_name] =
        ActiveSupport::MessageVerifier.new(Dummy::Application.config.secret_token).generate(
            [@crawler_name, @crawler_password, 2.days.ago.httpdate, "127.0.0.1"].to_json)
    get 'forbidden_render'
    assert_response :redirect, "should not render private page"
  end

  test "specific render for not allowed crawler_name" do
    cookies[AdsenseCrawlerForPrivate.cookie_name] =
        ActiveSupport::MessageVerifier.new(Dummy::Application.config.secret_token).generate(
            ["not_allowed_crawler", @crawler_password, 2.days.from_now.httpdate, "127.0.0.1"].to_json)
    get 'forbidden_render'
    assert_response :redirect, "should not render private page"
  end

  test "specific render for enabled crawler but password has changed in config" do
    set_login_cookie
    AdsenseCrawlerForPrivate.crawler_password = "password_changed"

    get 'forbidden_render'
    assert_response :redirect, "should not render private page"
  end

  #####################################
  # HELPERS

  # This is basically setting a signed cookie
  def set_login_cookie(crawler_name=nil, crawler_password=nil, ip=nil)
    crawler_name ||= @crawler_name
    crawler_password ||= @crawler_password
    ip ||= "127.0.0.1"
    cookies[AdsenseCrawlerForPrivate.cookie_name] =
        ActiveSupport::MessageVerifier.new(Dummy::Application.config.secret_token).generate(
            AdsenseCrawlerForPrivate.cookie_str(crawler_name, crawler_password, 2.days.from_now, ip))
  end

end
