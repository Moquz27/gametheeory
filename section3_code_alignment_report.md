# Section 3 Code Alignment Report

Checked against the updated `report/LN_AGB_GT.m`.

## Differences Found

1. Saddle point detection in Section 3 is described as an exact comparison between maximin and minimax. The updated code uses a scale-aware tolerance:

```matlab
tol=1e-8*max(1,max(abs(A(:))));
if abs(maximin-minimax)<=tol
```

Section 3 should mention that equality is handled numerically, not by exact equality.

2. Section 3 says the player chooses the row and column containing the saddle point. The updated code now detects all valid saddle point positions using row-minimum and column-maximum conditions:

```matlab
saddleRows=find(abs(rowMin-maximin)<=tol);
saddleCols=find(abs(colMax-minimax)<=tol);
saddleMask=false(m,n);
saddleMask(saddleRows,saddleCols)=true;
[saddleR,saddleC]=find(saddleMask&abs(A-maximin)<=tol);
```

Section 3 should mention that multiple saddle points can exist and that the program stores all valid saddle positions.

3. Section 3 presents the \(2 \times 2\) mixed strategy formulas but does not mention the near-degenerate denominator check. The updated code rejects formulas when:

```matlab
abs(den)<=denTol
```

where `denTol` is scaled by the magnitude of the four payoff values.

4. Section 3 presents \(p\) and \(q\) as direct formula outputs. The updated code validates probabilities with tolerance and clamps only tiny floating-point deviations:

```matlab
probTol=1e-8;
if p<-probTol||p>1+probTol||q<-probTol||q>1+probTol
```

Section 3 should mention this numerical validation if it is intended to describe implementation behavior.

5. Section 3 describes the general \(m \times n\) case through linear programming, which still matches the updated code mathematically. However, the updated code also checks `linprog` convergence through `exitflag`; Section 3 does not mention this implementation-level validation.

6. Section 3 does not mention input validation. The updated code now rejects nonnumeric, empty, undersized, `NaN`, and `Inf` payoff matrices before running the algorithm.

## Still Matching

- The maximin/minimax framework remains unchanged.
- The \(2 \times 2\) formulas for \(p\), \(q\), and \(v\) remain unchanged for valid nondegenerate games.
- The general \(m \times n\) linear programming formulation remains mathematically consistent with the updated code.
- The payoff shifting method still matches the implementation:

```matlab
shift=abs(min(A(:)))+1;
A1=A+shift;
```
