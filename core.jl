function genMixtureCode(model, data)
  modelName = "mixture" * replace(string(gensym()), "##", "")
  code = ""
  code *= "@model $modelName begin\n"

  M = model["mixtureNum"]
  code *= "  M = $M\n"
  N = length(data)
  code *= "  N = $N\n"

  for i in 1:M, j in 1:length(model["priorDists"][i])
    code *= "  @assume p$i$j ~ model[\"priorDists\"][$i][$j]\n"
  end
  code *= "  ps = TArray{Tuple{Float64, Float64}}(M)\n"
  for i in 1:M
    code *= "  ps[$i] = ("
    for j in 1:length(model["priorDists"][i])
      code *= " p$i$j,"
    end
    code *= " )\n"
  end

  code *= "  cs = tzeros(Int, N)\n"
  code *= "  for i = 1:N\n"
  code *= "    @assume cs[i] ~ Categorical(M)\n"
  # TODO: fix this bug
  code *= "    @observe data[i] ~ eval(parse(\"\$(model[\"likDists\"][cs[i]])(\$(ps[cs[i]])...)\"))\n"
  code *= "  end\n"

  code *= "  @predict"
  for i in 1:M, j in 1:length(model["priorDists"][i])
    code *= " p$i$j"
  end
  code *= " cs"
  code *= "\n"

  code *= "end\n"
end



function inferMixture(model, data, alg)
  code = genMixtureCode(model, data)
  sample(eval(parse(code)), alg)
end



code = genMixtureCode(model, data)
