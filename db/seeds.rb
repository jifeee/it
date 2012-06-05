%w[admin driver operator freight_forwarder].each do |name|
  Role.find_or_create_by_name(name.humanize)
end

adm_role = Role.find_by_name('Admin')
if adm_role.users.count.zero?
  adm_role.users.create(:email => "admin@admin.com", :password => "qwe123")
end
