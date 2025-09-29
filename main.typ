#import "@preview/fletcher:0.5.5" as fletcher: diagram, edge, node
#import "@preview/booktabs:0.0.4": *
#show: booktabs-default-table-style

#set page(height: auto)
// #set page(paper: "us-letter", numbering: "1/1")
#set list(marker: [--])
#let qed = [#math.square]

// #show figure: it => []

- an undirected graph is $G = (V,E)$, with $V$ the vertices, $E$ the edges. $V = {V_1, V_2, ..., V_n}$ is a set of objects, $E$ a set of connections between the objects s.t. $forall e in E, e = {u,v}$ with $u,v in V$.

- a directed graph differs in its edges $E$, where  $forall e in E, e = (u,v)$ with $u,v in V$.

- a subgraph of $G$ is $H = (V_H, E_H)$ where $V_n subset.eq V, E_H subset.eq E$, and $(forall e = (u,v) in E) (u,v in V_H)$

- connected component: maximal connected subgraph (can't connect more nodes)

- a cycle in $G = (V, E)$ is a sequence of nodes ${v_k} in V$ s.t. ${v_i, v_(i+1)} in E and {v_1, v_k} in E$

- a tree is an acyclic connected graph

- greedy algorithm:
  - local optimal decision to try solving a global problem
  - decisions are irrevocable (helpful for easy time complexity proofs)

- Minimum spanning tree (MST) problem: given an undirected connected graph $G$ and nonnegative weights $d(e)=d(u,v)$, find the subgraph $T$ that connects all vertices and minimizes $ "cost"(T) = sum_({u,v} in T) d(u,v) $

  - think about why $T$ must be a tree. if there are cycles, you can trivially rm an edge to cut costs

  - MST Cycle Property: let a cycle $C$ be in $G$. the heaviest edge on the cycle $C$ is not in $G$'s MST.

  - MST Cut Property: let $S subset.eq V$, s.t. $1 <= |S| < |V|$, i.e. $S$ is not empty but not all nodes. Call a pair $(S, V without S)$ a cut of the graph. Every MST of $G$ contains the lightest edge on the cut (where an "edge on the cut" is some $e = {u, v}, u in S, v in V without S$).

  - Prim's alg

    - description
      - given graph $G$, choose arb node $s$, the start of $T$
      - repeating $|V| - 1$ times,
        - add to $T$, the lowest edge (and nodes) from "in $T$" to "not in $T$"

    - proof
      - The pair ("in $T$", "not in $T$") is a cut of $G$. By the Cut Property, the MST contains the lowest cost edge crossing this cut, which is by defn the next edge Prim's adds, i.e. Prim's adds edges in the MST.

        At any point in the algorithm, $T = (V_T, E_T)$ is a subgraph and a tree. $T$ grows by 1 vertex and 1 edge at each step, stopping at $|V_G| - 1$ steps, and so results in a spanning tree. Since these edges are in the MST from above, the spanning tree is the MST. #qed

    - impl

      - (min) heap ADT

        - interface
          - `fn new(items) -> Self;`
          - `fn min() -> Item;`
          - `fn insert(item);`
          - `fn delete(item);`

        - heap-ordered-tree (as an array) implementation
          #figure(
            caption: [notice the monotonic decreasing upward. Also notice the array implementation, where $op("traverse_left")(i) = 2i$ and $op("traverse_right")(i) = 2i + 1$.],
            diagram(
              // debug: true,
              spacing: 0em, // small column gaps, large row spacing
              cell-size: (2em, 3em),
              node-inset: 0em,
              node((0, 0), [2]),
              node((1, 1), [8]),
              node((2, 1), [3]),
              node((3, 2), [12]),
              node((4, 2), [9]),
              node((5, 2), [7]),
              node((6, 2), [10]),
              edge((0, 0), (1, 1), "->"),
              edge((0, 0), (2, 1), "->"),
              edge((1, 1), (3, 2), "->"),
              edge((1, 1), (4, 2), "->"),
              edge((2, 1), (5, 2), "->"),
              edge((2, 1), (6, 2), "->"),
            ),
          )
          - `new` $in O(n)$; take items as array, for all elements (indices right to left), sift down
          - `min` $in O(1)$; it's at the top of the tree
          - `insert` $in O(log n)$; insert as leaf preserving shape (aka dense array), sift up
          - `delete` $in O(log n)$; swap with leaf, delete, sift swapped down

      - work of Prim's with a heap is $O(m log n)$
        + $O(n)$; create empty heaparray (for max $n$ items)
        + $O(1)$; choose arb start node $u$
        + $O(log n)$ work per heap operation, $O(m)$ times total (because we only nbors the edges that much, trust. see your example); $forall v in op(#raw("nbors")) (u),$ if $v$ is closer to $T$ than our saved distance from $v$ to $T$, update this distance (and also set parent of $v$ to $u$). With a heap, do `del(v); insert(v, d(u, v))` or just `decreaseKey(v, d(u, v))`. TODO parent??
        + $O(log n)$; set $u$ to closest node to $T$ (min of heap) and delete it
        + $O(n)$ repetitions; while $u$ exists, go to (3)

        - this is $O(m log n + n log n)$ from (3) and repeating (4), which is $in O(m log n)$

  - Reverse Delete

    - description
      - start with $G$
      - repeating $|V| - 1$ times
        - remove edges by decreasing weight unless it'd split the graph

    - proof
      - tree bc we removed all cycles by defn of algorithm
      - spanning bc $|V| - 1$ thing and non-split clause
      - minimum: at some step, let $e$ be the next edge removed. Since it's removed, it's in a cycle and must be the largest edge in it. By cycle property, all removed edges are not in the MST.

  - Kruskal's alg

    - description
      - start with $T = (V, {})$, i.e. all the nodes and no edges
      - repeating $|V| - 1$ times
        - add edges in increasing order unless it creates a cycle

    - proof
      - tree bc we didn't connect in a cycle... but why is output connected?
      - spanning bc $|V| - 1$ thing and tree
      - minimum: at some step, let $e$ be the next edge added. All rejected edges would have created cycles, and must be the max in the cycle they create by algo defn. This means, by cycle property, it's MST.

    - impl

      - union-find abstract data type (ADT)

        - interface
          - `fn new(items) -> Self;` splits items into that many sets
          - `fn find(item) -> Label;` finds the set the item belongs to
          - `fn union(a, b);` merges two sets

        - array-based implementation
          #figure(caption: [array-based union-find], diagram(
            // debug: true,
            spacing: 0em, // small column gaps, large row spacing
            cell-size: (2em, 1.5em),
            node-inset: 0em,

            // index col
            node((0, 0), [index], width: 3em),
            node((0, 1), [1]),
            node((0, 2), [2]),
            node((0, 3), [3]),
            node((0, 4), [4]),
            node((0, 5), [5]),
            node((0, 6), [6]),
            node((0, 7), [7]),

            // item lists
            node((1, 0), [item lists], width: 4em),
            node((1, 1), $$, stroke: 1pt, shape: rect, width: 2em, height: 1.5em),
            node((1, 2), $$, stroke: 1pt, shape: rect, width: 2em, height: 1.5em),
            node((1, 3), $$, stroke: 1pt, shape: rect, width: 2em, height: 1.5em),
            node((1, 4), $$, stroke: 1pt, shape: rect, width: 2em, height: 1.5em),
            node((1, 5), $$, stroke: 1pt, shape: rect, width: 2em, height: 1.5em),
            node((1, 6), $$, stroke: 1pt, shape: rect, width: 2em, height: 1.5em),
            node((1, 7), $$, stroke: 1pt, shape: rect, width: 2em, height: 1.5em),

            edge((1, 1), (2, 1), "-|>", snap-to: (none, auto)),
            edge((1, 3), (2, 3), "-|>", snap-to: (none, auto)),
            edge((1, 4), (2, 4), "-|>", snap-to: (none, auto)),
            edge((1, 7), (2, 7), "-|>", snap-to: (none, auto)),

            node((2, 1), [1]),
            node((2, 3), [3]),
            node((2, 4), [4]),
            node((2, 7), [7]),

            edge((2, 1), (3, 1), "-|>"),
            edge((2, 3), (3, 3), "-|>"),

            node((3, 1), [5]),
            node((3, 3), [2]),

            edge((3, 1), (4, 1), "-|>"),

            node((4, 1), [6]),

            // size lists

            node((5, 0), [size], width: 4em),
            node((5, 1), [3], stroke: 1pt, shape: rect, width: 2em, height: 1.5em),
            node((5, 2), [], stroke: 1pt, shape: rect, width: 2em, height: 1.5em),
            node((5, 3), [2], stroke: 1pt, shape: rect, width: 2em, height: 1.5em),
            node((5, 4), [1], stroke: 1pt, shape: rect, width: 2em, height: 1.5em),
            node((5, 5), [], stroke: 1pt, shape: rect, width: 2em, height: 1.5em),
            node((5, 6), [], stroke: 1pt, shape: rect, width: 2em, height: 1.5em),
            node((5, 7), [1], stroke: 1pt, shape: rect, width: 2em, height: 1.5em),

            // set label lists

            node((6, 0), [set], width: 4em),
            node((6, 1), [1], stroke: 1pt, shape: rect, width: 2em, height: 1.5em),
            node((6, 2), [3], stroke: 1pt, shape: rect, width: 2em, height: 1.5em),
            node((6, 3), [3], stroke: 1pt, shape: rect, width: 2em, height: 1.5em),
            node((6, 4), [4], stroke: 1pt, shape: rect, width: 2em, height: 1.5em),
            node((6, 5), [1], stroke: 1pt, shape: rect, width: 2em, height: 1.5em),
            node((6, 6), [1], stroke: 1pt, shape: rect, width: 2em, height: 1.5em),
            node((6, 7), [7], stroke: 1pt, shape: rect, width: 2em, height: 1.5em),
          ))
          - `new` $in O(n)$; creates the three lists
          - `find` $in O(1)$; size array lookup
          - `union` $in O(log n)$ amortized;
            - procedure
              + find smaller set ($x<=y$)
              + for each $x_i$, make `set[elem]` be $y$
              + update sizes array
              + prepend smaller to larger list
            - proof
              - (2) is computation. others $O(1)$
              - after $k$ unions, $<= 2k$ items touched
              - for any item $v$, `set[v]` is relabeled $<= log_2 2k$ times (TODO WTF WHY) ($2k$ is the \# of items in the largest set????)
              - $2k log_2 2k in O(k log k)$ work

        - tree-based implementation
          #figure(caption: [tree-based union-find.], diagram(
            // debug: true,
            spacing: 1em,
            node((1, 0), [1]),
            node((1, 1), [3]),
            node((0, 1), [10]),
            node((2, 1), [4]),
            node((4, 0), [9]),
            node((4, 1), [2]),
            node((5, 1), [6]),
            node((6, 0), [5]),
            node((8, 0), [7]),
            node((8, 1), [8]),
            edge((0, 1), (1, 0), "-|>"),
            edge((1, 1), (1, 0), "-|>"),
            edge((2, 1), (1, 0), "-|>"),
            edge((4, 1), (4, 0), "-|>"),
            edge((5, 1), (4, 0), "-|>"),
            edge((8, 1), (8, 0), "-|>"),
          ))
          - `new` $in O(n)$
            - let `struct Node { parent: Option<&Node>, height: uint }`
            - create an array of node addresses, so we can get from a node id to its node in $O(1)$
            - create all singleton nodes
          - `find` $in O(log n)$; follow ptrs to the root, which is the set label
            - proof
              - set at $i$ is renamed at most $log_2 n$ times because each renaming doubles size
              - depth of tree is number of renamings
          - `union` $in O(1)$ (amortized?); move pointer, update height. is this really all we do?

      - work of Kruskal's for array-based union-find is $O(m log n)$
        - sorting edges $in O(m log m) in O(m log n)$
        - because $m <= n^2$, so $log m <= log n^2 = 2 log n$
        - at most $2m$ `find` operations $in O(2m)$ (to check if edge would create cycle)
        - at most $n-1$ `union` ops in $O(n log n)$
        - total runtime $in O(m log n + 2m + n log n) in O(m log n)$

      - work of Kruskal's for tree-based union-find is also $O(m log n)$
        - sorting edges $in O(m log n)$ from above
        - at most $2m$ `find` ops $in O(2m log n)$
        - at most $n - 1$ union ops $in O(n)$
        - total runtime $in O(m log n + 2m log n + n) in O(m log n)$

- graph traversal problem: suppose a graph $G = (V, E)$. Find a path from a node $s$ to $t$ if it exists.
  - depth-first search
    #figure(caption: [depth-first search], diagram(
      // https://quiver.theophile.me/#r=typst&q=WzAsOCxbMCwwLCIxIl0sWzAsMSwiMiJdLFswLDIsIjMiXSxbMCwzLCI1Il0sWzAsNCwiNCJdLFsxLDQsIjYiXSxbMSwzLCI3Il0sWzIsNCwiOCJdLFswLDEsIiIsMCx7InN0eWxlIjp7ImhlYWQiOnsibmFtZSI6Im5vbmUifX19XSxbMSwyLCIiLDAseyJzdHlsZSI6eyJoZWFkIjp7Im5hbWUiOiJub25lIn19fV0sWzIsMywiIiwwLHsic3R5bGUiOnsiaGVhZCI6eyJuYW1lIjoibm9uZSJ9fX1dLFszLDQsIiIsMCx7InN0eWxlIjp7ImhlYWQiOnsibmFtZSI6Im5vbmUifX19XSxbMyw1LCIiLDAseyJzdHlsZSI6eyJoZWFkIjp7Im5hbWUiOiJub25lIn19fV0sWzIsNiwiIiwwLHsic3R5bGUiOnsiaGVhZCI6eyJuYW1lIjoibm9uZSJ9fX1dLFs2LDcsIiIsMCx7InN0eWxlIjp7ImhlYWQiOnsibmFtZSI6Im5vbmUifX19XSxbMCwyLCIiLDAseyJjdXJ2ZSI6LTMsInN0eWxlIjp7ImJvZHkiOnsibmFtZSI6ImRhc2hlZCJ9fX1dLFsxLDMsIiIsMCx7ImN1cnZlIjozLCJzdHlsZSI6eyJib2R5Ijp7Im5hbWUiOiJkYXNoZWQifSwiaGVhZCI6eyJuYW1lIjoibm9uZSJ9fX1dLFsxLDQsIiIsMCx7ImN1cnZlIjo0LCJzdHlsZSI6eyJib2R5Ijp7Im5hbWUiOiJkYXNoZWQifSwiaGVhZCI6eyJuYW1lIjoibm9uZSJ9fX1dLFsyLDcsIiIsMCx7ImN1cnZlIjotMywic3R5bGUiOnsiYm9keSI6eyJuYW1lIjoiZGFzaGVkIn0sImhlYWQiOnsibmFtZSI6Im5vbmUifX19XV0=
      spacing: 1em,
      node((0, 0), [$1$]),
      node((0, 1), [$2$]),
      node((0, 2), [$3$]),
      node((0, 3), [$5$]),
      node((0, 4), [$4$]),
      node((1, 4), [$6$]),
      node((1, 3), [$7$]),
      node((2, 4), [$8$]),
      edge((0, 0), (0, 1)),
      edge((0, 1), (0, 2)),
      edge((0, 2), (0, 3)),
      edge((0, 3), (0, 4)),
      edge((0, 3), (1, 4)),
      edge((0, 2), (1, 3)),
      edge((1, 3), (2, 4)),
      edge((0, 0), (0, 2), "..", bend: 54deg),
      edge((0, 1), (0, 3), "..", bend: -54deg),
      edge((0, 1), (0, 4), "..", bend: -72deg),
      edge((0, 2), (2, 4), "..", bend: 54deg),
    ))

    - theorem: adjacent edges are not on the same level. That is, if $(x,y) in E$, $x$ is either an ancestor or descendant of $y$.
      - proof: WLOG, let $x$ ancestor of $y$. When we pass $x$, we haven't seen $y$. All nodes between initially seeing $x$ and leaving $x$ are decendants of $x$. So, $y$ must have been explored before leaving $x$, as a descendant.

  - breadth-first search
    #figure(caption: [breadth-first search], diagram(
      // https://quiver.theophile.me/#r=typst&q=WzAsOCxbMSwwLCIxIl0sWzEsMSwiMiJdLFsyLDEsIjMiXSxbMCwyLCI0Il0sWzEsMiwiNSJdLFsxLDMsIjYiXSxbMiwyLCI3Il0sWzMsMiwiOCJdLFswLDEsIiIsMCx7InN0eWxlIjp7ImhlYWQiOnsibmFtZSI6Im5vbmUifX19XSxbMSwzLCIiLDAseyJzdHlsZSI6eyJoZWFkIjp7Im5hbWUiOiJub25lIn19fV0sWzAsMiwiIiwyLHsic3R5bGUiOnsiaGVhZCI6eyJuYW1lIjoibm9uZSJ9fX1dLFsyLDcsIiIsMix7InN0eWxlIjp7ImhlYWQiOnsibmFtZSI6Im5vbmUifX19XSxbMiw2LCIiLDAseyJzdHlsZSI6eyJoZWFkIjp7Im5hbWUiOiJub25lIn19fV0sWzEsNCwiIiwwLHsic3R5bGUiOnsiaGVhZCI6eyJuYW1lIjoibm9uZSJ9fX1dLFs0LDUsIiIsMCx7InN0eWxlIjp7ImhlYWQiOnsibmFtZSI6Im5vbmUifX19XSxbMyw0LCIiLDAseyJzdHlsZSI6eyJib2R5Ijp7Im5hbWUiOiJkYXNoZWQifSwiaGVhZCI6eyJuYW1lIjoibm9uZSJ9fX1dLFs0LDIsIiIsMCx7InN0eWxlIjp7ImJvZHkiOnsibmFtZSI6ImRhc2hlZCJ9LCJoZWFkIjp7Im5hbWUiOiJub25lIn19fV0sWzIsMSwiIiwwLHsic3R5bGUiOnsiYm9keSI6eyJuYW1lIjoiZGFzaGVkIn0sImhlYWQiOnsibmFtZSI6Im5vbmUifX19XSxbNiw3LCIiLDAseyJzdHlsZSI6eyJib2R5Ijp7Im5hbWUiOiJkYXNoZWQifSwiaGVhZCI6eyJuYW1lIjoibm9uZSJ9fX1dXQ==
      spacing: 1em,
      node((0.5, 0), [$1$]),
      node((0, 1), [$2$]),
      node((1, 1), [$3$]),
      node((-1, 2), [$4$]),
      node((0, 2), [$5$]),
      node((0, 3), [$6$]),
      node((1, 2), [$7$]),
      node((2, 2), [$8$]),
      edge((0.5, 0), (0, 1)),
      edge((0, 1), (-1, 2)),
      edge((0.5, 0), (1, 1)),
      edge((1, 1), (2, 2)),
      edge((1, 1), (1, 2)),
      edge((0, 1), (0, 2)),
      edge((0, 2), (0, 3)),
      edge((-1, 2), (0, 2), ".."),
      edge((0, 2), (1, 1), ".."),
      edge((1, 1), (0, 1), ".."),
      edge((1, 2), (2, 2), ".."),
    ))

    - theorem: adjacent edges are near the same level. That is, if $(x,y) in E$, then $|op("layer")(x) - op("layer")(y)| <= 1$
      - proof: 1) WLOG, AFSOC that $op("layer")(x) < op("layer")(y) - 1$. 2) All nbors of $x$ are added in or before $op("layer")(x) + 1$. By 2, $op("layer")(y) <= op("layer")(x) + 1$. But by 1, $op("layer")(y) > op("layer")(x) + 1$. $-><-$.

  - these (and Prim's!) are specifc types of tree-growing algorithms
    ```
    TreeGrowingAlg(graph G, initial node v, fn findnext)
        T = ({v}, {})
        S = set of nodes adj to v
        while S has items,
            e = nextEdge(G, S)
            T = T + e
            S = updateFrontier(G, S, e)
    ```
    - `next`/`update` is pop/push for DFS and de/enqueue for BFS, $O(m)$ across entire program.
      - same logic as Prim's
    - everything else in $O(n)$ (including loop)
    - thus, DFS and BFS are $in O(n + m)$

  - is-bipartite problem

    - definition: a graph is bipartite if $exists$ a two-coloring. that is, if you can divide the nodes into two colors s.t. all edges connect nodes of diff colors.

      #grid(
        columns: (1fr, 1fr),
        align: bottom,
        figure(caption: [a bipartite graph], diagram(
          spacing: 1em,
          node-stroke: black,
          {
            node((0, 0), [$1$], name: <1>, shape: rect)
            node((1, 0), [$2$], name: <2>)
            node((0, 1), [$3$], name: <3>, shape: rect)
            node((1, 1), [$4$], name: <4>)
            node((0, 2), [$5$], name: <5>, shape: rect)
            node((1, 2), [$6$], name: <6>)
            node((0, 3), [$7$], name: <7>, shape: rect)
            node((1, 3), [$8$], name: <8>)
            edge(<1>, <2>)
            edge(<1>, <4>)
            edge(<3>, <2>)
            edge(<3>, <4>)
            edge(<5>, <4>)
            edge(<7>, <6>)
            edge(<7>, <8>)
          },
        )),

        figure(caption: [can't have odd cycles], diagram(
          spacing: 1em,
          node-stroke: black,
          {
            node((0, 0), stroke: none, name: <origin>)
            node((72 * 1deg, 4em), [$1$], name: <1>, shape: rect)
            node((72 * 2deg, 4em), [$2$], name: <2>)
            node((72 * 3deg, 4em), [$3$], name: <3>, shape: rect)
            node((72 * 4deg, 4em), [$4$], name: <4>)
            node((72 * 5deg, 4em), [$5$ ?], name: <5>, stroke: none)
            edge(<1>, <5>)
            edge(<2>, <1>)
            edge(<3>, <2>)
            edge(<4>, <3>)
            edge(<5>, <4>)
          },
        )),
      )

    - solution: do a BFS from any node, swapping colors per layer. check if any edge is monolayer (since edges are between adj layers or same layer)

      - todo: prove correctness

- topological sort problem: given a DAG, assign an "order" to the nodes (a bijective $f : V -> [n]$).

  - Solution 1

    - Theorem: every DAG has a node with no incoming edges
      - think about it. what if there wasn't? then follow the edges backward. Since finite nodes in graph, eventually you return to already-seen: a cycle.

    - thus:
      ```
      let i = 1
      while i <= n:
          find node u with no incoming
          set f(u) = i
          del u from graph
          i++
      ```

    - proof: todo

  - Solution 2

    - do a DFS, track entering and leaving order. topological sort is the descending leaving number order.

    - proof: todo

- shortest path problem
  #figure(caption: [summary of options], table(
    columns: 3,
    align: (left, center, left),
    toprule(),
    // added by this package
    table.header([Method], [Time Bound], [Notes]),
    midrule(),
    // added by this package
    [D/BFS], $O(n + m)$, [unweighted only],
    [Dijkstra], $O(m log n)$, [pos weights, source to all sinks],
    [A\*], $O(m log n)$, [needs an $h$ (pref. admissable), source to one sink],
    [Bellman-Ford], $O(n m)$, [can process negative weights],
    bottomrule(),
    // added by this package
  ))

  - as a note, running through these on paper is much better for comprehension than staring at the pseudocode

  - Dijkstra

    - use tree-growing paradigm, like Prim's

      - think about what this paradigm means for neg weights: if I choose a locally good weight, I might miss out on globally good (very negative) weights.

    - impl

      - define one start node $s$, tentative distances $d$ (all $infinity$ except $d[s] = 0$), tentative parents $p$ all `None`, frontier $F = V$.
      - while frontier has items
        - $u$ = frontier node with min $d$
        - remove $u$ from $F$ (this "locks $u$ in": its current $d$ is the shortest possible.)
        - update $d$ for neighbors of $u$ if applicable

    - proof

      - really weird induction. todo.

  - A\*

    - impl

      - literally just Dijkstra but with $h[u]$, a heuristic distance from $u$ to dest $t$
      - that is, replace "min $d$" with "min $f = d + h$"

    - an admissable $h$ is one that always underestimates (or is equal to) the real $u$ to $t$
      - if $h$ admissable, A\* will find the globally optimal solution (proof omitted)

  - Bellman-Ford

    - as mentioned above, tree-growing (Dijk/A\*) doesn't work for negative weights. nor do they find (infinitely) negative weight cycles.

    - revised problem statement: find that $exists$ negative cycle _or_ shortest path

    - impl

      - again, use $d[s] = 0,$ $d["else"] = infinity$
      - relaxation (Ford) step: find any edge $(u,v)$ s.t. $d[v] > d[u] + w(u,v)$. update $d$ for that edge.
      - relax until can't anymore. $d[u]$ must hold shortest paths.

- asymptotics

  - we want a formal definition of alg. efficiency for large problems

  - big $O$

    - $T(n) in O(f(n))$ if $exists n_0 >= 0, c >= 0, T(n) <= c f(n) forall n >= n_0$

    - "exists some $c$ linear multiplier such that $c f(n)$ dominates $T(n)$ after some $n_0$ large number."

  - big $Omega$

    - $T(n) in Omega(f(n))$ if $exists epsilon >= 0, n_0 >= 0, T(n) >= epsilon f(n) forall n >= n_0$

    - "exists some $epsilon$ linear multiplier such that $epsilon f(n)$ is dominated by $T(n)$...

  - big $Theta$

    $T(n) in Theta(f(n))$ if $T(n) in O(f(n)) and T(n) in Omega(f(n))$

  - Theorem: $ exists c, lim_(n->infinity) T(n)/g(n) = c <==> T(n) in Theta(g(n)) $
    and similarly for the other two big complexities.

- divide and conquer
  - time complexity proofs
    - set up with old friend recurrence relations
    - tree Method
    - by induction (used to verify a known/given time bound)
      + show $T(k) < f(k)$ for "small" $k$
      + assume $T(k) < f(k)$ for $k < n$
      + show $T(n) in O(f(n))$ i.e. $T(n) <= f(n)$, large $n$, blah blah blah

  - mergesort

    - impl:
      ```
      sort(L)
          if |L| == 2: return [min L, max L] in O(1)
          else
              L1 = sort(L[1 : |L|/2])
              L2 = sort(L[|L|/2 : |L|])
              ^ two calls to self on input length |L|/2
              return merge(L1, L2) in O(n)
      ```

    - time complexity
      - $T(n) = 2 T(n/2) + c dot n$
      - Base case for $k=2$. $c 2 log 2 = 2c >= T(2)$
      - Induct.
        $
          T(n) & <= 2 T(n/2) + c dot n "by defn" \
               & <= 2 (c n/2 log n/2) + c dot n "by IH" \
               & = c n log n - c n log_2 2 + c n "by alg" \
               & = c n log n "by alg"
        $
        something something correct bounds of $O(n log n)$

  - closest two points problem: given $n$ points in 2d space, find closest two
    
    - divide step: 
      - divide points (e.g. left and right side).
      - find closest in each side
    - merge step:
      - what if we cut the global closest distance?
      - call the smaller "closest distance" $d$
      - if that that global closest exists, it must at most $d$ away from our split, a "possible region"
      - also, all pairs are at least $d$ away from each other (both sides)
      - so, we just need to check all $O(n)$ points in the "possible region"
      - for each point, there is a small finite ($15$ lol) number of points that might be able to be the global closest
      - overall this means this merge step is $O(15n) in O(n)$

    - this is $O(n log n)$ :D

  - (binary) integer multiplication problem
    - let's say we want $x dot y$, both $n$ bits long
    - naïve is $Theta(n^2)$ in length of binary number
    - we can get down to $Theta(n^(1.58...))$ with Karatsuba's Alg!

      let $m = n/2$. then we can apply the "left shift" operation to write
      $
        x & = x_1 2^m + x_0 \
        y & = y_1 2^m + y_0
      $

      Our multiplication becomes
      $
        x dot y & = (x_1 2^m + x_0) (y_1 2^m +y_0) \
                & = x_1 y_1 2^(2m) + (x_1 y_0 + x_0 y_1)2^m + x_0 y_0
      $

      Notice the terms
      $
        P_0 & = x_0 y_0 \
        P_1 & = x_1 y_1 \
        P_2 & = x_1 y_0 + x_0 y_1 \
            & = (x_1 + x_0)(y_1 + y_0) - P_0 - P_1
      $

      for a total of only three unique multiplications! And recall they are half as wide as $x dot y$. Our original multiplication becomes
      $
        x dot y = ... = P_1 2^(2m) + P_2 2^m + P_0
      $

      From this, we can write out our recurrence relation. Let $n$ be some $2^k$. Since we do those three multiplications on half the size, $T(2^k) = 3T(2^(k-1)) + c 2^k$.

      The notes then do a lot of math nonsense. Surely the tree method is easier :(

  - matmul problem
    - naïve is $Theta(n^3)$ in (square) matrix side length
    - with Strassen's alg, $Theta(n^2.807...)$

      very similar of form to Karatuba's, using algebraic manipulations
