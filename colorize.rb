normal = "#b7ce42"
important = "#fea63c"
critical = "#e84f4f"

unless !$*.empty? && (1..6) === $*.length
    puts "Usage: #{ $0 } current important critical operator unit [output]"
    exit
end

current = eval($*[0]).to_f.to_s

if $*.length == 6
	output = $*[5]
else
	output = $*[0]
end

output += $*[4]

if eval(current + $*[3] + $*[1])
	puts "^fg(#{ normal })#{ output }^fg()"
elsif eval(current + $*[3] + $*[2])
	puts "^fg(#{ important })#{ output }^fg()"
else
	puts "^fg(#{ critical })#{ output }^fg()"
end
