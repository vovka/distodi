class CreateDemoCompanies < ActiveRecord::Migration
  def up
    all_attributes = [
      {
        name: "Look Forward Company LTD",
        email: "lookforward@example.com",
        password: "11111111",
      },
      {
        name: "Reims Company LTD",
        email: "reims.sky@example.com",
        password: "11111111",
      },
      {
        name: "IRENE PEACE Company LTD",
        email: "irene@example.com",
        password: "11111111",
      },
      {
        name: "Izmail Company LTD",
        email: "izmai@example.com",
        password: "11111111",
      },
    ]
    all_attributes.each do |attributes|
      company = Company.where(
        attributes.reject { |k, _| k.in?(%i(password)) }
      ).first
      if company.nil?
        attributes[:demo] = true
        attributes[:password_confirmation] = attributes[:password]
        company = Company.create!(attributes)
      end
      company
    end
  end

  def down
    # raise ActiveRecord::IrreversibleMigration
  end
end
