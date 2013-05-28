module HomeHelper
  def days_left(ending_soon)
    #if ending_soon.end_date < Time.now.to_date # ended already
    #  return 'Ended'
    #elsif ending_soon.end_date > (Time.now.to_date + 1.day) # more than 1 day away
    #  diff_in_days = ((ending_soon.end_date - Time.now.to_date).to_i / 1.day)
    #  days_string = diff_in_days.to_s
    #  days_string += (diff_in_days > 1) ? ' Days' : ' Day'
    #  return days_string
    #else # ending today
    #  diff_in_HMS = Time.at(ending_soon.end_date - Time.now.to_date).gmtime.strftime('%R:%S')
    #  return diff_in_HMS
    #end
    if ending_soon.end_date < Date.today
      return 'Ended'
    elsif ending_soon.end_date == Date.today
      return 'Ending Today'
    else
      return ((ending_soon.end_date - Date.today).to_i)

    end
  end
end
