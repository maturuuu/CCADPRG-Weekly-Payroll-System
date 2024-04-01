def displayMainMenu
  puts "MAIN MENU ----------------"
  puts "[1] : Calculate weekly pay"
  puts "[2] : Update default configuration"
  puts "[3] : Exit program"
  puts "--------------------------"
  print "What would you like to do? => "
end

def getTimeOut
  timeOut = []
  dayCount = 1

  puts "\n--------------------------"
  puts "Please enter time out in military time (HHMM) format\n\n"
  7.times do
    print "Time out for day #{dayCount} => "
    timeOut.push(gets.chomp.to_i)
    dayCount+=1
  end

  return timeOut
end

# Defaults and other variables

timeOut = []

# Main program starts here -------------------------------------------

puts "\nWelcome to the weekly payroll calculator powered by Ruby!\n\n"
loop do
  displayMainMenu
  choice = gets.chomp.to_i

  case choice
  when 1
    # Get input
    timeOut = getTimeOut
    timeOut.each { |x| puts x}
    # Calculate weekly pay
    # Output breakdown
  when 2
    # Update default configuration
  when 3
    puts "Exiting program..."
    break
  else
    puts "Invalid choice, please input a number from 1 to 3\n\n"
  end
end
