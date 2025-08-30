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

  - how do we do some of this stuff _fast_? 
    - next lecture, looking into adj mat/lists, abstract data types, and specifically the union-find type. (`find(i)` returns `i`'s group, `union(a, b)` coalesces groups `a, b`.)

        