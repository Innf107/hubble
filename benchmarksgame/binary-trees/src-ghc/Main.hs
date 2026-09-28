{-# LANGUAGE OverloadedStrings, Strict #-}
module Main where

import Data.Text (Text)
import Data.Text qualified as Text
import Data.Text.IO qualified as Text.IO

data Tree
    = Empty
    | Node !Tree !Tree

check :: Tree -> Int
check(tree) = case tree of
    Empty -> 0
    Node left right -> check left + check right + 1


makePerfectTree :: Int -> Tree
makePerfectTree depth = case depth of
    0 -> Node Empty Empty
    _ -> Node (makePerfectTree(depth - 1)) (makePerfectTree(depth - 1))


printOutput :: Text -> Int -> Int -> IO ()
printOutput treeKind depth count = do
    Text.IO.putStrLn (treeKind <> " of depth " <> Text.show depth <> "\t check: " <> Text.show count)


sumTrees :: Int -> Int -> Int -> Int
sumTrees depth i sum = case i of
    0 -> sum
    _ -> sumTrees depth (i - 1) (sum + check (makePerfectTree depth))

main :: IO ()
main = do
    let minDepth = 4
    let maxDepth = 17
    let stretchedDepth = maxDepth + 1

    let stretchedTree = makePerfectTree stretchedDepth

    let stretchedCount = check stretchedTree
    printOutput "stretch tree" stretchedDepth stretchedCount

    let longLivedTree = makePerfectTree(maxDepth);

    let printAtDepths depth max
            | depth <= max =do
                let count = 2^(max - depth + 4)
                let sum = sumTrees depth count 0
                printOutput (Text.show count <> "\t trees") depth sum

                printAtDepths (depth + 2) max
            | otherwise = pure ()
    printAtDepths minDepth maxDepth

    printOutput "long lived tree" maxDepth (check longLivedTree)


