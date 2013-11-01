# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :quote do
    price 1.5
    date "2013-10-29 18:34:00"
    stock_symbol "MyString"
  end
end
