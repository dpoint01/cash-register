#second version of cash register
# by David Pointeau

#----------------------------------------------------#
#                       METHODS                      #
#----------------------------------------------------#

#-----------------------SUB_TOTAL--------------------#
def sub_total(item, array)

  #adds all elements of the array
  subtotal = array.inject(:+) ;puts

  puts "Subtotal: $#{format_change(subtotal)}"

end

#-----------------------FORMAT CHANGE-----------------#
def format_change(change)
  absolute_change = change.abs
  sprintf("%.2f", absolute_change)
end

#------------------------PRINT_ARRAY-------------------#

def print_array(array)

  #have to delete last element 0 because of done
  array.delete_if{|element| element == 0} ;puts

  #add every element of old array to new_array so total can be calculated
  new_array = array

  #print formatted
  puts "Here are your item prices: " ;puts
  puts array.map{ |element| "$" + format_change(element)} ;puts


  total(new_array)

end

#-------------------------TOTAL-------------------------#

def total(new_array)
  total = new_array.inject(:+)
  puts "The total amount due is $#{format_change(total)}"
end

#------------------------AMOUNT DUE----------------------#
def amount_due(array)
  total = array.inject(:+)
end

#-------------------------PRINT RECIEPT------------------#
def print_receipt(change)
  puts %/
===Thank You!===
The total change due is $#{format_change(change)}

#{Time.now.strftime("%m/%d/%Y %I:%M%p")}
================
  /
end

#------------------------WARNING MESSAGE-------------------#
def print_warning(change)
  puts "WARNING: Customer still owes $#{format_change(change)}! Exiting..."
end

#---------------------CALCULATION METHODS------------------#

def difference(amount_due, amount_given)
  amount_given - amount_due
end

def calculation(array, amount_given)
  difference(amount_due(array), amount_given)
end


#-----------------------------------------------------#
#                        MAIN                         #
#-----------------------------------------------------#

#prompt user for item price
puts "What is the sale price?"

#create an array to store each item
array = []

#create a variable to store each item (initalized to nil)
item = nil


#main loop to ask for user's input
while item != "done"
  item = gets.chomp
  array << item.to_f

  #because it loops one too much with "done"
  # since done was to_f'ed its value is 0.0
  if item.to_i != 0
    sub_total(item, array) ;puts
    puts "What is the sale price?"
  end
end

#print all the items
print_array(array) ;puts

#prompt user for the money
puts "What is the amount tendered?"
amount_given = gets.chomp.to_f

#calculate the change
change = calculation(array, amount_given)

if change > 0
  #if amount tendered is larger than the amount required
  print_receipt(change)
else
  #if amount tendered is smaller than the amount required
  print_warning(change)
end






