class EmailNotificationsController < InheritedResources::Base
  def new
    @email_notification = EmailNotification.find_by_users_id(current_user.id)
    if(@email_notification == nil)
      @email_notification = EmailNotification.new
    end
  end
  def create
    params[:email_notification].delete :select_all
    @email_notification = EmailNotification.new(params[:email_notification])
    @email_notification.users_id = current_user.id
    if @email_notification.save
      respond_to do |format|
        format.html { render :action => 'new'}
      end
    end
  end
  def update
    params[:email_notification].delete :select_all
    @email_notification = EmailNotification.find(params[:id])
    if @email_notification.update_attributes(params[:email_notification])
      respond_to do |format|
        format.html { render :action => 'new' }
      end
    end
  end
end
