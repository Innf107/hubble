#!/usr/bin/env polaris
description: "Benchmark runner for vega. Also shows comparisons with GHC and rustc"
options {
    "--categories" (*) as selectedCategories: "The benchmark categories to run. Defaults to running all benchmarks"
    "-f" "--vega-flag" (*) as vegaFlags: "Flags to pass to the vega compiler"
    "--check-correctness" as checkCorrectness: "Verify that all benchmark implementations agree on their result"
}

module List = import("@std/list.pls")

let basePath = !readlink "-f" (scriptLocal("."))

chdir(basePath)

!mkdir "-p" ".build"

# TODO: it would be nice to check that the categories are valid here
let categories = match selectedCategories {
    [] -> ["benchmarksgame"]
    _ -> selectedCategories
}

let benchmarks = lines(!find categories "-mindepth" 1 "-maxdepth" 1)

let buildVega(path) = {
    chdir(path)

    !vega "build" "-O3" vegaFlags

    chdir(basePath)
    !mv "${path}/a.out" ".build/${!basename path}-vega"
    ()
}

let buildRust(path) = {
    !rustc "-O" "${path}/src-rust/main.rs" "-o" ".build/${!basename path}-rust" "--allow" "warnings"
    ()
}

let buildHaskell(path) = {
    !ghc "-O2" "${path}/src-ghc/Main.hs" "-o" ".build/${!basename path}-ghc" "-v0" "-Wno-everything"
    ()
}

List.for(benchmarks, \path -> {
    print("\e[1m\e[34m~~~~~~~~~~~~~~~${path}~~~~~~~~~~~~~~~~\e[0m")
    buildVega(path)
    buildRust(path)
    buildHaskell(path)

    !hyperfine "--reference" ".build/${!basename path}-vega" ".build/${!basename path}-ghc" ".build/${!basename path}-rust" "--min-runs" 2
    ()
})
