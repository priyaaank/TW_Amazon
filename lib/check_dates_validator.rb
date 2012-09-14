class CheckDatesValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    isvalid = true
    if value.nil? then 
      isvalid = false
      object.errors[attribute] << (options[:message] || "is required")
    else  
      if value < Date.today  then 
        isvalid = false
        object.errors[attribute] << (options[:message] || "is at least today's date")
      end
    end
  end
  
=begin
  def valid_end_date(object, attribute, value)
    isvalid = true
    if self.end_date.nil? then
      isvalid = false
      object.errors[attribute] << (option[:message] || "is required")
    else
      unless self.start_date.nil? then
        if self.end_date < self.start_date || max_end_date < self.end_date then 
          isvalid = false
          errors.add(:end_date, "End date must be between the start date and 2 months after it")
        end
      end
    end
  end  
=end
end