
class CreateDemoCompany < ActiveRecord::Migration
  def up
    # Faker rejects to work with I18n database backend due to incorrect list processing by i18n db backend
    # TODO: Need to solve this issue
    # Company.first_or_create!(
    #   demo: true,
    #   password: "11111111",
    #   password_confirmation: "11111111",
    #   name: DemoDataService::DEMO_TITLE_PLACEHOLDER + Faker::Company.name,
    #   # phone: Faker::PhoneNumber.phone_number,
    #   country: Faker::Address.country,
    #   city: Faker::Address.city,
    #   address: Faker::Address.street_address,
    #   postal_code: Faker::Address.postcode.split("-").first,
    #   email: Faker::Internet.safe_email,
    #   website: "example.com",
    #   notice: Faker::Lorem.paragraphs(1),
    #   first_name: Faker::Name.first_name,
    #   last_name: Faker::Name.last_name,
    # )

    # From https://www.fakeaddressgenerator.com/World/us_address_generator
    Company.first_or_create!(
      demo: true,
      password: "11111111",
      password_confirmation: "11111111",
      name: DemoDataService::DEMO_TITLE_PLACEHOLDER + "Melissa R Doyon Inc",
      phone: "+1-202-555-0152",
      country: "US",
      city: "Helena",
      address: "4153 Richison Drive",
      postal_code: "59601",
      email: "melissa@example.com",
      website: "example.com",
      notice: "Playing An Instrument,Photography,Rebounding",
      first_name: "Melissa",
      last_name: "Doyon",
    )
  end

  def down
    # raise ActiveRecord::IrreversibleMigration
  end
end
