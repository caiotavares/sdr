using Plots
using Printf
using Statistics

fs = 2e6
T = 1/fs

raw = read("/Users/caio.tavares/dev/personal/sdr/adsb-40.bin")
n = length(raw) ÷ 2
t = collect(range(0, stop=20, step=1/fs))
I = (Float32.(@view raw[1:2:2n]) .- 127.4) ./ 127.4
Q = (Float32.(@view raw[2:2:2n]) .- 127.4) ./ 127.4
iq = complex.(I, Q)
m = abs.(iq)

preamble_y = [1; -1; 1; -1; -1; -1; -1; 1; -1; 1; -1; -1; -1; -1; -1; -1]
preamble_x = collect(range(0, stop=7.5, step=0.5))

plot(preamble_x, preamble_y, xticks = :all)

signal_samples = 224 # 112e-6/T
preamble_samples = 16

# Score based on ML for the preamble signal
scores = zeros(n)
for i=1:n
    (i + 15 > length(m)) && continue
    score = sum(preamble_y .* @view m[i:i+15])
    scores[i] = score
end

histogram(m[1:2_000_000]; bins = 200, yscale = :log10, legend = false)
# E = median(m)
# threshold = 2*E
# s_i = findall(>(threshold), m)
# plot(t[1:100], m[1:100], xformatter = val -> @sprintf("%.1e", val))
# k = 2887480
# k = 14038325
k = 38630026
plot(m[k:k+15])
vline!([1, 3, 8, 10], ls = :dash)

data = m[k+16:k+16+223]
plot(data)

bits = UInt8[]
for n=1:112
    if data[(n*2)-1] > data[(n*2)]
        push!(bits, 1)
    else
        push!(bits, 0)
    end
end

bytes = UInt8[]
for i in 1:14
    push!(bytes, reduce((acc, x) -> (acc << 1) | x, bits[i:i+7]))
end

println(bytes)

plot(scores[1:100])
findall(>(0), scores)
median(scores)
