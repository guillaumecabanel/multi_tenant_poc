Rails.application.console do
  puts "\n#{Paint["Do you want to connect to a specific tenant?", :bold]} #{Paint["(press enter to skip)", :italic]}\n\n"
  Tenant.each.with_index(1) do |tenant, index|
    puts "#{index} - #{Paint[tenant.ansi_colored_name, :bold]}"
  end
  print "\n>_"
  choosen = gets.chomp.to_i - 1
  if choosen.between?(0, Tenant.count - 1)
    Current.tenant = Tenant.all[choosen]
    Current.tenant.connect!
  else
    puts Paint["\n\tno connection set", :bold]
  end
end
