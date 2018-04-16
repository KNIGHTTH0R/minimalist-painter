require 'rubygems'
require 'bundler/setup'
require 'oily_png'
require 'twitter'

client = Twitter::REST::Client.new do |config| # authenticate with twitter API
  config.consumer_key        = ""
  config.consumer_secret     = ""
  config.access_token        = ""
  config.access_token_secret = ""
end

def generate_hex
  hexa = ['a','b','c','d','e','f']
  decimal = ['0','1','2','3','4','5','6','7','8','9']
  valid_hex_values = hexa + decimal
  generated_hex = Array.new
  6.times do
    generated_hex.push(valid_hex_values.sample)
    end
    generated_hex = generated_hex.join(",").gsub(",","")
end

def generate_image(hex)
  png = ChunkyPNG::Image.new(256, 256, ChunkyPNG::Color::TRANSPARENT)
  pixels = 256
  pixels.times do |n|
    pixels.times do |x|
      png[n,x] = ChunkyPNG::Color.from_hex(hex)
     end
   end
   png.save("images/#{hex}.png", :interlace => true)
end

def tweet(client)
  generate_image(generate_hex)
  painting = Dir.glob(File.join('images', '*.*')).max { |a,b| File.ctime(a) <=> File.ctime(b) } # the painting file path is the most recent file in the folder
  painting_title = painting.slice(7,16).chomp('.png').upcase.prepend('#')
  tweet = "UNTITLED, #{painting_title} ON 256X256 PIXEL CANVAS, #{Time.now.year}"
  client.update_with_media(tweet,painting)
end

while true
  tweet(client)
  sleep(3600)
end
