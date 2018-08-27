module FunctionsHelper
#   def apply_negation_symbol(s)
#     copy = s.clone
#     s
#       .enum_for(:scan, %r{(?<![\d\)])-})
#       .map { Regexp.last_match.begin(0) }
#       .each { |ix| copy[ix] = 'n' }
#     copy
#   end
#
#   def nest_parenthesis(s)
#     stack = []
#     s
#       .chars
#       .inject Array.new do |arr, char|
#         case(char)
#           when '(' then stack.push arr; Array.new
#           when ')' then stack.pop << arr
#           else arr << char
#         end
#       end
#   end
#
#   def is_numerical?(c)
#     not (c =~ %r{[\d\.]}).nil?
#   end
#
#   def digits_to_floats(tree)
#     return tree if not tree.is_a? Array
#     tree = tree.map {|t| digits_to_floats(t) }
#     tree
#       .chunk {|d| is_numerical?(d)}
#       .map{|_, xs| xs}
#       .flat_map {|g| g.all? {|ch| is_numerical?(ch)} ? g.join.to_f : g}
#   end
#
#   def negation_to_postfix(tree)
#     return tree if not tree.is_a? Array
#     tree = tree.map{ |t| negation_to_postfix(t) }
#     tree
#       .slice_before{|item| item == 'n'}
#       .flat_map { |arr| arr.first == 'n' ? [arr.first(2), arr[2..-1]] : arr}
#       .delete_if { |item| item.is_a? Array and item.empty?}
#   end
#
#   def operations_to_postfix(tree, ops=['/','*'])
#     return tree if not tree.is_a? Array
#     tree = tree.map{ |t| operations_to_postfix(t, ops) }
#     tree
#       .map.with_index{ |item, ix| ops.include?(item) ? ix : nil}
#       .compact
#       .reverse
#       .each do |ix|
#         arg1, op, arg2 = tree.slice!(ix-1..ix+1)
#         tree[ix-1] = [op, arg1, arg2]
#       end
#     tree
#   end
#
#   def calc(expression)
#     s = apply_negation_symbol(expression)
#     tree = nest_parenthesis(s)
#     tree = digits_to_floats(tree)
#     tree = negation_to_postfix(tree)
#     tree = operations_to_postfix(tree, ops=['/','*'])
#     tree = operations_to_postfix(tree, ops=['+','-'])
#     eval(tree)
#   end
#
end
