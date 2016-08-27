# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Item.destroy_all
ServiceField.destroy_all
ServiceActionKind.destroy_all
AttributeKind.destroy_all
ServiceKind.destroy_all
ActionKind.destroy_all
Category.destroy_all


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

car_action_kinds = ActionKind.create([
                                         {title: 'Control'},
                                         {title: 'Change'},
                                     ])

car= Category.create(name: 'Car')
car.attribute_kinds = common + cars
car.service_kinds = car_service_kinds
car.action_kinds = car_action_kinds
car.save

bike_service_kinds = ServiceKind.create([
                                            {title: 'Theads in the frame', with_text: false},
                                            {title: 'Cleanin the frame + wheels', with_text: false},
                                            {title: 'Cleanin the frame + wheels', with_text: false},
                                            {title: 'Degrease the chain + cassette/freewheel', with_text: false},
                                            {title: 'Weels', with_text: false},
                                            {title: 'Chain', with_text: false},
                                            {title: 'Realign brakes + adjust', with_text: false},
                                            {title: 'Adjusting brakes', with_text: false},
                                            {title: 'Adjusting shifting', with_text: false},
                                            {title: 'Adjusting headset', with_text: false},
                                            {title: 'Adjusting hubs', with_text: false},
                                            {title: 'Truing front + rear wheels', with_text: false}
                                        ])

bike_action_kinds = ActionKind.create([
                                          {title: 'Control and Clean'},
                                          {title: 'Change'},
                                      ])


bike= Category.create(name: 'Bike')
bike.attribute_kinds = common + bikes
bike.service_kinds = bike_service_kinds
bike.action_kinds = bike_action_kinds
bike.save
