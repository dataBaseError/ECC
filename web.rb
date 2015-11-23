require 'sinatra'
require_relative 'point_addition'

# Change this value to the hostname or IP
set :bind, '0.0.0.0'

get '/ecc' do

    erb :form, :locals => {:result => '', :p => '', :a => '', :b => '', :x1 => '',
        :y1 => '', :x2 => '', :y2 => '', :n => '', :point_1_valid => '', :point_2_valid => ''}
end

post '/ecc' do
    # Potentailly check if this is prime
    $p = params[:p].to_i
    $a = params[:a].to_i
    $b = params[:b].to_i
    point1 = Point.new(params[:x1].to_i, params[:y1].to_i)
    point2 = nil

    if params[:x2] && params[:y2] && params[:x2] != "" && params[:y2] != ""
        point2 = Point.new(params[:x2].to_i, params[:y2].to_i)
    end

    if point1
        point_1_valid = "Valid? #{validPoint($p, $a, $b, point1)}"
    end

    if point2 
        point_2_valid = "Valid? #{validPoint($p, $a, $b, point2)}"
    end

    result = nil
    pre_statement = nil

    # Check if the second point is set

    if params[:calc_nP] == "Calculate nP"
        if params[:n] && params[:n] != ""
            n = params[:n].to_i
            result = point1 * n
            pre_statement = "n * P = "
        end
    else 
        if point2
            result = point1 + point2
            pre_statement = "P + Q = "
        end
    end
    
    erb :form, :locals => {:result => "#{pre_statement}#{result} Valid? = #{validPoint($p, $a, $b, result)}", :p => $p, :a => $a, :b => $b, :x1 => point1.x,
        :y1 => point1.y, :x2 => params[:x2], :y2 => params[:y2], :n => params[:n], :point_1_valid => point_1_valid, :point_2_valid => point_2_valid}
end