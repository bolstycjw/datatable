require 'faker'

20.times do
  Foo.create!(name: Faker::Name.name)
end
