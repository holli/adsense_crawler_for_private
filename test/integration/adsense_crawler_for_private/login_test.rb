require File.dirname(__FILE__) + '/../../test_helper'

class LoginTest < ActionDispatch::IntegrationTest
  fixtures :all

  #TODO: KATO SAISKO MINITEST:frameworkin toimimaan? Ja onko tarvetta?
  describe "joo" do
    it "housl dbe ok" do
      puts "INSIDE"
      get 'adsense_crawler_for_private/login'
      assert_response 401
    end
  end

  test "login with right access code" do

    @crawler_name = AdsenseCrawlerForPrivate.crawler_name = "craw_name_TEST"
    @crawler_password = AdsenseCrawlerForPrivate.crawler_password = "crawler_password_TEST"

    get 'adsense_crawler_for_private/login',
        :crawler_name => @crawler_name, :crawler_password => @crawler_password
    assert_response :success
    assert_equal 'crawler login ok', @response.body

    # TODO: assert that there is cookie

  end

  test "login from wrong ip" do
    # TODO TEST HERE
  end

  test "login with wrong access codes" do
    #assert false
    # TODO TEST HERE
  end
end
