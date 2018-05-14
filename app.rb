require 'discordrb'
require 'nokogiri'
require 'open-uri'

bot = Discordrb::Commands::CommandBot.new token: 'ACCES_TOKEN', client_id: CLIENT_ID, prefix: '!'

bot.command :metar do |event, *code|

        icao = code[0].upcase

        url = "https://www.time-j.net/MetarApp/MetarTaf/#{icao}"

        charset = nil

        html = open(url) do |f|
                charset = f.charset
                f.read
        end

        doc = Nokogiri::HTML.parse(html, nil, charset)
        metar = doc.xpath('/html/body/div/div/div/div/table/tr/td')[17].inner_text
        event.send_message("#{metar}")

        hpa = metar.gsub(/((.+?)Q| TEMPO(.+)| NOSIG(.+)| NOSIG| RMK(.+))/, "")
        hpa = hpa.to_f
        pa = hpa * 100
        inHg = (pa / 3386.389).round(2)

        event.send_message("#{inHg} inHg")
end
