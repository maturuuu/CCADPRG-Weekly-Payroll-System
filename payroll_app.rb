def setDefaults (dailySalary=500,
                maxRegHours=8.0,
                dayType = ['n', 'n', 'n', 'n', 'n', 'r', 'r'],
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
  puts "MAIN MENU ----------------"
  puts "[1] : Calculate weekly pay"
  puts "[2] : Update default configuration"
  puts "[3] : Exit program"
  puts "--------------------------"
  print "What would you like to do? => "
end

def getTimeOut
  thisTimeOut = []
  dayCount = 1

  puts "\n--------------------------"
  puts "Please enter time out (HHMM): \n\n"
  7.times do
    print "Time out for day #{dayCount} => "
    thisTimeOut.push(gets.chomp)
    dayCount+=1
  end

  return thisTimeOut
end

def calcHours (timeIn, timeOut)
  hoursArr = Array.new(7){[]}
  dayIndex = 0

  7.times do # assign each hour of each day to the 2d array hoursArr

    currentTime = timeIn[dayIndex].to_i

    while currentTime != timeOut[dayIndex].to_i do
      hoursArr[dayIndex] << currentTime

      currentTime += 100
      if currentTime == 2400
        currentTime = 0
      elsif currentTime > 2400
        currentTime -= 2400
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

    9.times do # regular hours
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

    dayIndex+=1
  end

  $dayBreakdown = [regHours, regHoursNight, otHours, otHoursNight] #update $dayBreakdown

  #debugging
  puts ""
  puts "DEBUGGING -----------------------------------------"
  print hoursArr[0]
  puts ""
  regHours.each { |x|
    print x
  }
  puts ""
  regHoursNight.each { |x|
    print x
  }
  puts ""
  otHours.each { |x|
    print x
  }
  puts ""
  otHoursNight.each { |x|
    print x
  }
  puts ""
  puts $dayBreakdown.inspect
  puts "---------------------------------------------------"
  puts ""

end

def calcPayroll (dayBreakdown)

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

    calcHours($timeIn, $timeOut) # Build the day breakdown

    # Calculate payroll

    # Display results

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
