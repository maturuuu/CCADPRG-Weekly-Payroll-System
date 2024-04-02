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

# Defaults and other variables

$dailySalary = nil # default
$maxRegHours = nil # default
$hourlySalary = nil
$dayType = nil # default
$timeIn = nil # default; make timeInInt with .to_i for calculations
$timeOut = nil # input; make timeOutInt with .to_i for calculations

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
