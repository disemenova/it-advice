class UserAnswer < ApplicationRecord
  belongs_to :user
  belongs_to :answer
  belongs_to :quiz
  belongs_to :question
end
