#!/usr/bin/env ruby
# Q.E.D. http://www.nicovideo.jp/watch/sm19350799

require 'readline'

def calc str
  begin
    return eval(str)
  rescue SyntaxError
    return -1
  end
end

def check nums,str
  (not /[^0-9\(\)\+\-\*\/\s]/ =~ str) and
    nums.sort == str.scan(/\d+/).map{|i| i.to_i}.sort
end

def gen_prob
  ret = []
  6.times do |i|
    ret << rand(20)+1
  end
  {:result=>ret[0],:nums=>ret[1..-1]}
end

prob = gen_prob
puts "make #{prob[:result]} with #{prob[:nums]}"
while buf = Readline.readline("> ", true)
  if check(prob[:nums], buf) and calc(buf) == prob[:result]
    puts "ok"
    exit
  else
    puts "incorrect"
  end
end
