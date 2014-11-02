class AddPaymentPlanToSponsor < ActiveRecord::Migration
  def change
    add_column :sponsors, :payment_plan, :string
  end
end
