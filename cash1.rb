# prompt user for amount due
def get_amount_due
  puts "What is the amount due?"
  gets.chomp.to_f
end

# prompt user for amount given
def get_amount_given
  puts "What is the amount tendered?"
  gets.chomp.to_f
end

def difference(amount_due, amount_given)
  amount_given - amount_due
end

def calculation
  difference(get_amount_due, get_amount_given)
end

def format_change(change)
  absolute_change = change.abs
  sprintf("%.2f", absolute_change)
end

def print_receipt(change)
  puts %/
===Thank You!===
The total change due is $#{format_change(change)}

#{Time.now.strftime("%m/%d/%Y %I:%M%p")}
================
  /
end

def warning(change)
  puts "WARNING: Customer still owes $#{format_change(change)}! Exiting..."
end

#----------------------------------------------------------------#
#                                                                #
#                                MAIN                            #
#                                                                #
#----------------------------------------------------------------#

change = calculation

# check if amount given is > amount due
if change > 0
  # if amount given is !< amount due
  # output recipet
  print_receipt(change)
else
  # if amount given is < amount due
  # output warning
  warning(change)
end
