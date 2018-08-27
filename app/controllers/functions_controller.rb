class FunctionsController < ApplicationController
  before_action :set_function, only: [:show, :edit, :update, :destroy]

  def index
    @functions = Function.all
  end

  def show
    values_range = { from: -10, to: 10 }
    expression_y_values = []

    values_range[:from].upto(values_range[:to]) do |x|
      value = eval(@function.expression.gsub('x', "(#{x})"))
      puts "x = #{x}, value = #{value}, on function = #{@function.expression.gsub('x', x.to_s)}"
      expression_y_values << value
    end

    gon.expression_y_values = expression_y_values
    gon.expression_x_values = values_range[:from].upto(values_range[:to]).to_a
    gon.expression_values_range = values_range[:to]
  end

  def new
    @function = Function.new
  end

  def edit
  end

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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_function
      @function = Function.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def function_params
      params.require(:function).permit(:expression, :point_a, :point_b)
    end
end
