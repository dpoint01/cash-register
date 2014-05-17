require 'csv'

# !!!!!!! Delete current_orders.csv each time before running program !!!! #
# This programs read in orders from a CSV file and can process transactions
# and basically reproduces the behavior of a cash register.
# This program also spits out the processed orders on a seperate CSV file as it runs.
# (also works in command line)


#------------------------------------------------------#
#                                                      #
#                         METHODS                      #
#                                                      #
#------------------------------------------------------#

#----------------------INITALIZE ITEMS_HASH------------#

def items_hash_init

  items_array_hash =[]

  row_count =0

  CSV.foreach('products.csv', headers: true) do |row|
    row_count += 1

    items_hash = {}

    items_hash[:row] = row_count
    items_hash[:SKU] = row[0]
    items_hash[:name] = row[1]
    items_hash[:wholesale_price] = row[2]
    items_hash[:retail_price] = row[3]

    items_array_hash << items_hash

  end

    items_array_hash

end

#---------------------PRINT MENU--------------------#
def print_menu(items_array_hash)

    puts "Welcome to David's and John's coffee house\n\n"


    items_array_hash.each do |item|
      puts "#{item[:row]}) Add Item - $#{format_money(item[:retail_price])} - #{item[:name]}"
    end
    puts "#{items_array_hash.length+1}) Complete Sale\n\n"
end


#-----------------------FORMAT CHANGE-----------------#
def format_money(money)

  money_int = money.to_f

  if money.class == String
   sprintf("%.2f", money_int.abs)
  else
    sprintf("%.2f", money.abs)
  end

end

#-----------------MAKE A SELECTION---------------------#
def make_selection
  puts "Make a selection: "

  selection = gets.chomp.to_i

  if selection == 4
     sale_complete

     abort
  else

    puts "How many?"

    amount_wanted = gets.chomp.to_i

    selected = { selection: selection, amount_wanted: amount_wanted}

  end
end

#------------------------INITALIZE CURRENT CSV---------------#
def initalize_orders_csv

  File.open("current_orders.csv", "a+") do |f|
    f.puts "item_subtotal_price,amount_wanted,type_of_item"
  end
end

#----------------------CURRENT ORDER-------------------------#

def current_order_as_csv(selection_hash, items_array_hash)


    item_subtotal = items_array_hash[selection_hash[:selection] - 1][:retail_price].to_f * selection_hash[:amount_wanted]

    File.open("current_orders.csv", "a+") do |f|
      f.puts "#{item_subtotal},#{selection_hash[:amount_wanted]},#{items_array_hash[selection_hash[:selection] - 1][:name]}"
    end


    puts "Subtotal: $#{format_money(subtotal)}\n\n"

end

#------------------------SUBTOTAL---------------------------#

def subtotal

  subtotal = 0

  CSV.foreach('current_orders.csv', headers: true) do |row|
    subtotal += row["item_subtotal_price"].to_f
  end

  subtotal

end

#--------------------------SALE COMPLETE----------------------#

def sale_complete
  puts "===SALE COMPLETE===\n\n"

  CSV.foreach('current_orders.csv', headers: true) do |row|
    puts "$#{format_money(row["item_subtotal_price"])} - #{row["amount_wanted"]} #{row["type_of_item"]}"
  end

  puts "\nTotal: $#{format_money(subtotal)}\n"

  give_change(get_amount_tendered, subtotal)

end


#-------------------------PRINT RECIEPT------------------#
def print_receipt(change)

  puts %/
===Thank You!===
The total change due is $#{format_money(change)}

#{Time.now.strftime("%m/%d/%Y %I:%M%p")}
================
  /
end

#------------------------WARNING MESSAGE-------------------#
def print_warning(change)
  puts "WARNING: Customer still owes $#{format_money(change)}! Exiting..."
end

#---------------------GET AMOUNT TENDERED-------------------#

def get_amount_tendered
  puts "What is the amount tendered?"
  amount_given = gets.chomp.to_f
end

#----------------------GIVE CHANGE---------------------------#

def give_change(amount_tendered, subtotal)
  total = subtotal
  change = format_money(amount_tendered - total)

  if total < amount_tendered
    print_receipt(change)
  else
   print_warning(change)
  end

end




#-------------------------------------------------------------#
#                                                             #
#                              MAIN                           #
#                                                             #
#-------------------------------------------------------------#

#only initalize file if it doesn't already exist
initalize_orders_csv if !File.exists?("current_orders.csv")

initial = items_hash_init

print_menu(initial)

 while true
  current_order_as_csv(make_selection, initial)
 end




