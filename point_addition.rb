
# This class was adapted from the source code from http://rosettacode.org/wiki/Modular_inverse#Ruby
class Utility
    #based on pseudo code from http://en.wikipedia.org/wiki/Extended_Euclidean_algorithm#Iterative_method_2 and from translating the python implementation.
    def Utility.extended_gcd(a, b)
      last_remainder, remainder = a.abs, b.abs
      x, last_x, y, last_y = 0, 1, 1, 0
      while remainder != 0
        last_remainder, (quotient, remainder) = remainder, last_remainder.divmod(remainder)
        x, last_x = last_x - quotient*x, x
        y, last_y = last_y - quotient*y, y
      end
     
      return last_remainder, last_x * (a < 0 ? -1 : 1)
    end
     
    def Utility.invmod(e, et)
      g, x = extended_gcd(e, et)
      if g != 1
        return "Invalid Input"
      end
      x % et
    end
end

$p = 11
$a = 1
$b = 6

def validPoint(p, a, b, point) 
    return (point.y * point.y) % p == (point.x * point.x * point.x + a * point.x + b) % p# where 4*a*a*a + 27 * b * b != 0
end

class Point

    attr_accessor :x, :y

    def initialize(x, y)
        @x, @y = x, y
    end

    def +(other)
        # Simple check to make sure that only point addition is done
        if other.is_a?(self.class)
            # Calculate the slope
            slope = calcSlope(other)

            new_x = (slope*slope - @x - other.x) % $p
            return Point.new(new_x, (slope * (@x - new_x) - @y) % $p) 
        end
        raise "Cannot Add Point to non Point type"
    end

    def -(other)
        return self + (-other)
    end

    def ==(other)
        return other != nil && @x == other.x && @y == other.y
    end

    def -@
        return Point.new(@x, -@y)
    end

    def *(times)
        # Simple check to ensure its only a integer number
        if times.is_a?(Fixnum)
            result = self
            (times-1).times do |x|
                result += self
            end
            return result
        end
        raise "Cannot Mutliply Point by non Fixnum type"
    end

    def to_s
        return "(#{@x}, #{@y})"
    end

    private

    def calcSlope(other)
        if self == other
            # Apply self slope calculation
            if x == 0
                raise 'Invalid Point Addition x == 0'
            end
            return ((3 * @x*@x + $a) * Utility.invmod(2 * @y, $p)) % $p
        else
            # Apply regular slope equation
            if @x == other.x 
                raise 'Invalid Point Addition, x1 == x2'
            end
            return ((other.y - @y) * Utility.invmod(other.x - @x, $p)) % $p
        end
    end

end

class Fixnum

    alias_method :mult_org, :*

    # Override the Fixnum multiplication operation to allow for Point multiplication
    def *(other) 
        if other.is_a?(Point)
            return other * self
        else
            return mult_org other
        end
    end
end


=begin
# Some test cases.
G = Point.new(2, 7)
pm = Point.new(10, 9)

Nb = 7
k = 3

B_pk = 7 * G
point3 = G + G
point4 = G * 2
kG = k * G
kB_pk = k * B_pk
encry_pm = pm + kB_pk

Nb_kG = Nb * kG

decy_pm = encry_pm - Nb_kG
#p point3

# Single addition of the same point:
puts "#{G} + #{G} = #{point3}"

# Multiplication of a point (using Fixnum's multiplication implementation):
puts "B Public Key = 7 * #{G} = #{B_pk}"

# Mutliplcation of a point (using Point's multiplication implementation):
puts "#{G} * 2 = #{point4}"

# Calculate kG:
puts "kG = #{k} * #{G} = #{kG}"

# Calculate 3*B_pk:
puts "k * B_pk = #{k} * #{B_pk} = #{kB_pk}"
# Calculate encrytped message:
puts "#{pm} + #{kB_pk} = #{encry_pm}"

puts "Nb * kG = #{Nb} * #{kG} = #{Nb_kG}"

# Test subtraction
puts "Pm = encry_pm - Nb_kG = #{decy_pm}"

# Test inverse operation
puts "- Nb_kG = #{-Nb_kG}"

=end