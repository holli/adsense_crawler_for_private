require File.dirname(__FILE__) + '/../../test_helper'

class LoginTest < ActionDispatch::IntegrationTest
  #fixtures :all

  def setup
    AdsenseCrawlerForPrivate.ip_ranges = nil

    @cookie_name = AdsenseCrawlerForPrivate.cookie_name = "adsense_crawler"
    @cookie_domain = AdsenseCrawlerForPrivate.cookie_domain = :all
    
    @crawler_name = AdsenseCrawlerForPrivate.crawler_name = "craw_name_TEST"
    @crawler_password = AdsenseCrawlerForPrivate.crawler_password = "crawler_password_TEST"
  end

  test "login without right setup (password nil)" do
    AdsenseCrawlerForPrivate.crawler_password = nil
    get 'adsense_crawler_for_private/login'
    assert_response 401
    assert_equal 'AdsenseCrawlerForPrivate not configured, no password given.', @response.body
  end

  test "login with right access code from right ip" do
    ip_used = "199.199.199.199"
    AdsenseCrawlerForPrivate.ip_ranges = [IPAddr.new(ip_used.to_s)]
    ActionDispatch::Request.any_instance.stubs(:remote_addr).returns(ip_used.to_s)

    get 'adsense_crawler_for_private/login',
        :name => @crawler_name, :password => @crawler_password
    assert_response :success
    assert_equal 'crawler login ok', @response.body

    cookie_str = cookies[@cookie_name]
    cookie_str = ActiveSupport::MessageVerifier.new(Dummy::Application.config.secret_token).verify(cookie_str)
    assert cookie_str.include?(ip_used.to_s), "cookie should include current ip"
    assert cookie_str.include?(@crawler_name), "cookie should include crawler name"
  end

  test "login with right access code from right ip and with post-request" do
    ip_used = "199.199.199.199"
    AdsenseCrawlerForPrivate.ip_ranges = [IPAddr.new(ip_used.to_s)]
    ActionDispatch::Request.any_instance.stubs(:remote_addr).returns(ip_used.to_s)

    post 'adsense_crawler_for_private/login',
        :name => @crawler_name, :password => @crawler_password
    assert_response :success
    assert_equal 'crawler login ok', @response.body

    cookie_str = cookies[@cookie_name]
    cookie_str = ActiveSupport::MessageVerifier.new(Dummy::Application.config.secret_token).verify(cookie_str)
    assert cookie_str.include?(ip_used.to_s), "cookie should include current ip"
    assert cookie_str.include?(@crawler_name), "cookie should include crawler name"
  end

  test "login with right access code and nil ip's" do
    ip_used = "123.123.123.123"
    ActionDispatch::Request.any_instance.stubs(:remote_addr).returns(ip_used.to_s)

    get 'adsense_crawler_for_private/login',
        :name => @crawler_name, :password => @crawler_password
    assert_response :success
    assert_equal 'crawler login ok', @response.body

    cookie_str = cookies[@cookie_name]
    cookie_str = ActiveSupport::MessageVerifier.new(Dummy::Application.config.secret_token).verify(cookie_str)
    assert cookie_str.include?(ip_used.to_s), "cookie should include current ip"
    assert cookie_str.include?(@crawler_name), "cookie should include crawler name"
  end

  test "login from wrong ip" do
    AdsenseCrawlerForPrivate.ip_ranges = [IPAddr.new("199.199.199.199")]
    ActionDispatch::Request.any_instance.stubs(:remote_addr).returns("1.1.1.1")

    get 'adsense_crawler_for_private/login',
        :name => @crawler_name, :password => @crawler_password

    assert_response 401
    assert_equal 'crawler login unsuccessful', @response.body

    assert_equal "", cookies[@cookie_name], "should delete cookie"

  end

  test "login with wrong access codes" do

    get 'adsense_crawler_for_private/login',
        :name => @crawler_name, :password => "wrong_pass"
    assert_response 401
    assert_equal 'crawler login unsuccessful', @response.body

    assert_equal "", cookies[@cookie_name], "should delete cookie"
  end
end
