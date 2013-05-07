class CategoriesController < InheritedResources::Base
  include ApplicationHelper
  before_filter :authenticate_user!
end
