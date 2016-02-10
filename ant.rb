class Integer
  @@brailles = '⠀⢀⠠⢠⠐⢐⠰⢰⠈⢈⠨⢨⠘⢘⠸⢸⡀⣀⡠⣠⡐⣐⡰⣰⡈⣈⡨⣨⡘⣘⡸⣸'\
               '⠄⢄⠤⢤⠔⢔⠴⢴⠌⢌⠬⢬⠜⢜⠼⢼⡄⣄⡤⣤⡔⣔⡴⣴⡌⣌⡬⣬⡜⣜⡼⣼'\
               '⠂⢂⠢⢢⠒⢒⠲⢲⠊⢊⠪⢪⠚⢚⠺⢺⡂⣂⡢⣢⡒⣒⡲⣲⡊⣊⡪⣪⡚⣚⡺⣺'\
               '⠆⢆⠦⢦⠖⢖⠶⢶⠎⢎⠮⢮⠞⢞⠾⢾⡆⣆⡦⣦⡖⣖⡶⣶⡎⣎⡮⣮⡞⣞⡾⣾'\
               '⠁⢁⠡⢡⠑⢑⠱⢱⠉⢉⠩⢩⠙⢙⠹⢹⡁⣁⡡⣡⡑⣑⡱⣱⡉⣉⡩⣩⡙⣙⡹⣹'\
               '⠅⢅⠥⢥⠕⢕⠵⢵⠍⢍⠭⢭⠝⢝⠽⢽⡅⣅⡥⣥⡕⣕⡵⣵⡍⣍⡭⣭⡝⣝⡽⣽'\
               '⠃⢃⠣⢣⠓⢓⠳⢳⠋⢋⠫⢫⠛⢛⠻⢻⡃⣃⡣⣣⡓⣓⡳⣳⡋⣋⡫⣫⡛⣛⡻⣻'\
               '⠇⢇⠧⢧⠗⢗⠷⢷⠏⢏⠯⢯⠟⢟⠿⢿⡇⣇⡧⣧⡗⣗⡷⣷⡏⣏⡯⣯⡟⣟⡿⣿'.chars

  def to_braille
    if self < 256
      @@brailles[self]
    else
      ''
    end
  end
end

require 'bundler/setup'
require 'twitter'
require 'yaml'

rest = Twitter::REST::Client.new(YAML.load_file('./settings.yaml'))

width  = 46
height =  3

field = Array.new(height * 4) {Array.new(width * 2) {0}}

y = rand(field.size)
x = rand(field.first.size)
d = rand(Math::PI * 2)

loop do
  d += Math::PI * (field[y][x] - 0.5)
  field[y][x] = 1 - field[y][x]
  y = (y + Math.sin(d).round) % field.size
  x = (x + Math.cos(d).round) % field.first.size

  tweet = ''
  field.each_slice(4) do |row|
    row.transpose.each_slice(2) do |chr|
      tweet << chr.join.to_i(2).to_braille
    end
    tweet << "\n"
  end

  rest.update(tweet)

  sleep 60
end

