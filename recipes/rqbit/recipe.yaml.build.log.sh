#!/bin/sh

recipe=recipes/rqbit/recipe.yaml

args=(
  rattler-build build
  --recipe $recipe
  --variant-config recipes/rqbit/variant_config.yaml
)

"${args[@]}" &>$recipe.build.log
