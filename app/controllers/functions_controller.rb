class FunctionsController < ApplicationController
  before_action :set_function, only: [:show, :edit, :update, :destroy, :evaluate_expression]
  before_action :set_range, only: [:evaluate_expression]

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
          position_b: [@function.point_b_x, @function.point_b_y]
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
