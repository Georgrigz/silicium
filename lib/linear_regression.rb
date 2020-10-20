module Silicium
  module LinearRegression
    class LinearRegressionByGradientDescent
      # @abstract Finds parameters theta0, theta1 for equation theta0 + theta1 * x
      # for linear regression of given plot of one variable
      # @param plot Actually hash x => y for different points of the plot
      # @param epsilon Learning rate (how close to perfect result we should come)
      # @param alpha Speed of learning (should be little enough not to diverge)
      # @param start_theta0 Starting value of theta0
      # @param start_theta1 Starting value of theta1
      def self.generate_function(plot, epsilon = 0.000001, alpha = 0.01, start_theta0 = 0, start_theta1 = 0)
        theta0 = start_theta0
        theta1 = start_theta1
        m = plot.length.to_f
        # bias_old = 10.0
        bias_new = 5.0
        while bias_new.abs() > epsilon
          old_theta0, old_theta1 = theta0, theta1
          oth = theta0
          theta0 = theta0 - alpha / m * d_dt_for_theta0(plot, theta0, theta1)
          theta1 = theta1 - alpha / m * d_dt_for_theta1(plot, oth, theta1)
          # puts theta0.to_s + " " + theta1.to_s
          bias_new = [(theta0 - old_theta0).abs(), (theta1 - old_theta1).abs()].max()
          # puts bias_new.to_s
        end
        return theta0, theta1
      end

      def self.d_dt_for_theta0(plot, theta0, theta1)
        result = 0 
        plot.each do |x, y|
          result += (theta0 + theta1 * x) - y
        end 
        return result
      end

      def self.d_dt_for_theta1(plot, theta0, theta1)
         result = 0 
         plot.each do |x, y|
           result += ((theta0 + theta1 * x) - y) * x
         end
         return result
      end

      def self.cost_function(plot, theta0, theta1)
        result = 0
        m = plot.length
        plot.each do |x, y|
          dif = (theta0 + x * theta1) - y
          result += dif ** 2
        end
        return result / (2 * m)
      end
    end
  end
end

plot = {-3 => -6, -2 => -4, -1 => -2, 0 => 0, 1=> 2, 2 => 4, 3 => 6, 4=>8, 5=>10, 6=>12, 7=>14, 8=>16}
theta0, theta1 = Silicium::LinearRegression::LinearRegressionByGradientDescent::generate_function(plot)
puts theta0, theta1