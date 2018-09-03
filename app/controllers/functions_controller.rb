class FunctionsController < ApplicationController
  before_action :set_function, only: [:show, :edit, :update, :destroy, :evaluate_expression, :metodo_bisseccao, :metodo_cordas, :metodo_newton]
  # before_action :define_params, only: [:metodo_bisseccao, :metodo_cordas]
  before_action :set_range, only: [:evaluate_expression]

  MAX_ITERATIONS = 1000

  def index
    @functions = Function.all
  end

  def show; end

  def new
    @function = Function.new
  end

  def edit; end

  def create
    @function = Function.new(function_params)

    respond_to do |format|
      if @function.save
        format.html { redirect_to @function, notice: 'Function was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @function.update(function_params)
        format.html { redirect_to @function, notice: 'Function was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @function.destroy
    respond_to do |format|
      format.html { redirect_to functions_url, notice: 'Function was successfully destroyed.' }
    end
  end

  def evaluate_expression
    calculator = Dentaku::Calculator.new
    expression_ys = []
    params[:range_start].upto(params[:range_end]) do |x|
      expression_ys << [x, calculator.evaluate(@function.expression, x: x)]
    end

    respond_to do |format|
      format.json do
        render json: {
          expression_xs: params[:range_start].upto(params[:range_end]).to_a,
          expression_ys: expression_ys,
          position_a: [@function.point_a_x, @function.point_a_y],
          position_b: [@function.point_b_x, @function.point_b_y],
          has_point_a: @function.point_a.present?,
          has_point_b: @function.point_b.present?
        }
      end
    end
  end

  def metodo_bisseccao
    time_start = Time.new
    calculator = Dentaku::Calculator.new
    a = params[:point_a].to_f || -10.0
    b = params[:point_b].to_f || 10.0
    eps = params[:eps].present? ? params[:eps].to_f : 0.0001
    c = 0.0
    func_a = calculator.evaluate(@function.expression, x: a)
    func_b = calculator.evaluate(@function.expression, x: b)
    func_c = 0.0
    solution = 0.0
    result_values = []

    MAX_ITERATIONS.times do |i|
      c = (a + b) / 2
      func_c = calculator.evaluate(@function.expression, x: c)
      result_values << {
        iteration: i,
        a: a,
        b: b,
        c: c,
        func_c: func_c
      }
      # Acaba o loop caso encontre a solução
      break if func_c == 0 || (b - a) / 2 < eps
      # Multiplicação de f(c) com f(a) dá positivo se tiverem sinais iguais
      if (func_c * func_a).positive?
        a = c
      else
        b = c
      end
    end

    respond_to do |format|
      format.json do
        render json: {
          expression: @function.expression,
          result_values: result_values,
          time_spent: Time.new - time_start,
          eps: eps
        }
      end
    end
  end

  def metodo_cordas
    time_start = Time.new
    calculator = Dentaku::Calculator.new
    eps = params[:eps].present? ? params[:eps].to_f : 0.0001
    a = params[:point_a].present? ? params[:point_a].to_f : 1.0
    b = params[:point_b].present? ? params[:point_b].to_f : 2.0
    round_value = params[:round_value].present? ? params[:round_value].to_i : 20
    round_value = round_value > 10000 ? 10000 : round_value
    result_values = []
    c = 0.0
    func_a = calculator.evaluate(@function.expression, x: a)
    func_b = calculator.evaluate(@function.expression, x: b)

    # c = X^(N)
    c = ((a * func_b) - (b * func_a)) / (func_b - func_a)
    func_c = calculator.evaluate(@function.expression, x: c)

    MAX_ITERATIONS.times do |i|
      puts "LOOP #{i}: a: #{a}, b: #{b}, c: #{c}, func_c: #{func_c}"

      if (func_c * func_a).positive?
        c = (((c * func_b) - (b * func_c)) / (func_b - func_c)).round(round_value)
      else
        c = (((a * func_c) - (c * func_a)) / (func_c - func_a)).round(round_value)
      end

      func_c = calculator.evaluate(@function.expression, x: c).round(round_value)

      result_values << {
        iteration: i,
        a: a,
        b: b,
        c: c,
        func_c: func_c
      }

      break if func_c.abs <= eps

    end

    respond_to do |format|
      format.json do
        render json: {
          expression: @function.expression,
          result_values: result_values,
          time_spent: Time.new - time_start,
          eps: eps
        }
      end
    end

  end

  def metodo_newton
    time_start = Time.new
    calculator = Dentaku::Calculator.new
    eps = params[:eps].present? ? params[:eps].to_f : 0.0001
    a = params[:point_a].present? ? params[:point_a].to_f : 1.0
    derivative = params[:derivative].gsub(' ', '+') || ''
    result_values = []

    MAX_ITERATIONS.times do |i|
      func_a = calculator.evaluate(@function.expression, x: a)
      puts "calculando derivada de #{derivative}"
      func_der_a = calculator.evaluate(derivative, x: a)

      # Cálculo de Newton
      c = a - (func_a / func_der_a)

      result_values << {
        iteration: i,
        a: a,
        func_a: func_a,
        func_der_a: func_der_a,
        c: c,
        result: (c - a).abs
      }

      break if (c - a).abs <= eps * c.abs

      a = c
    end

    respond_to do |format|
      format.json do
        render json: {
          expression: @function.expression,
          derivative: derivative,
          result_values: result_values,
          time_spent: Time.new - time_start,
          eps: eps
        }
      end
    end

  end

  private

  def set_range
    params[:range_start] ||= -10
    params[:range_end] ||= 10
    params
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_function
    @function = Function.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def function_params
    params.require(:function).permit(:expression, :point_a, :point_b)
  end
end
