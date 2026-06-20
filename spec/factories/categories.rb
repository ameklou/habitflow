FactoryBot.define do
  factory :category do
    user
    sequence(:name) { |number| "Category #{number}" }
    color { "#2563eb" }
    icon { "folder" }
    position { 1 }
  end
end
