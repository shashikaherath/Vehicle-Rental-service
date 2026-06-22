const vehicles = [
  // ── CARS ──────────────────────────────────────────────────────────────
  {
    id: 1,
    brand: "Aether",
    model: "Spectre S",
    category: "Car",
    pricePerDay: 250,
    transmission: "Automatic",
    fuel: "Hybrid",
    seats: 5,
    image: "assets/images/car.jpg",
    rating: 4.9,
    description: "The Aether Spectre S defines modern executive luxury. Featuring a silent hybrid powertrain, hand-stitched leather interiors, and an advanced active suspension system, it delivers an unparalleled smooth ride for business or leisure.",
    features: ["GPS Navigation", "Leather Seats", "360 Degree Camera", "Active Noise Cancelling", "Panoramic Sunroof", "Heated & Cooled Seats"]
  },
  {
    id: 2,
    brand: "Apex",
    model: "Volante GTR",
    category: "Car",
    pricePerDay: 320,
    transmission: "Manual",
    fuel: "Petrol",
    seats: 2,
    image: "assets/images/car.jpg",
    rating: 4.9,
    description: "For the pure driving purist. The Volante GTR pairs a twin-turbo V8 engine with a slick 6-speed manual. Feel every rev and corner with raw, unfiltered mechanical performance at your fingertips.",
    features: ["Manual Gearbox", "Sport Exhaust", "Limited Slip Differential", "Alcantara Steering", "Launch Control", "Convertible Soft Top"]
  },

  // ── VANS ──────────────────────────────────────────────────────────────
  {
    id: 3,
    brand: "TransPro",
    model: "Cargo Master",
    category: "Van",
    pricePerDay: 110,
    transmission: "Automatic",
    fuel: "Diesel",
    seats: 2,
    image: "assets/images/van.jpg",
    rating: 4.6,
    description: "The TransPro Cargo Master is the definitive commercial van. With a massive load bay, reinforced flooring, and excellent diesel economy, it is the professional's first choice for trade and deliveries.",
    features: ["Bulkhead Partition", "Racking System", "Reversing Camera", "Cruise Control", "Keyless Entry", "Twin Rear Doors"]
  },
  {
    id: 4,
    brand: "Ridgeline",
    model: "Combi 9",
    category: "Van",
    pricePerDay: 130,
    transmission: "Automatic",
    fuel: "Petrol",
    seats: 9,
    image: "assets/images/van.jpg",
    rating: 4.7,
    description: "The Ridgeline Combi 9 is the ultimate people-carrier van. Spacious 9-seat layout, fold-flat rear seats, and climate control make every group journey comfortable and stress-free.",
    features: ["9 Passenger Seats", "Fold-Flat Rows", "Dual Zone Climate", "Bluetooth Audio", "USB Charging Points", "Tinted Glass"]
  },

  // ── MOTORBIKES ────────────────────────────────────────────────────────
  {
    id: 5,
    brand: "ThunderRide",
    model: "Storm 750",
    category: "Motorbike",
    pricePerDay: 75,
    transmission: "Manual",
    fuel: "Petrol",
    seats: 2,
    image: "assets/images/motorbike.jpg",
    rating: 4.85,
    description: "Tear up the tarmac on the ThunderRide Storm 750. A naked street bike with an aggressive parallel-twin engine, inverted front forks, and a razor-sharp chassis tuned for thrilling urban riding.",
    features: ["Riding Modes", "ABS Braking", "Quickshifter", "LED Headlights", "Traction Control", "Slipper Clutch"]
  },
  {
    id: 6,
    brand: "IronHorse",
    model: "Cruiser Classic",
    category: "Motorbike",
    pricePerDay: 85,
    transmission: "Manual",
    fuel: "Petrol",
    seats: 2,
    image: "assets/images/motorbike.jpg",
    rating: 4.8,
    description: "Channel the spirit of the open road on the IronHorse Cruiser Classic. A timeless V-twin cruiser with a low-slung stance, wide handlebars, and a thunderous exhaust note that commands respect.",
    features: ["V-Twin Engine", "Wide Handlebars", "Chrome Finishes", "Windshield", "Saddlebags", "Heated Grips"]
  },

  // ── SCOOTERS ──────────────────────────────────────────────────────────
  {
    id: 7,
    brand: "Zephyr",
    model: "City Glide 125",
    category: "Scooter",
    pricePerDay: 35,
    transmission: "Automatic",
    fuel: "Petrol",
    seats: 2,
    image: "assets/images/scooter.jpg",
    rating: 4.7,
    description: "Weave through city streets effortlessly on the Zephyr City Glide 125. Lightweight, nimble, and fuel-sipping, it is the smartest way to skip traffic and explore urban destinations.",
    features: ["Underseat Storage", "USB Charger", "Digital Display", "Disc Brakes", "LED Lights", "Lockable Top Box"]
  },
  {
    id: 8,
    brand: "VoltRide",
    model: "Eco E-Scoot",
    category: "Scooter",
    pricePerDay: 40,
    transmission: "Automatic",
    fuel: "Electric",
    seats: 2,
    image: "assets/images/scooter.jpg",
    rating: 4.75,
    description: "Zero emissions, zero noise, zero hassle. The VoltRide Eco E-Scoot delivers a 100km range per charge with regenerative braking and a smartphone app for live battery monitoring.",
    features: ["100km Range", "App Connectivity", "Regenerative Braking", "Keyless Start", "Anti-theft Alarm", "Fast Charge Port"]
  },

  // ── BUSES ─────────────────────────────────────────────────────────────
  {
    id: 9,
    brand: "OmniFleet",
    model: "Shuttle 24",
    category: "Bus",
    pricePerDay: 280,
    transmission: "Automatic",
    fuel: "Diesel",
    seats: 24,
    image: "assets/images/bus.jpg",
    rating: 4.65,
    description: "The OmniFleet Shuttle 24 is perfect for corporate transfers, school trips, and group excursions. Plush reclining seats, overhead luggage racks, and a powerful climate system ensure a relaxed group journey.",
    features: ["24 Reclining Seats", "Overhead Racks", "Climate Control", "USB Charging", "PA System", "Panoramic Windows"]
  },
  {
    id: 10,
    brand: "CoachPro",
    model: "Grand Tourer 52",
    category: "Bus",
    pricePerDay: 480,
    transmission: "Automatic",
    fuel: "Diesel",
    seats: 52,
    image: "assets/images/bus.jpg",
    rating: 4.7,
    description: "The CoachPro Grand Tourer 52 is the ultimate long-distance coach. With on-board WiFi, a refreshment station, plush leather seating, and a smooth air-ride suspension, long journeys feel like a pleasure cruise.",
    features: ["52 Leather Seats", "On-board WiFi", "Refreshment Station", "Air-ride Suspension", "Entertainment Screens", "Toilet Compartment"]
  },

  // ── LORRIES ───────────────────────────────────────────────────────────
  {
    id: 11,
    brand: "HaulKing",
    model: "Atlas 7.5T",
    category: "Lorry",
    pricePerDay: 195,
    transmission: "Manual",
    fuel: "Diesel",
    seats: 2,
    image: "assets/images/lorry.jpg",
    rating: 4.6,
    description: "The HaulKing Atlas 7.5T is ideal for medium-haul deliveries and removals. A straightforward drive with a spacious cab, tail-lift fitted body, and impressive payload capacity for trade and home moves.",
    features: ["Tail-Lift", "7.5T Payload", "Air-con Cab", "Curtainsider Body", "Safety Barriers", "GPS Tracking"]
  },
  {
    id: 12,
    brand: "SteelHaul",
    model: "Titan 18T",
    category: "Lorry",
    pricePerDay: 350,
    transmission: "Automatic",
    fuel: "Diesel",
    seats: 2,
    image: "assets/images/lorry.jpg",
    rating: 4.55,
    description: "Built for heavy-duty hauling, the SteelHaul Titan 18T features an automated gearbox for ease of driving, a powerful turbo diesel engine, and a full flatbed platform for oversized cargo loads.",
    features: ["18T Payload", "Automated Gearbox", "Flatbed Platform", "Air-ride Suspension", "Tachograph", "Lane Keep Assist"]
  },

  // ── TRUCKS ────────────────────────────────────────────────────────────
  {
    id: 13,
    brand: "Vanguard",
    model: "Ranger Pro 4x4",
    category: "Truck",
    pricePerDay: 175,
    transmission: "Automatic",
    fuel: "Diesel",
    seats: 5,
    image: "assets/images/truck.jpg",
    rating: 4.8,
    description: "The Vanguard Ranger Pro 4x4 is the truck that works as hard as you do. With a robust tow package, locking rear differential, and a full double cab, it is equally at home on a building site or a weekend adventure.",
    features: ["4x4 Drive", "Towing 3.5T", "Locking Diff", "Double Cab", "Load Liner", "Apple CarPlay"]
  },
  {
    id: 14,
    brand: "TerraFlex",
    model: "Gladiator V8",
    category: "Truck",
    pricePerDay: 220,
    transmission: "Automatic",
    fuel: "Petrol",
    seats: 5,
    image: "assets/images/truck.jpg",
    rating: 4.75,
    description: "Dominate off-road and on-road with the TerraFlex Gladiator V8. A naturally aspirated V8 engine, raised suspension lift, all-terrain tyres, and a spacious open bed make it a true all-rounder.",
    features: ["V8 Engine", "Suspension Lift", "All-terrain Tyres", "Bed Liner", "LED Light Bar", "Snorkel Kit"]
  },

  // ── BOATS ─────────────────────────────────────────────────────────────
  {
    id: 15,
    brand: "AquaLux",
    model: "Riviera 28",
    category: "Boat",
    pricePerDay: 450,
    transmission: "Automatic",
    fuel: "Petrol",
    seats: 8,
    image: "assets/images/boat.jpg",
    rating: 4.9,
    description: "Step aboard the AquaLux Riviera 28 — an elegant day cruiser designed for pure leisure on the water. Plush sun loungers, a built-in cooler, Bimini sunshade, and a powerful inboard engine make it the ultimate nautical experience.",
    features: ["Sun Loungers", "Built-in Cooler", "Bimini Shade", "Bluetooth Speakers", "Navigation Chart", "Safety Equipment"]
  },
  {
    id: 16,
    brand: "SpeedWave",
    model: "Jet Runner 22",
    category: "Boat",
    pricePerDay: 380,
    transmission: "Automatic",
    fuel: "Petrol",
    seats: 6,
    image: "assets/images/boat.jpg",
    rating: 4.85,
    description: "For adrenaline on the water, the SpeedWave Jet Runner 22 delivers exhilarating performance with a 300hp outboard engine, deep-V hull for stability, and a sporty open layout perfect for watersports.",
    features: ["300hp Outboard", "Deep-V Hull", "Ski Tow Bar", "Live Baitwell", "GPS Chartplotter", "Wakeboard Rack"]
  }
];
