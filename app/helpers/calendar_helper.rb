# The Calendar Helper methods create HTML code for different variants of the
# Dynarch DHTML/JavaScript Calendar.
#
# Author: Michael Schuerig, <a
# href="mailto:michael@schuerig.de">michael@schuerig.de</a>, 2005
# Free for all uses. No warranty or anything. Comments welcome.
#
# Version 0.02:
# Always set calendar_options's ifFormat value to '%Y/%m/%d %H:%M:%S'
# so that the calendar recieves the object's time of day.  Previously,
# the '%c' formating used to set the initial date would be parsed by
# the JavaScript calendar correctly to find the date, but it would not
# pick up the time of day.
#
# Version 0.01:
# Original version by Michael Schuerig.
#
#
#
#
# == Prerequisites
#
# Get the latest version of the calendar package from
# <a
# href="http://www.dynarch.com/projects/calendar/">http://www.dynarch.com/projects/calendar/</a>
#
# == Installation
#
# You need to install at least these files from the jscalendar distribution
# in the +public+ directory of your project
#
#  public/
#      images/
#          calendar.gif [copied from img.gif]
#      javascripts/
#          calendar.js
#          calendar-setup.js
#          calendar-en.js
#      stylesheets/
#          calendar-system.css
#
# Then, in the head section of your page templates, possibly in a layout,
# include the necessary files like this:
#
#  <%= stylesheet_link_tag 'calendar-system.css' %>
#  <%= javascript_include_tag 'calendar', 'calendar-en', 'calendar-setup' %>
#
# == Common Options
#
# The +html_options+ argument is passed through mostly verbatim to the
# +text_field+, +hidden_field+, and +image_tag+ helpers.
# The +title+ attributes are handled specially, +field_title+ and
# +button_title+ appear only on the respective elements as +title+.
#
# The +calendar_options+ argument accepts all the options of the
# JavaScript +Calendar.setup+ method defined in +calendar-setup.js+.
# The ifFormat option for +Calendar.setup+ is set up with a default
# value that sets the calendar's date and time to the object's value,
# so only set it if you need to send less specific times to the
# calendar, such as not setting the number of seconds.
#
#
#
module CalendarHelper

  # Returns HTML code for a calendar that pops up when the calendar image is
  # clicked.
  #
  # _Example:_
  #
  #  <%= popup_calendar 'person', 'birthday',
  #        { :class => 'date',
  #          :field_title => 'Birthday',
  #          :button_title => 'Show calendar' },
  #        { :firstDay => 1,
  #          :range => [1920, 1990],
  #          :step => 1,
  #          :showOthers => true,
  #          :cache => true }
  #  %>
  #
  def popup_calendar(object, method, html_options = {}, calendar_options = {})
    _calendar(object, method, false, true, html_options, calendar_options)
  end

  # Returns HTML code for a flat calendar.
  #
  # _Example:_
  #
  #  <%= calendar 'person', 'birthday',
  #        { :class => 'date' },
  #        { :firstDay => 1,
  #          :range => [1920, 1990],
  #          :step => 1,
  #          :showOthers => true }
  #  %>
  #
  def calendar(object, method, html_options = {}, calendar_options = {})
    _calendar(object, method, false, false, html_options, calendar_options)
  end

  # Returns HTML code for a date field and calendar that pops up when the
  # calendar image is clicked.
  #
  # _Example:_
  #
  #  <%= calendar_field 'person', 'birthday',
  #        { :class => 'date',
  #          :field_title => 'Birthday',
  #          :button_title => 'Show calendar' },
  #        { :firstDay => 1,
  #          :range => [1920, 1990],
  #          :step => 1,
  #          :showOthers => true,
  #          :cache => true }
  #  %>
  #
  def calendar_field(object, method, html_options = {}, calendar_options = {})
    _calendar(object, method, true, true, html_options, calendar_options)
  end

  private

  def _calendar(object, method, show_field = true, popup = true, html_options = {}, calendar_options = {})
    button_image = html_options[:button_image] || 'calendar'
    date = value(object, method)

    input_field_id = "#{object}_#{method}" 
    calendar_id = "#{object}_#{method}_calendar" 

    add_defaults(calendar_options, :ifFormat => '%Y/%m/%d %H:%M:%S')

    field_options = html_options.dup
    add_defaults(field_options,
      :value => date && date.strftime(calendar_options[:ifFormat]),
      :size => 12
    )
    rename_option(field_options, :field_title, :title)
    remove_option(field_options, :button_title)
    if show_field
      field = text_field(object, method, field_options)
    else
      field = hidden_field(object, method, field_options)
    end

    if popup
      button_options = html_options.dup
      add_mandatories(button_options, :id => calendar_id)
      rename_option(button_options, :button_title, :title)
      remove_option(button_options, :field_title)
      calendar = image_tag(button_image, button_options)
    else
      calendar = "<div id=\"#{calendar_id}\" class=\"#{html_options[:class]}\"></div>" 
    end

    calendar_setup = calendar_options.dup
    add_mandatories(calendar_setup,
      :inputField => input_field_id,
      (popup ? :button : :flat) => calendar_id
    )

<<END
#{field}
#{calendar}
<script type="text/javascript">
  Calendar.setup({ #{format_js_hash(calendar_setup)} })
</script>
END
  end

  def value(object_name, method_name)
    if object = self.instance_variable_get("@#{object_name}")
      object.send(method_name)
    else
      nil
    end
  end

  def add_mandatories(options, mandatories)
    options.merge!(mandatories)
  end

  def add_defaults(options, defaults)
    options.merge!(defaults) { |key, old_val, new_val| old_val }
  end

  def remove_option(options, key)
    options.delete(key)
  end

  def rename_option(options, old_key, new_key)
    if options.has_key?(old_key)
      options[new_key] = options.delete(old_key)
    end
    options
  end

  def format_js_hash(options)
    options.collect { |key,value| key.to_s + ':' + value.inspect }.join(',')
  end


# CalendarHelper allows you to draw a databound calendar with fine-grained CSS formatting
#
# Screw the license.

#module CalendarHelper
  # Returns an HTML calendar. In its simplest form, this method generates a plain
  # calendar (which can then be customized using CSS) for a given month and year.
  # However, this may be customized in a variety of ways -- changing the default CSS
  # classes, generating the individual day entries yourself, and so on.
  # 
  # The following options are required:
  #  :year  # The  year number to show the calendar for.
  #  :month # The month number to show the calendar for.
  # 
  # The following are optional, available for customizing the default behaviour:
  #   :table_class       => "calendar"        # The class for the <table> tag.
  #   :month_name_class  => "monthName"       # The class for the name of the month, at the top of the table.
  #   :other_month_class => "otherMonthClass" # Not implemented yet.
  #   :day_name_class    => "dayName"         # The class is for the names of the weekdays, at the top.
  #   :day_class         => "day"             # The class for the individual day number cells.
  #                                             This may or may not be used if you specify a block (see below).
  #   :abbrev            => (0..2)            # This option specifies how the day names should be abbreviated.
  #                                             Use (0..2) for the first three letters, (0..0) for the first, and
  #                                             (0..-1) for the entire name.
  # 
  # For more customization, you can pass a code block to this method, that will get one argument, a Date object,
  # and return a values for the individual table cells. The block can return an array, [cell_text, cell_attrs],
  # cell_text being the text that is displayed and cell_attrs a hash containing the attributes for the <td> tag
  # (this can be used to change the <td>'s class for customization with CSS).
  # This block can also return the cell_text only, in which case the <td>'s class defaults to the value given in
  # +:day_class+. If the block returns nil, the default options are used.
  # 
  # Example usage:
  #   calendar(:year => 2005, :month => 6) # This generates the simplest possible calendar.
  #   calendar({:year => 2005, :month => 6, :table_class => "calendar_helper"}) # This generates a calendar, as
  #                                                                             # before, but the <table>'s class
  #                                                                             # is set to "calendar_helper".
  #   calendar(:year => 2005, :month => 6, :abbrev => (0..-1)) # This generates a simple calendar but shows the
  #                                                            # entire day name ("Sunday", "Monday", etc.) instead
  #                                                            # of only the first three letters.
  #   calendar(:year => 2005, :month => 5) do |d| # This generates a simple calendar, but gives special days
  #     if listOfSpecialDays.include?(d)          # (days that are in the array listOfSpecialDays) one CSS class,
  #       [d.mday, {:class => "specialDay"}]      # "specialDay", and gives the rest of the days another CSS class,
  #     else                                      # "normalDay". You can also use this highlight today differently
  #       [d.mday, {:class => "normalDay"}]       # from the rest of the days, etc.
  #   end
  def calendar2(options = {}, &block)
    raise ArgumentError, "No year given"  unless defined? options[:year]
    raise ArgumentError, "No month given" unless defined? options[:month]

    block                        ||= Proc.new {|d| nil}
    options[:table_class       ] ||= "calendar"
    options[:month_name_class  ] ||= "monthName"
    options[:other_month_class ] ||= "otherMonth"
    options[:day_name_class    ] ||= "dayName"
    options[:day_class         ] ||= "day"
    options[:abbrev            ] ||= (0..2)

    first = Date.civil(options[:year], options[:month], 1)
    last = Date.civil(options[:year], options[:month], -1)

    cal = <<EOF
<table class="#{options[:table_class]}">
	<thead>
		<tr class="#{options[:month_name_class]}">
			<th colspan="7">#{Date::MONTHNAMES[options[:month]]}</th>
		</tr>
		<tr class="#{options[:day_name_class]}">
EOF
    Date::DAYNAMES.each {|d| cal << "			<th>#{d[options[:abbrev]]}</th>"}
    cal << "		</tr>
	</thead>
	<tbody>
		<tr>"
    0.upto(first.wday - 1) {|d| cal << "			<td class='#{options[:other_month_class]}'></td>"} unless first.wday == 0
    first.upto(last) do |cur|
      cell_text, cell_attrs = block.call(cur)
      cell_text  ||= cur.mday
      cell_attrs ||= {:class => options[:day_class]}
      cell_attrs = cell_attrs.map {|k, v| "#{k}='#{v}'"}.join(' ')
      cal << "			<td #{cell_attrs}>#{cell_text}</td>"
      cal << "		</tr>\n		<tr>" if cur.wday == 6
    end
    last.wday.upto(5) {|d| cal << "			<td class='#{options[:other_month_class]}'></td>"} unless last.wday == 6
    cal << "		</tr>\n	</tbody>\n</table>"
  end

end




