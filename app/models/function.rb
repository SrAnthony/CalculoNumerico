class Function < ApplicationRecord
  def human_expression
    expression.gsub('**', '^').gsub('*', '&#903;').html_safe
  end
end
