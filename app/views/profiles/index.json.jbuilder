json.array!(@profiles) do |profile|
  json.extract! profile, :id, :email, :name, :avater
  json.url profile_url(profile, format: :json)
end
