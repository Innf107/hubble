
enum Tree {
    Empty,
    Node(Box<Tree>, Box<Tree>)
}

fn check(tree: &Tree) -> i64 {
    match tree {
        Tree::Empty => 0,
        Tree::Node(left, right) => check(left) + check(right) + 1
    }
}

fn makePerfectTree(depth: i64) -> Tree {
    match depth {
        0 => Tree::Node(Box::new(Tree::Empty), Box::new(Tree::Empty)),
        _ => Tree::Node(Box::new(makePerfectTree(depth - 1)), Box::new(makePerfectTree(depth - 1)))
    }
}

fn printOutput(treeKind: &str, depth: i64, check: i64) {
    println!("{treeKind} of depth {depth}\t check: {check}")
}

fn sumTrees(depth: i64, count: i64) -> i64 {
    let mut sum = 0;
    for i in (1..=count).rev() {
        sum += check(&makePerfectTree(depth));
    }
    sum
}

fn main() {
    let minDepth = 4;
    let maxDepth = 17;
    let stretchedDepth = maxDepth + 1;

    let stretchedTree = makePerfectTree(stretchedDepth);

    let stretchedCount = check(&stretchedTree);
    printOutput("stretch tree", stretchedDepth, stretchedCount);

    let longLivedTree = makePerfectTree(maxDepth);

    for depth in (minDepth..=maxDepth).step_by(2) {
        let count = 1 << (maxDepth - depth + 4);
        let sum = sumTrees(depth, count);

        let kind = format!("{count}\t trees");
        printOutput(&kind, depth, sum);
    }

    printOutput("long lived tree", maxDepth, check(&longLivedTree))
}

