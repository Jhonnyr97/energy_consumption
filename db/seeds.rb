# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   # end

# Create a default user
user = User.find_or_create_by!(email: "test@example.com") do |u|
  u.name = SecureRandom.hex(4)


  u.password = "password"
  u.password_confirmation = "password"
end

# Clear existing consumptions for the user to ensure idempotency
user.consumptions.destroy_all

# Generate consumptions for the last 12 months
(0..11).each do |month_offset|
  current_month = (Date.current - month_offset.months).beginning_of_month

  # Generate a few consumptions for each month
  rand(3..7).times do
    energy_type = Consumption.energy_types.keys.sample
    value = rand(50..300)
    unit = case energy_type
           when "electricity" then "kWh"
           when "gas" then "m³"
           when "water" then "m³"
           end
    measured_at = current_month + rand(0..27).days + rand(0..23).hours

    Consumption.create!(
      user: user,
      energy_type: energy_type,
      value: value,
      unit: unit,
      measured_at: measured_at
    )
  end
end

puts "Generated #{user.consumptions.count} consumptions for user #{user.email}"
