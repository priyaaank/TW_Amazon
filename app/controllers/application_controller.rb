class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from ActiveRecord::RecordNotFound, :with => :show_not_found_record_errors

  def show_not_found_record_errors
    @error_heading = "404 - Record Not Found"
    @error_msg = "The auction you specified does not exist. Please check your provided auction id or your URL"
    render_page
  end

  private
  def render_page
    respond_to do |format|
      format.html {render 'show_errors'}
    end
  end
end
