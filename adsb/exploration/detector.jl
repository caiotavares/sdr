using Plots
using Printf
using Statistics

function score(m, threshold)
    # Score based on ML for the preamble signal
    preamble_y = [1; -1; 1; -1; -1; -1; -1; 1; -1; 1; -1; -1; -1; -1; -1; -1]
    indexes = findall(>(threshold), m)
    scores = Tuple{Int64,Float64}[]

    for i in indexes
        (i + 15 > length(m)) && continue
        score = sum(preamble_y .* @view m[i:(i+15)])
        push!(scores, (i, score))
    end

    return sort(scores, by=x -> x[2])
end

function to_bits(data)
    bits = UInt8[]
    for n=1:112
        if data[(n*2)-1] > data[(n*2)]
            push!(bits, 1)
        else
            push!(bits, 0)
        end
    end
    return bits
end

function to_bytes(bits)
    bytes = UInt8[]
    for i in 1:14
        push!(bytes, reduce((acc, x) -> (acc << 1) | x, bits[(i*8-7):(i*8)]))
    end
    return bytes
end

function to_complex(raw)
    n = length(raw) ÷ 2
    I = (Float32.(@view raw[1:2:2n]) .- 127.5) ./ 127.5
    Q = (Float32.(@view raw[2:2:2n]) .- 127.5) ./ 127.5
    return complex.(I, Q)
end

function crc()

end

function detect(iq, threshold)
    m = abs.(iq)
    candidates = score(m, threshold)

    signal = []
    for (i, _) in candidates
        (i + 16 + 223 > length(m)) && continue
        data = m[(i+16):(i+16+223)]
        push!(signal, to_bytes(to_bits(data)))
    end
    return signal
end
