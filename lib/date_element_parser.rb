class DateElementParser
  def self.parse(date_element)
    if data_time_attr = date_element.attr('data-time')
      unix_time = data_time_attr.value.to_i
      return Time.at(unix_time).to_datetime
    else
      text = change_month_to_en(date_element.text)
      return Chronic.parse text
    end
  end

  def self.change_month_to_en(str)
    # really only need some of these
    dict = {ene: 'january',
            abr: 'april',
            ago: 'august',
            set: 'september',
            dic: 'december'
    }
    dict.each do |k, v|
      if month = str.match(/#{k.to_s}/i)
        puts 'changed month: ' + month.to_s
        return str.gsub month.to_s, v
      end
    end
    return str
  end
end
