class MainController < ApplicationController

  before_filter :adsense_crawler_private_specific_page, :only => :forbidden_render
  before_filter :redirect_if_not_logged, :only => :forbidden_render


  def normal_render
    #debugger
    render :text => 'this is rendered normally'
  end

  def forbidden_render
    render :text => 'never used'
  end

  protected

  def redirect_if_not_logged
    redirect_to "http://you_were_not_logged.inv"
  end

  def adsense_crawler_private_specific_page
    if AdsenseCrawlerForPrivate.login_check(cookies, request)
      render :text => "private page for adsense"
      return false
    end
  end

end
