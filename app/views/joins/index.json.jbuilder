json.array!(@joins) do |join|
  json.extract! join, :id, :create, :edit, :update, :show, :destroy
  json.url join_url(join, format: :json)
end
