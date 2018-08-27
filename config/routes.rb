Rails.application.routes.draw do
  resources :functions
  root 'functions#index'

  get 'functions/:id/evaluate_expression' => 'functions#evaluate_expression', as: :evaluate_expression
  get 'functions/:id/function_points' => 'functions#function_points', as: :function_points
end
