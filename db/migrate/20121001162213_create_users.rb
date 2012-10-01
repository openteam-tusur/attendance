class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do | t |
      t.string  :uid                # omniauth[:uid]
      t.text    :name,              # omniauth[:info]
                :email,
                :nickname,
                :first_name,
                :last_name,
                :location,
                :description,
                :image,
                :phone,
                :urls
      t.text    :raw_info           # omniauth[:extra]

      # Trackable
      t.integer  :sign_in_count
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      t.timestamps
    end

    add_index :users, :uid
  end
end
