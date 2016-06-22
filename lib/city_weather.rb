require 'nokogiri'
require 'open-uri'
require 'unicode_utils/downcase'

class CityWeather

  def initialize(city_name_input)
    @city_name_input = UnicodeUtils.downcase(city_name_input)
    @uri = "https://sinoptik.ua/погода-#{@city_name_input}"
    @encoded_url = URI.encode(@uri)
    @url = URI.parse(@encoded_url)

    begin
      @page = Nokogiri::HTML(open(@url))
    rescue OpenURI::HTTPError => e
      puts "\nЯ хз, что это за город :("
      abort e.message
    rescue SocketError
      abort "Нет сети"
    end

    @city_name = @page.xpath("//div[@class = 'cityName cityNameShort']/h1/strong").text

    @temperature_now = @page.xpath("//div[@class = 'imgBlock']/p[2]").text
  end

  # выводит текущию погоду заданного города
  def show_t_now
    puts "\nСейчас #{@city_name} #{@temperature_now}"
  end

  # прогноз на неделю
  def show_7day
    puts "\nПрогноз погоды на неделю:"

    count_day = 0

    day = 1

    while count_day < 7
      weekday = @page.xpath("//div[@id='bd#{day}']/p[1]").text
      day_of_the_month = @page.xpath("//div[@id='bd#{day}']/p[2]").text
      month = @page.xpath("//div[@id='bd#{day}']/p[3]").text
      weather = UnicodeUtils.downcase(@page.xpath("//div[@id = 'bd#{day}']/div/@title").to_s)
      t_min = @page.xpath("//div[@id='bd#{day}']/div[@class='temperature']/div[1]/span").text
      t_max = @page.xpath("//div[@id='bd#{day}']/div[@class='temperature']/div[2]/span").text

      puts "#{weekday} #{day_of_the_month} #{month}, #{t_min} #{t_max}, #{weather}"

      count_day += 1
      day += 1
    end
  end

end