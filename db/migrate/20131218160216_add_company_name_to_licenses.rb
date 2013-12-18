class AddCompanyNameToLicenses < ActiveRecord::Migration
  def change
    add_column :licenses, :company_name, :string
  end
end
