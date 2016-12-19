using Distributions, Turing


predefinedModels = [
  Dict(
    "mixtureNum" => 1,
    "priorDists" => [
      (Normal(0, 4), Gamma(2, 3))
    ],
    "likDists" => [
      :Normal
    ]
  ),
  Dict(
    "mixtureNum" => 2,
    "priorDists" => [
      (Normal(0, 4), Gamma(2, 3)),
      (Normal(10, 4), Gamma(2, 3))
    ],
    "likDists" => [
      :Normal, :Normal
    ]
  ),
  Dict(
    "mixtureNum" => 1,
    "priorDists" => [
      (Normal(10, 4), Gamma(2, 3))
    ],
    "likDists" => [
      :Normal
    ]
  )
]

data = [1, 1, 1, 1, 1, 1, 10, 10, 10, 10]

model = predefinedModels[2]

@model b121 begin
  M = 2
  N = 10
  @assume p11 ~ model["priorDists"][1][1]
  @assume p12 ~ model["priorDists"][1][2]
  @assume p21 ~ model["priorDists"][2][1]
  @assume p22 ~ model["priorDists"][2][2]
  ps = TArray{Tuple{Float64, Float64}}(M)
  ps[1] = ( p11, p12, )
  ps[2] = ( p21, p22, )
  cs = tzeros(Int, N)
  for i = 1:N
    @assume cs[i] ~ Categorical(M)
    @observe data[i] ~ eval(parse("$(model["likDists"][cs[i]])($(ps[cs[i]])...)"))
  end
  @predict p11 p12 p21 p22 cs
end
