using Distributions, Turing

include("core.jl")

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

model = predefinedModels[1]

res = inferMixture(model, data, SMC(1000))

# Turing.TURING[:modelex]

# println(res)
println("logevidence:\t", res[:logevidence])
# println("p11:\t", mean(res[:p11]), "\np12:\t", mean(res[:p12]), "\ncs:\t", mean(res[:cs]))
