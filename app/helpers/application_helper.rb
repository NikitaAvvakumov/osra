module ApplicationHelper
  FULL_DATE_FORMAT_STRING= '%d %B %Y'
  MONTH_YEAR_DATE_FORMAT_STRING= '%m/%Y'
  PRIORITY_COUNTRIES= %w(SA TR AE GB)
  EXCLUDED_COUNTRYS= %w(IL)

  def format_full_date(date)
    (date || NullDate.new).strftime(FULL_DATE_FORMAT_STRING)
  end

  def format_month_year_date(date)
    (date || NullDate.new).strftime(MONTH_YEAR_DATE_FORMAT_STRING)
  end

  def country_select_list
    temp_list= []
    select_list= ISO3166::Country.all.map {|c| [ en_ar_country(c[1]), c[1] ] }

    select_list.reject! do |country| 
      EXCLUDED_COUNTRYS.any? {|excluded| excluded == country[1] }
    end

    PRIORITY_COUNTRIES.each do |priority|
      select_list.each_with_index do |v,k|
        if !v.nil? and priority == v[1]
          temp_list << v
          select_list[k]= nil
        end
      end
    end
    # temp_list = select_list.reject! {|country| PRIORITY_COUNTRIES.any? {|priority| priority == country[1]} }

    temp_list << ['-----------------------------------------', '']
    temp_list.concat(select_list.compact)
  end

end
