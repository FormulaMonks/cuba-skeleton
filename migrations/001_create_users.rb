Sequel.migration do

  change do
    create_table(:users) do
      primary_key(:id)
      column(:username, String, {
        :size => 63,
        :null => false,
        :text => false,
        :unique => true
      })
      column(:email, String, :size => 63, :null => false, :text => false)
      column(:created_at, DateTime, :null => false)
    end
  end

end
