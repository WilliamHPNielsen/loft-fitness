## Introduction

`Loft` or `loft-fitness` is a little CLI tool for tracking progress of fitness exercises. More to the point, it's an introductory exercise in Haskell for the author. But it could potentially be helpful to someone.

## The name

Is very similar to the word `løft` in Danish, which is the imperative verb `lift`. Do you even loft, bro?

## Build Instructions

As a preliminary step, go and get `stack`. Go [here](https://docs.haskellstack.org/en/stable/README/) to get it.

Then clone the `loft` repository
```
git clone git@github.com:WilliamHPNielsen/loft-fitness.git loft-fitness
```
and `cd` into the root directory of `loft`;
```
cd loft-fitness
```
Now build the package with `stack`:
```
stack build
```
If the above step works, you have succesfully built `loft`. Good job!

## Running the program

In the root directory of `loft`, do
```
stack exec loft-exe
```
This will execute `loft`.

## Usage

You use `loft` by entering sessions. First provide the name of the session you are currently logging, e.g. `bench press` or `push-ups`. Then enter weights and reps for each set until you are done, at which point you should enter `q` or `Q` as either weights or reps. This exists `loft`. You can rerun `loft` to log your next exercise.

The logfile with your weights and reps is called `sessions.log`. That name is currently hardcoded.

## Future plans

There are many. See the issues here: https://github.com/WilliamHPNielsen/loft-fitness