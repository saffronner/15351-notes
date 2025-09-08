#import "@preview/fletcher:0.5.5" as fletcher: diagram, edge, node

#set page(height: auto)
#set list(marker: [--])
#let qed = [#math.square]

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
