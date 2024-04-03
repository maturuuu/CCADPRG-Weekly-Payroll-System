def setDefaults (dailySalary=500,
                maxRegHours=8.0,
                dayType = ['n', 'n', 'n', 'n', 'n', 'r', 'r'],
                timeIn = Array.new(7, "0930"),
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

  #separate hoursArr into categories and add to $dayBreakdown

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

setDefaults()

# Main program starts here -------------------------------------------

puts "\nWelcome to the weekly payroll calculator powered by Ruby!\n\n"
loop do
  displayMainMenu()
  choice = gets.chomp.to_i

  case choice
  when 1
    # Get input
    $timeOut = getTimeOut()

    # Calculate weekly pay
    calcHours($timeIn, $timeOut)

    # Output breakdown
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
