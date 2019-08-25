## Introduction

`Loft` or `loft-fitness` is a little CLI tool for tracking progress of fitness exercises. More to the point, it's an introductory exercise in Haskell for the author. But it could potentially be helpful to someone.

## The name

Is very similar to the word `løft` in Danish, which is the imperative verb `lift`. Do you even loft, bro?

## Build Instructions

### Using cabal

In the root directory of `loft`, do
```
cabal v2-configure
cabal v2-build
```

### Using ghc

In the root directory of `loft`, do
```
ghc -dynamic main.hs
```

## Running `loft`

After building, execute `main`.

## Usage

Run `main`, type in your reps. Everything is currently stored in a file in the root directory called `sessions.log`.

## Future plans

There are many. See the issues here: https://github.com/WilliamHPNielsen/loft-fitness