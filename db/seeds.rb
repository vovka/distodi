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


car= Category.create(name: 'Car')
car.attribute_kinds = common + cars
car.save


bike= Category.create(name: 'Bike')
bike.attribute_kinds = common + bikes
bike.save


