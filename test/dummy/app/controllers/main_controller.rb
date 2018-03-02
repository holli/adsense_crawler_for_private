class MainController < ApplicationController

  before_action :adsense_crawler_private_specific_page, :only => :forbidden_render
  before_action :redirect_if_not_logged, :only => :forbidden_render


  def normal_render
    #debugger
    render :plain => 'this is rendered normally'
  end

  def forbidden_render
    render :plain => 'never used'
  end

  protected

  def redirect_if_not_logged
    redirect_to "http://www.you-were-not-logged-in.inv"
  end

  def adsense_crawler_private_specific_page
    if AdsenseCrawlerForPrivate.login_check(cookies, request)
      render :plain => "private render for crawler"
      return false
    end
  end

end
