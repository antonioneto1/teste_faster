Rails.application.routes.draw do
  post 'question/one', to: 'question#one'
  post 'question/two', to: 'question#two'
  post 'question/three', to: 'question#three'
end
