#!/usr/bin/env ruby
# Q.E.D. http://www.nicovideo.jp/watch/sm19350799

require 'readline'

def atom token
  begin
    return Integer(token)
  rescue ArgumentError
    return String(token)
  end
end

def read_from tokens
  raise SyntaxError.new("unexpected EOF while reading") if tokens.length == 0
  token = tokens.shift
  if "(" == token
    ret = []
    while tokens.first != ")"
      ret << read_from(tokens)
    end
    tokens.shift
    return ret
  elsif ")" == token
    raise SytaxError.new("unexpected )")
  else
    return atom(token)
  end
end

def tokenize str
  str.gsub!(/-/, " - ")
  %W[( ) + * /].each do |op|
    str.gsub!(/#{"\\"+op}/," #{op} ")
  end
  str.split
end

def cal op,args
  arg[0].methos(op.to_sym).call(args[1])
end

def reform lst
  ret = []
  i = 0
  while i < lst.length
    e = lst[i]
    if e == "*" or e == "/"
      ret << [ret.pop, e, lst[i+1]]
      i += 2
    else 
      ret << e
      i += 1
    end
  end
  ret
end

def evaluate lst
  if lst.class != Array
    return lst
  end

  ret = evaluate(lst[0])
  i = 1
  while i<lst.length
    if lst[i] =~ /[\+\-\*\/]/
      ret = ret.method(lst[i].to_sym).call(evaluate(lst[i+1]))
      i += 2
    else
      i += 1
    end
  end

  ret
end

def calc str
  evaluate(reform(read_from(tokenize("("+str+")"))))
end

def gen_prob
  ret = []
  6.times do |i|
    ret << rand(20)+1
  end
  ret
end

def check nums,lst
  nums.each do |n|
    if lst.index(n.to_s) == nil
      return false
    end
  end
  return true
end

nums = gen_prob
result = nums[0]
nums = nums[1..-1]
puts "make #{result} with #{nums}"
while buf = Readline.readline("> ", true)
  if check(nums,tokenize("("+buf+")").flatten) and calc(buf) == result
    puts "ok"
    exit
  else
    puts "incorrect"
  end
end


