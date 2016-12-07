module ApplicationHelper


	def us_states
    [
      ['Alabama', 'AL'],
      ['Alaska', 'AK'],
      ['Arizona', 'AZ'],
      ['Arkansas', 'AR'],
      ['California', 'CA'],
      ['Colorado', 'CO'],
      ['Connecticut', 'CT'],
      ['Delaware', 'DE'],
      ['District of Columbia', 'DC'],
      ['Florida', 'FL'],
      ['Georgia', 'GA'],
      ['Hawaii', 'HI'],
      ['Idaho', 'ID'],
      ['Illinois', 'IL'],
      ['Indiana', 'IN'],
      ['Iowa', 'IA'],
      ['Kansas', 'KS'],
      ['Kentucky', 'KY'],
      ['Louisiana', 'LA'],
      ['Maine', 'ME'],
      ['Maryland', 'MD'],
      ['Massachusetts', 'MA'],
      ['Michigan', 'MI'],
      ['Minnesota', 'MN'],
      ['Mississippi', 'MS'],
      ['Missouri', 'MO'],
      ['Montana', 'MT'],
      ['Nebraska', 'NE'],
      ['Nevada', 'NV'],
      ['New Hampshire', 'NH'],
      ['New Jersey', 'NJ'],
      ['New Mexico', 'NM'],
      ['New York', 'NY'],
      ['North Carolina', 'NC'],
      ['North Dakota', 'ND'],
      ['Ohio', 'OH'],
      ['Oklahoma', 'OK'],
      ['Oregon', 'OR'],
      ['Pennsylvania', 'PA'],
      ['Puerto Rico', 'PR'],
      ['Rhode Island', 'RI'],
      ['South Carolina', 'SC'],
      ['South Dakota', 'SD'],
      ['Tennessee', 'TN'],
      ['Texas', 'TX'],
      ['Utah', 'UT'],
      ['Vermont', 'VT'],
      ['Virginia', 'VA'],
      ['Washington', 'WA'],
      ['West Virginia', 'WV'],
      ['Wisconsin', 'WI'],
      ['Wyoming', 'WY']
    ]
	end

    def lane_timeslots(date)
      if date.monday?
        []
      elsif date.saturday?
        [
          Date.today + 9.hours,
          Date.today + 9.hours + 30.minutes,
          Date.today + 10.hours,
          Date.today + 10.hours + 30.minutes,
          Date.today + 11.hours,
          Date.today + 11.hours + 30.minutes,
          Date.today + 12.hours,
          Date.today + 12.hours + 30.minutes,
          Date.today + 13.hours,
          Date.today + 13.hours + 30.minutes,
          Date.today + 14.hours,
          Date.today + 14.hours + 30.minutes,
          Date.today + 15.hours,
          Date.today + 15.hours + 30.minutes,
          Date.today + 16.hours
        ]
      elsif date.sunday?
        [
          Date.today + 10.hours,
          Date.today + 10.hours + 30.minutes,
          Date.today + 11.hours,
          Date.today + 11.hours + 30.minutes,
          Date.today + 12.hours,
          Date.today + 12.hours + 30.minutes,
          Date.today + 13.hours,
          Date.today + 13.hours + 30.minutes,
          Date.today + 14.hours,
          Date.today + 14.hours + 30.minutes,
          Date.today + 15.hours
        ]
      else
        [
          Date.today + 10.hours,
          Date.today + 10.hours + 30.minutes,
          Date.today + 11.hours,
          Date.today + 11.hours + 30.minutes,
          Date.today + 12.hours,
          Date.today + 12.hours + 30.minutes,
          Date.today + 13.hours,
          Date.today + 13.hours + 30.minutes,
          Date.today + 14.hours,
          Date.today + 14.hours + 30.minutes,
          Date.today + 15.hours,
          Date.today + 15.hours + 30.minutes,
          Date.today + 16.hours,
          Date.today + 16.hours + 30.minutes,
          Date.today + 17.hours,
          Date.today + 17.hours + 30.minutes,
          Date.today + 18.hours,
          Date.today + 18.hours + 30.minutes,
          Date.today + 19.hours
        ]
      end
    end

end
