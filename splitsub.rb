def flotize( hours, minutes, seconds, milliseconds )
    hours.to_s.to_i * 3600 + minutes.to_s.to_i * 60 + (seconds + '.' + milliseconds).to_s.to_f
end

def h_to_s ( h )
    hours = (h / 3600).truncate
    minutes = ((h - hours * 3600) / 60).truncate
    seconds = (h - hours * 3600 - minutes * 60).truncate
    milliseconds = ("%.3f" % (h - hours * 3600 - minutes * 60 - seconds)).gsub!( /0\./, '' )
    sprintf("%02d:%02d:%02d,%s", hours, minutes, seconds, milliseconds)
end

unless !$*.empty? && (1..2) === $*.length
    print "Usage: #{ $0 } filename.srt displacement #{ $/ }"
    exit
end

curr_file = 1
cutted = false
line_number = 1
base = nil

f = File::open( $*[0][0..-4] + curr_file.to_s + '.srt', 'w' )

File::open( $*[0] ) do |subs|
    subs.each_line do |line|
        if /^\[CUT\]\s$/.match( line )
            f.close
            curr_file += 1
            cutted = true
            f = File::open( $*[0][0..-4] + curr_file.to_s + '.srt', 'w' )
            next
        end
        if cutted
            if /^\d+\s$/.match( line )
                line = line_number.to_s + "\r\n"
                line_number += 1
            elsif matchobj = /^(\d{2}):(\d{2}):(\d{2}),(\d{3}) --> (\d{2}):(\d{2}):(\d{2}),(\d{3})\s$/.match( line )
                start_t = flotize( matchobj[1], matchobj[2], matchobj[3], matchobj[4] )
                end_t = flotize( matchobj[5], matchobj[6], matchobj[7], matchobj[8] )
                base ||= start_t
                new_start_t = start_t - base + $*[1].to_f
                new_end_t = end_t - base + $*[1].to_f
                line = h_to_s( new_start_t ) + ' --> ' + h_to_s( new_end_t ) + "\r\n"
            end
        end
        f.write( line )
    end
end

f.close
