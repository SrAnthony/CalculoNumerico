Rails.application.routes.draw do
  resources :functions
  root 'functions#index'

  get 'functions/:id/evaluate_expression' => 'functions#evaluate_expression', as: :evaluate_expression
  get 'functions/:id/metodo_bisseccao' => 'functions#metodo_bisseccao', as: :metodo_bisseccao
  get 'functions/:id/metodo_cordas' => 'functions#metodo_cordas', as: :metodo_cordas
  get 'functions/:id/metodo_newton' => 'functions#metodo_newton', as: :metodo_newton
end
