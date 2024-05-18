# # World population

# This example was contributed by Martijn Visser (@visr)
using Makie, CairoMakie, GeoMakie
CairoMakie.activate!(px_per_unit = 4) # hide

using GeoMakie: GeoJSON
using GeometryBasics
using Downloads

source = "+proj=longlat +datum=WGS84"
dest = "+proj=natearth2"

land = GeoMakie.assetpath("ne_110m_land.geojson")
land_geo = GeoJSON.read(read(land, String))
pop = GeoMakie.assetpath("ne_10m_populated_places_simple.geojson")
pop_geo = GeoJSON.read(read(pop, String))

begin
    fig = Figure(size = (1000,500))
    ga = GeoAxis(
        fig[1, 1];
        source = source,
        dest = dest
    )

    ga.xticklabelsvisible[] = false
    ga.yticklabelsvisible[] = false
    poly!(ga, land_geo, color=:black)
    popisqrt = map(pop_geo) do geo
        popi = geo.pop_max
        popi > 0 ? sqrt(popi) : 0.0
    end
    mini, maxi = extrema(popisqrt)
    msize = map(popisqrt) do popi
        normed = (popi .- mini) ./ (maxi - mini)
        return (normed * 20) .+ 1
    end
    scatter!(ga, pop_geo; color=popisqrt, markersize=msize)
    fig
end
#
# make cover image #jl
mkpath("covers") #hide
save("covers/$(splitext(basename(@__FILE__))[1]).png", fig) #hide
nothing #hide
