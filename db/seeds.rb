# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

common = AttributeKind.create([
                                  {title: 'Brand'},
                                  {title: 'Model'},
                                  {title: 'Year'},
                                  {title: 'Manufacturer'},
                                  {title: 'Country'}
                              ])

bikes = AttributeKind.create([
                                 {title: 'Weight'},
                                 {title: 'Gender'},
                                 {title: 'Wheel diameter'}
                             ])

cars = AttributeKind.create([
                                {title: 'Motor'},
                                {title: 'Fuel type'},
                                {title: 'Transmission'}
                            ])

car_service_kinds = ServiceKind.create([
                                           {title: 'oil + filter', with_text: false},
                                           {title: 'gearbox oil', with_text: false},
                                           {title: 'brake fluid', with_text: false},
                                           {title: 'shock absorbers', with_text: false},
                                           {title: 'tires', with_text: false},
                                           {title: 'candles', with_text: false},
                                           {title: 'wipers', with_text: false},
                                           {title: 'brake system', with_text: false},
                                           {title: 'ignition', with_text: false},
                                           {title: 'lamps and lighting', with_text: false},
                                           {title: 'hinges and lids', with_text: false},
                                           {title: 'air conditioning', with_text: false},
                                           {title: 'power steering', with_text: false},
                                           {title: 'engine wiring', with_text: false},
                                           {title: 'clutch', with_text: false},
                                           {title: 'air filter', with_text: false},
                                           {title: 'coolant', with_text: false},
                                           {title: 'washer / liquid', with_text: false},
                                           {title: 'exhaust system', with_text: false},
                                           {title: 'battery', with_text: false},
                                           {title: 'chassis', with_text: false},
                                           {title: 'cabin filter', with_text: false},
                                           {title: 'towbar', with_text: false},
                                           {title: 'engine diagnostics', with_text: true},
                                           {title: 'pruning mechanisms', with_text: true},
                                           {title: 'axle geometry', with_text: true},
                                           {title: 'body works', with_text: true},
                                           {title: 'replacement of other parts', with_text: true},
                                           {title: 'testdrive', with_text: true},
                                           {title: 'Other repair / recommendation:', with_text: true},
                                           {title: 'The next control in km', with_text: true}
                                       ])

car= Category.create(name: 'Car')
car.attribute_kinds = common + cars
car.service_kinds = car_service_kinds
car.save


bike= Category.create(name: 'Bike')
bike.attribute_kinds = common + bikes
bike.save
