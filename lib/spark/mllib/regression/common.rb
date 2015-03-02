##
# LinearModel
#
# A linear model that has a vector of coefficients and an intercept.
#
module Spark
  module Mllib
    class LinearModel

      attr_reader :weights, :intercept

      def initialize(weights, intercept)
        @weights = Spark::Mllib::Vector.to_vector(weights)
        @intercept = intercept.to_f
      end

      # Predict the value of the dependent variable given a vector data
      # containing values for the independent variables.
      #
      # == Examples:
      #
      # lm = LinearModel.new([1.0, 2.0], 0.1)
      #
      # lm.predict([-1.03, 7.777]) - 14.624 < 1e-6
      # => true
      #
      # lm.predict(SparseVector.new(2, {0 => -1.03, 1 => 7.777})) - 14.624 < 1e-6
      # => true
      #
      def predict(data)
        data = Spark::Mllib::Vector.to_vector(data)
        @weights.dot(data) + @intercept
      end

    end
  end
end


##
# RegressionMethodBase
#
# Parent for regression methods
#
module Spark
  module Mllib
    class RegressionMethodBase

      def self.train(rdd, options)
        # String keys to symbols
        options.symbolize_keys!

        # Reverse merge
        self::DEFAULT_OPTIONS.each do |key, value|
          if options.has_key?(key)
            # value from user
          else
            options[key] = value
          end
        end

        # Validation
        first = rdd.first
        unless first.is_a?(LabeledPoint)
          raise Spark::MllibError, "RDD should contains LabeledPoint, got #{first.class}"
        end

        # Initial weights is optional for user (not for Spark)
        options[:initial_weights] = Vector.to_vector(options[:initial_weights] || [0.0] * first.features.size)
      end

    end
  end
end
