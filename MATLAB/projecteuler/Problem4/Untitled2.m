number=906609
for i=101:999
    if mod(number,i)==0
        if number/i>=100&&number/i<1000
            i
        end
    end
end