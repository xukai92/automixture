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
  )
]

model = predefinedModels[1]

data = [1, 1, 1, 1, 1, 1]


code = genMixtureCode(model, data)
eval(parse(code))

Turing.TURING[:modelex]

chain = sample(mixture_auto, SMC(1000))
println("p11:\t", mean(chain[:p11]), "\np12:\t", mean(chain[:p12]), "\ncs:\t", mean(chain[:cs]))
