namespace :demo do
  desc "Generate demo data for presentations"
  task generate: :environment do
    # Clear existing records to avoid duplicates
    puts "Clearing existing records..."
    Ticket.destroy_all
    Sale.destroy_all
    PrinterConfig.destroy_all
    User.destroy_all
    Location.destroy_all
    Organization.destroy_all
    
    puts "Generating demo data..."
    
    # Create organization
    organization = Organization.create!(
      name: "Trenes Rápidos de México",
      tax_id: "TRM123456789",
      contact_email: "contacto@trenesrapidos.mx",
      contact_phone: "55 1234 5678",
      address: "Av. Revolución 123, Col. Tabacalera, Ciudad de México",
      active: true,
      timezone: "America/Mexico_City"
    )
    
    puts "Created organization: #{organization.name}"
    
    # Mexican cities for locations
    mexican_cities = [
      {
        name: "Colima",
        address: "Terminal Colima, Av. de la Paz 123. Col. Centro",
        contact_name: "Romario Padilla",
        contact_phone: "31 2345 6789"
      },
      {
        name: "Ciudad de México",
        address: "Terminal Central, Av. Insurgentes Sur 123, Col. Roma",
        contact_name: "Miguel López",
        contact_phone: "55 1234 5678"
      },
      {
        name: "Guadalajara",
        address: "Estación Ferroviaria, Av. Vallarta 456, Col. Centro",
        contact_name: "Ana Ramírez",
        contact_phone: "33 2345 6789"
      },
      {
        name: "Monterrey",
        address: "Terminal Norte, Av. Universidad 789, Col. Tecnológico",
        contact_name: "Carlos Mendoza",
        contact_phone: "81 3456 7890"
      },
      {
        name: "Puebla",
        address: "Central de Autobuses, Blvd. Carmen Serdán 321, Col. Centro",
        contact_name: "Laura Torres",
        contact_phone: "22 4567 8901"
      },
      {
        name: "Querétaro",
        address: "Terminal Querétaro, Av. Constituyentes 654, Col. Reforma",
        contact_name: "Javier García",
        contact_phone: "44 5678 9012"
      },
      {
        name: "Mérida",
        address: "Terminal Oriente, Calle 60 987, Col. Centro",
        contact_name: "Sofia Hernández",
        contact_phone: "99 6789 0123"
      },
      {
        name: "Tijuana",
        address: "Estación Central, Av. Revolución 159, Col. Centro",
        contact_name: "Diego Morales",
        contact_phone: "66 7890 1234"
      },
      {
        name: "León",
        address: "Terminal León, Blvd. Adolfo López Mateos 753, Col. Industrial",
        contact_name: "Fernanda Guzmán",
        contact_phone: "47 8901 2345"
      },
      {
        name: "Cancún",
        address: "Terminal Turística, Av. Tulum 246, Zona Hotelera",
        contact_name: "Roberto Díaz",
        contact_phone: "99 9012 3456"
      },
      {
        name: "San Luis Potosí",
        address: "Estación Central, Av. Universidad 852, Col. Centro",
        contact_name: "Patricia Flores",
        contact_phone: "44 0123 4567"
      }
    ]
    
    locations = []
    mexican_cities.each do |city_data|
      location = organization.locations.create!(
        name: city_data[:name],
        address: city_data[:address],
        contact_name: city_data[:contact_name],
        contact_phone: city_data[:contact_phone],
        active: true
      )
      locations << location
      puts "Created location: #{location.name}"
      
      # Create printer configuration for each location
      printer = location.printer_configs.create!(
        name: "Impresora Principal #{location.name}",
        device_id: "PRINT#{location.id}-001",
        printer_type: "thermal",
        active: true
      )
      puts "  Added printer: #{printer.name}"
    end
    
    # Create owner user
    owner = User.create!(
      name: "Juan Pérez",
      email: "admin@trenesrapidos.mx",
      password: "password123",
      role: :owner,
      active: true,
      organization: organization,
      location: locations.first # Owner assigned to main location
    )
    puts "Created owner: #{owner.name}"
    
    # Create manager and cashiers for each location
    locations.each do |location|
      # Create manager
      manager = User.create!(
        name: "Gerente #{location.name}",
        email: "gerente.#{location.name.parameterize}@trenesrapidos.mx",
        password: "manager123",
        role: :manager,
        active: true,
        organization: organization,
        location: location
      )
      puts "Created manager for #{location.name}: #{manager.name}"
      
      # Create 2-3 cashiers per location
      cashier_count = rand(2..3)
      cashier_count.times do |i|
        cashier = User.create!(
          name: "Cajero #{i+1} #{location.name}",
          email: "cajero#{i+1}.#{location.name.parameterize}@trenesrapidos.mx",
          password: "cashier123",
          role: :cashier,
          active: true,
          organization: organization,
          location: location
        )
        puts "  Created cashier: #{cashier.name}"
      end
    end
    
    # Generate sales data
    puts "Generating sales data..."
    
    # Payment method distribution: 60% cash, 25% credit card, 10% debit card, 5% other
    payment_methods = {
      cash: 60,
      credit_card: 25,
      debit_card: 10,
      other: 5
    }
    
    # Passenger count distribution (based on realistic train passenger patterns)
    # Most tickets are for 1-2 passengers, fewer for larger groups
    passenger_counts = {
      1 => 60,  # 60% chance for single ticket
      2 => 25,  # 25% chance for 2 people
      3 => 10,  # 10% chance for 3 people
      4 => 3,   # 3% chance for 4 people
      5 => 2    # 2% chance for 5 people
    }
    
    # Hourly distribution (busier during morning and evening rush hours)
    hourly_weights = {
      5 => 2,   # 5am: low
      6 => 5,   # 6am: medium
      7 => 10,  # 7am: high (rush hour)
      8 => 12,  # 8am: peak (rush hour)
      9 => 8,   # 9am: high
      10 => 5,  # 10am: medium
      11 => 5,  # 11am: medium
      12 => 6,  # 12pm: medium-high (lunch)
      13 => 6,  # 1pm: medium-high (lunch)
      14 => 5,  # 2pm: medium
      15 => 5,  # 3pm: medium
      16 => 7,  # 4pm: high
      17 => 10, # 5pm: high (rush hour)
      18 => 12, # 6pm: peak (rush hour)
      19 => 8,  # 7pm: high
      20 => 6,  # 8pm: medium-high
      21 => 4,  # 9pm: medium-low
      22 => 2,  # 10pm: low
      23 => 1   # 11pm: very low
    }
    
    # Day of week distribution (busier on weekends and Fridays)
    daily_weights = {
      0 => 10,  # Sunday: high
      1 => 7,   # Monday: medium
      2 => 7,   # Tuesday: medium
      3 => 7,   # Wednesday: medium
      4 => 8,   # Thursday: medium-high
      5 => 12,  # Friday: peak
      6 => 11   # Saturday: high
    }
    
    # Generate sales for the past 3 months
    end_date = Date.today
    start_date = 3.months.ago.to_date
    total_sales = 0
    
    # Helper methods for weighted random selection
    def weighted_select(weights)
      total = weights.values.sum
      point = rand(total)
      
      weights.each do |item, weight|
        return item if point < weight
        point -= weight
      end
      
      # Fallback (shouldn't reach here)
      return weights.keys.first
    end
    
    def weighted_hour(weights)
      weighted_select(weights)
    end
    
    def weighted_payment_method(weights)
      weighted_select(weights)
    end
    
    def weighted_passenger_count(weights)
      weighted_select(weights)
    end
    
    # Amount model: base fare + per passenger fare
    def generate_amount(passenger_count, location_index)
      # Base fare varies slightly by location (more expensive in tourist areas)
      location_factor = 1.0 + (location_index * 0.03)
      
      # Base ticket price between 100-150 pesos
      base_fare = (100 + rand(50)) * location_factor
      
      # Add per-passenger fare (first passenger included in base fare)
      additional_passengers = [passenger_count - 1, 0].max
      per_passenger_fare = base_fare * 0.7  # 70% discount for additional passengers
      
      total = base_fare + (additional_passengers * per_passenger_fare)
      
      # Round to nearest 0.5 peso
      (total * 2).round / 2.0
    end
    
    # Get all users grouped by location for efficient lookup
    users_by_location = User.all.group_by(&:location_id)
    
    # Go through each day in the date range
    (start_date..end_date).each do |date|
      day_weight = daily_weights[date.wday]
      
      # Skip some weekdays randomly (less busy days might have zero sales at some locations)
      # But ensure we have data for most days
      next if rand(100) > 90 && date.wday.between?(1, 4) && date != Date.today
      
      # For each location
      locations.each_with_index do |location, location_index|
        # Skip some locations on certain days (smaller locations might not have daily sales)
        next if rand(100) > 95 && location_index > 5 && date != Date.today
        
        # Calculate number of sales for this location on this day
        # Busier locations (lower index) have more sales
        location_factor = 1.0 - (location_index * 0.05)
        daily_sales_count = (day_weight * location_factor * rand(0.8..1.2)).round
        
        # Get users for this location
        location_users = users_by_location[location.id]
        cashiers = location_users.select { |u| u.cashier? }
        
        # Generate sales throughout the day
        daily_sales_count.times do
          # Select hour based on weighted distribution
          hour = weighted_hour(hourly_weights)
          
          # Random minute and second
          minute = rand(60)
          second = rand(60)
          
          # Create timestamp
          timestamp = DateTime.new(date.year, date.month, date.day, hour, minute, second, organization.timezone)
          
          # Skip future timestamps
          next if timestamp > DateTime.now
          
          # Select cashier randomly from location's cashiers
          cashier = cashiers.sample
          
          # Select payment method based on weighted distribution
          payment_method = weighted_payment_method(payment_methods)
          
          # Select passenger count based on weighted distribution
          passenger_count = weighted_passenger_count(passenger_counts)
          
          # Generate amount based on passenger count and location
          amount = generate_amount(passenger_count, location_index)
          
          # Create sale
          sale = Sale.create!(
            amount: amount,
            payment_method: payment_method,
            number_of_passengers: passenger_count,
            notes: ["", "Cliente frecuente", "Descuento aplicado", "Pago exacto", "Ticket de grupo"].sample,
            timestamp: timestamp,
            user: cashier,
            location: location,
            organization: organization
          )
          
          # Sale's after_create callback should automatically create a ticket
          # Update ticket attributes
          if sale.ticket
            # Determine if ticket should be expired based on date
            if date < Date.today - 1
              sale.ticket.update(
                valid_until: timestamp + 1.hour,
                printed: [true, false].sample  # Some tickets printed, some not
              )
            else
              # Recent tickets
              sale.ticket.update(
                valid_until: timestamp + 1.hour,
                printed: false  # Recent tickets not printed as requested
              )
            end
          end
          
          total_sales += 1
          
          # Print progress every 100 sales
          if total_sales % 100 == 0
            puts "Generated #{total_sales} sales..."
          end
        end
      end
    end
    
    puts "Completed! Generated #{total_sales} sales across #{locations.count} locations."
    puts "Demo data generation complete. You can now login with:"
    puts "  Owner: admin@trenesrapidos.mx / password123"
    puts "  Managers: gerente.[location]@trenesrapidos.mx / manager123"
    puts "  Cashiers: cajero1.[location]@trenesrapidos.mx / cashier123"
  end
end
