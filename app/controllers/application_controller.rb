class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from ActiveRecord::RecordNotFound, :with => :show_not_found_record_errors

  def show_not_found_record_errors
    @error_heading = "404 - Record Not Found"
    @error_msg = "The record you specified does not exist. Please check your provided your URL or record id"
    render_page
  end

  private
  def render_page
    respond_to do |format|
      format.html {render 'layouts/show_errors'}
    end
  end
end
