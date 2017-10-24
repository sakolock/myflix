class AddTokenToInvitations < ActiveRecord::Migration[5.1]
  def change
    add_column :invitations, :token, :string 
  end
end
