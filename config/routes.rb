Rails.application.routes.draw do
  resources :functions
  root 'functions#index'

  get 'functions/:id/evaluate_expression' => 'functions#evaluate_expression', as: :evaluate_expression
  get 'functions/:id/metodo_bisseccao' => 'functions#metodo_bisseccao', as: :metodo_bisseccao
end
