def setDefaults (dailySalary=500,
                maxRegHours=8.0,
                dayType = ['n', 'n', 'r', 's', 'sr', 'h', 'hr'],
                timeIn = Array.new(7, "0900"),
                timeOut = Array.new(7, "0900"))
  $dailySalary = dailySalary
  $maxRegHours = maxRegHours.to_f
  $hourlySalary = dailySalary/maxRegHours
  $dayType = dayType.dup
  $timeIn = timeIn.dup
  $timeOut = timeOut.dup
end

def displayMainMenu
  puts "MAIN MENU --------------------------"
  puts "[1] : Calculate weekly pay"
  puts "[2] : Update default configuration"
  puts "[3] : Exit program"
  puts "------------------------------------"
  print "What would you like to do? => "
end

def getTimeOut
  thisTimeOut = []
  dayCount = 1

  puts "\n----------------------------------"
  puts "Please enter time out (HHMM): \n\n"
  7.times do
    print "Time out for day #{dayCount} => "
    entry = gets.chomp


    while entry.length != 4
      print "\n"
      puts "Invalid time out, please enter in HHMM (4-digit) format"
      print "Time out for day #{dayCount} => "
      entry = gets.chomp
    end

    thisTimeOut.push(entry)
    dayCount+=1
  end

  return thisTimeOut
end

def calcHours (timeIn, timeOut, maxRegHours)
  hoursArr = Array.new(7){[]}
  dayIndex = 0

  7.times do # assign each hour of each day to the 2d array hoursArr

    currentTime = timeIn[dayIndex].to_i

    if currentTime == timeOut[dayIndex].to_i
      hoursArr[dayIndex] << "absent"

    else
      while currentTime != timeOut[dayIndex].to_i do
        hoursArr[dayIndex] << currentTime

        currentTime += 100
        if currentTime == 2400
          currentTime = 0
        elsif currentTime > 2400
          currentTime -= 2400
        end
      end
    end

  dayIndex+=1
  end

  regHours = Array.new(7, -1)
  regHoursNight = Array.new(7, 0)
  otHours = Array.new(7, 0)
  otHoursNight = Array.new(7, 0)
  dayIndex = 0

  hoursArr.each do |row| # separate hoursArr into categories and add to $dayBreakdown
    hourIndex = 0

    if row[0] == "absent"
      if $dayType[dayIndex] != "n"
        regHours[dayIndex] = "Rest"
      else
        regHours[dayIndex] = 0
      end
    else
      ((maxRegHours+1).to_i).times do # regular hours
        regHours[dayIndex]+=1
        if row[hourIndex] >= 2200 || row[hourIndex] < 600
          regHoursNight[dayIndex]+=1
        end
        hourIndex+=1
      end

      if row.length > hourIndex # overtime hours (dayIndex = 0, hourIndex = 9)
        for x in hourIndex...row.length
          if row[x] >= 2200 || row[x] < 600
            otHoursNight[dayIndex]+=1
          else
            otHours[dayIndex]+=1
          end
        end
      end
    end

    dayIndex+=1
  end

  $dayBreakdown = [regHours, regHoursNight, otHours, otHoursNight] #update $dayBreakdown

  #debugging
  # puts ""
  # puts "DEBUGGING -----------------------------------------"
  # print hoursArr[0]
  # puts ""
  # regHours.each { |x|
  #   print x
  # }
  # puts ""
  # regHoursNight.each { |x|
  #   print x
  # }
  # puts ""
  # otHours.each { |x|
  #   print x
  # }
  # puts ""
  # otHoursNight.each { |x|
  #   print x
  # }
  # puts ""
  # puts $dayBreakdown.inspect
  # puts ""

end

def calcPayroll (dayBreakdown, dayType, hourlySalary)
  dayTotal = Array.new(7, 0)

  dayBreakdown = dayBreakdown.transpose

  dayCtr = 0
  dayBreakdown.each { |day| # calculates regular hours pay

    if day[0] == "Rest"
      dayTotal[dayCtr] = $dailySalary.to_f

    else
      case dayType[dayCtr]
        when 'n' then dayTotal[dayCtr] += day[0] * hourlySalary
        when 'r' then dayTotal[dayCtr] += day[0] * hourlySalary * 1.3
        when 's' then dayTotal[dayCtr] += day[0] * hourlySalary * 1.3
        when 'sr' then dayTotal[dayCtr] += day[0] * hourlySalary * 1.5
        when 'h' then dayTotal[dayCtr] += day[0] * hourlySalary * 2.0
        when 'hr' then dayTotal[dayCtr] += day[0] * hourlySalary * 2.6
        else puts "Error -> dayType for #{dayCtr} has no value"
      end

      case dayType[dayCtr]  # calculates regular night shift hours pay
        when 'n' then dayTotal[dayCtr] += day[1] * hourlySalary * 0.10
        when 'r' then dayTotal[dayCtr] += day[1] * hourlySalary * 0.10 * 1.3
        when 's' then dayTotal[dayCtr] += day[1] * hourlySalary * 0.10 * 1.3
        when 'sr' then dayTotal[dayCtr] += day[1] * hourlySalary * 0.10 * 1.5
        when 'h' then dayTotal[dayCtr] += day[1] * hourlySalary * 0.10 * 2.0
        when 'hr' then dayTotal[dayCtr] += day[1] * hourlySalary * 0.10 * 2.6
        else puts "Error -> dayType for #{dayCtr} has no value"
      end

      case dayType[dayCtr] # calculates overtime hours pay
        when 'n' then dayTotal[dayCtr] += day[2] * hourlySalary * 1.25
        when 'r' then dayTotal[dayCtr] += day[2] * hourlySalary * 1.69
        when 's' then dayTotal[dayCtr] += day[2] * hourlySalary * 1.69
        when 'sr' then dayTotal[dayCtr] += day[2] * hourlySalary * 1.95
        when 'h' then dayTotal[dayCtr] += day[2] * hourlySalary * 2.60
        when 'hr' then dayTotal[dayCtr] += day[2] * hourlySalary * 3.38
        else puts "Error -> dayType for #{dayCtr} has no value"
      end

      case dayType[dayCtr] # calculates overtime night shift hours pay
        when 'n' then dayTotal[dayCtr] += day[3] * hourlySalary * 1.375
        when 'r' then dayTotal[dayCtr] += day[3] * hourlySalary * 1.859
        when 's' then dayTotal[dayCtr] += day[3] * hourlySalary * 1.859
        when 'sr' then dayTotal[dayCtr] += day[3] * hourlySalary * 2.145
        when 'h' then dayTotal[dayCtr] += day[3] * hourlySalary * 2.86
        when 'hr' then dayTotal[dayCtr] += day[3] * hourlySalary * 3.718
        else puts "Error -> dayType for #{dayCtr} has no value"
      end
    end

    dayCtr+=1
  }

  return dayTotal
end

def printPayroll (timeIn, timeOut, dayBreakdown, dayType, dailySalary, totalPerDay)
  dayBreakdown = dayBreakdown.transpose
  width = 60;

  puts "\n"
  puts "============================================================"
  puts "|                     WEEKLY PAYROLL                       |"
  puts "============================================================"

  dayCtr = 0
  dayBreakdown.each { |day|
  puts "============================================================"
  print "| DAY #{dayCtr+1} : "
  dayTypeStr = nil
  case dayType[dayCtr]
    when 'n' then dayTypeStr = "Regular day"
    when 'r' then dayTypeStr = "Rest day"
    when 's' then dayTypeStr = "Special non-working day"
    when 'sr' then dayTypeStr = "Special non-working day and Rest day"
    when 'h' then dayTypeStr = "Regular holiday"
    when 'hr' then dayTypeStr = "Regular holiday and Rest day"
    else dayTypeStr = "No day type assigned"
  end
  puts "#{dayTypeStr} |".rjust(width-10, " ")
  puts "|----------------------------------------------------------|"

  print "| Daily rate"
  puts "PHP #{(dailySalary.to_f).round(2)} |".rjust(width-12, " ")

  print "| Time IN"
  timeStr = nil
  if day[0] == "Rest"
    timeStr = "(#{timeIn[dayCtr]}) Rest"
  elsif day[0] == 0
    timeStr = "(#{timeIn[dayCtr]}) Absent"
  else
    timeStr = timeIn[dayCtr]
  end
  puts "#{timeStr} |".rjust(width-9)

  print "| Time OUT"
  timeStr = nil
  if day[0] == "Rest"
    timeStr = "Rest"
  elsif day[0] == 0
    timeStr = "Absent"
  else
    timeStr = timeOut[dayCtr]
  end
  puts "#{timeStr} |".rjust(width-10)

  if day[0] != 0 && day[0] != "Rest"
    print "| Regular hours"
    puts "#{day[0]} hrs + 1 hr break |".rjust(width-15)
  end

  if day[1] != 0
    print "| Regular hours on night shift"
    puts "#{day[1]} hrs |".rjust(width-30)
  end

  if day[2] != 0
    print "| Overtime hours on regular shift"
    puts "#{day[2]} hrs |".rjust(width-33)
  end

  if day[3] != 0
    print "| Overtime hours on night shift"
    puts "#{day[3]} hrs |".rjust(width-31)
  end

  puts "|----------------------------------------------------------|"
  print "| Total pay for DAY #{dayCtr+1}:"
  puts "PHP #{totalPerDay[dayCtr]} |".rjust(width-22)
  puts "============================================================\n"

  dayCtr+=1
  }

  puts "\n"

end

# Defaults and other global variables ---------------------------------------

$dailySalary = nil # default
$maxRegHours = nil # default
$hourlySalary = nil
$dayType = nil # default
$timeIn = nil # default; make timeInInt with .to_i for calculations
$timeOut = nil # input; make timeOutInt with .to_i for calculations
$dayBreakdown = nil # 2d array to store each day's breakdown:
                    # [reg hours]
                    # [reg hours (night shift)]
                    # [overtime hours]
                    # [overtime hours (night shift)]

setDefaults() # initializes default values

# Main program starts here -------------------------------------------

puts "\nWelcome to the weekly payroll calculator powered by Ruby!\n\n"
loop do
  displayMainMenu()
  choice = gets.chomp.to_i

  case choice
  when 1
    $timeOut = getTimeOut() # Get input

    calcHours($timeIn, $timeOut, $maxRegHours) # Build the day breakdown

    totalPerDay = calcPayroll($dayBreakdown, $dayType, $hourlySalary) # Calculate payroll

    #debugging
    # puts ""
    # puts "DEBUGGING -----------------------------------------"
    # totalPerDay.each { |x|
    #   print "#{x.round(2)} "
    # }
    # puts "\n\n"

    printPayroll($timeIn, $timeOut, $dayBreakdown, $dayType, $dailySalary, totalPerDay) # Display results

  when 2
    # Update configuration
  when 3
    puts "Exiting program..."
    break
  else
    puts "Invalid choice, please input a number from 1 to 3\n\n"
  end
end


# NOTES --------------------------------------------
# Per day:
    # Calculate first 9 hours (8 work hours + 1 unpaid break hour)
    #   - what type of day?
    #   - are there hours that go into night shift?
    # Calculate overtime
    #   - how many hours of overtime?
    #   - how many of those hours are night shift?
    #   - what type of day?

# Calculating the hours:
    # 1. Add all hours of each day into a 2d array (rows = days)
    # Per day:
    #   - add current time to array
    #   - increment and reset if needed
    #   - repeat until time out is reached
    # 2. Separate the hours into categories and add to $dayBreakdown
    # Per day:
    #   - first 9 elements = 8 hour regular / regular night
    #   - the rest = overtime / overtime night
    # 3. Calculate weekly salary based on $dayBreakdown and dayType
    #
    # Fix later - if not regular day, can enter timeOut same as timeIn
    # and it will still pay.
# Print daily and weekly salary
# Update default configuration function
# DONEZO
