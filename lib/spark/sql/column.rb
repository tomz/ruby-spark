module Spark
  module SQL
    class Column

      def self.to_java(col)
        if col.is_a?(Column)
          col.jcolumn
        else
          from_name(col)
        end
      end

      def self.from_literal(literal)
        JSQLFunctions.lit(literal)
      end

      def self.from_name(name)
        JSQLFunctions.col(col)
      end

      attr_reader :jcolumn

      def initialize(jcolumn)
        @jcolumn = jcolumn
      end

      FUNC_OPERATORS = {
        '!' => 'negate',
        '~' => 'not'
      }

      BIN_OPERATORS = {
        '[]' => 'apply',
        '+' => 'plus',
        '-' => 'minus',
        '*' => 'multiply',
        '/' => 'divide',
        '%' => 'mod',
        '==' => 'equalTo',
        '!=' => 'notEqual',
        '<' => 'lt',
        '<=' => 'leq',
        '>' => 'gt',
        '>=' => 'geq',
        '&' => 'and',
        '|' => 'or',
        'like' => 'like',
        'starts_with' => 'startsWith',
        'ends_with' => 'endsWith',
        'bitwiseOR' => 'bitwiseOR',
        'bitwiseAND' => 'bitwiseAND',
        'bitwiseXOR' => 'bitwiseXOR',
      }

      UNARY_OPERATORS = {
        'asc' => 'asc',
        'desc' => 'desc',
        'is_null' => 'isNull',
        'is_not_null' => 'isNotNull'
      }

      FUNC_OPERATORS.each do |op, func|
        eval <<-METHOD
          def #{op}
            func_op('#{func}')
          end
        METHOD
      end

      BIN_OPERATORS.each do |op, func|
        eval <<-METHOD
          def #{op}(item)
            bin_op('#{func}', item)
          end
        METHOD
      end

      UNARY_OPERATORS.each do |op, func|
        eval <<-METHOD
          def #{op}
            unary_op('#{func}')
          end
        METHOD
      end

      # An expression that gets an item at position ordinal out of a list,
      # or gets an item by key out of a Hash.
      #
      # == Example:
      #   df.select(df.l.get_item(0), df.d.get_item("key")).show
      #   # +----+------+
      #   # |l[0]|d[key]|
      #   # +----+------+
      #   # |   1| value|
      #   # +----+------+
      #
      #   df.select(df.l[0], df.d["key"]).show
      #   # +----+------+
      #   # |l[0]|d[key]|
      #   # +----+------+
      #   # |   1| value|
      #   # +----+------+
      #
      def get_item(key)
        self[key]
      end

      # An expression that gets a field by name in a StructField.
      #
      # == Example:
      #   df.select(df.r.get_field("b")).show
      #   # +----+
      #   # |r[b]|
      #   # +----+
      #   # |   b|
      #   # +----+
      #
      #   df.select(df.r.a).show
      #   # +----+
      #   # |r[a]|
      #   # +----+
      #   # |   1|
      #   # +----+
      #
      def get_field(name)
        self[name]
      end
      end

      # Returns this column aliased with a new name or names (in the case of expressions that
      # return more than one column, such as explode).
      #
      # == Example:
      #   df.select(df.age.alias("age2")).collec
      #   # => [#<Row {"age2"=>2}>, #<Row {"age2"=>5}>]
      #
      def alias(name)
        Column.new(jcolumn.as(name))
      end

      def method_missing(method, item)
        get_field(item)
      end

        new_jcolumn = jcolumn.__send__(name, col)
        Column.new(new_jcolumn)
      def to_s
        "Column('#{jcolumn.toString}')"
      end

      def func_op(name)
        new_jcolumn = JSQLFunctions.__send__(name, jcolumn)
        Column.new(new_jcolumn)
      def inspect
        "#<#{to_s}>"
      end


      private

        def func_op(name)
          new_jcolumn = JSQLFunctions.__send__(name, jcolumn)
          Column.new(new_jcolumn)
        end

        def bin_op(name, item)
          if item.is_a?(Column)
            col = item.jcolumn
          else
            col = item
          end

          new_jcolumn = jcolumn.__send__(name, col)
          Column.new(new_jcolumn)
        end

      def unary_op(name)
        new_jcolumn = jcolumn.__send__(name)
        Column.new(new_jcolumn)
      end


    end
  end
end