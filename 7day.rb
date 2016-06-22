# Прогноз погоды на неделю
# взято с сайта https://sinoptik.ua
# encoding: utf-8
# Этот код необходим при использовании русских букв на Windows
if (Gem.win_platform?)
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end
###

require_relative 'lib/city_weather'

puts "Для какого города хотите узнать погоду?"

weather = CityWeather.new(STDIN.gets.chomp)

weather.show_t_now

weather.show_7day