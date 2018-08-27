class Function < ApplicationRecord
  def human_expression
    expression.gsub('**', '^').gsub('*', '&#903;').html_safe
  end

  def point_a_x
    return 0 if point_a.blank?
    point_a.split(',').first.to_i
  end

  def point_a_y
    return 0 if point_a.blank?
    point_a.split(',').last.to_i
  end

  def point_b_x
    return 0 if point_b.blank?
    point_b.split(',').first.to_i
  end

  def point_b_y
    return 0 if point_b.blank?
    point_b.split(',').last.to_i
  end
end
