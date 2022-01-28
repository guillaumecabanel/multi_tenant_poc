Rails.application.console do
  puts "Do you want to connect to a DB?"
  puts "0 - nope! (or enter)"
  Tenant.each.with_index(1) do |tenant, index|
    puts "#{index} - #{tenant.name}"
  end
  puts "Which one?\n"
  print ">_"
  choosen = gets.chomp.to_i - 1
  puts "\n"
  if choosen.between?(0, Tenant.count - 1)
    Current.tenant = Tenant.all[choosen]
    Current.tenant.set_as_default_connection!
  else
    puts "no connection set"
  end
  puts "\n"
end
