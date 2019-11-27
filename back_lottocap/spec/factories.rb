# # frozen_string_literal: true

require_relative "models/user_model"


FactoryBot.define do
  factory :user, class: UserModel do
        obj { }
        usuario { 'user1@gmail.com' }
        senha { '1234' }
    
  end
end
 