# EDC

Code for the Exact Dynamic Consensus (EDC) project by [Rodrigo Aldana-López](https://rodrigoaldana.github.io/), Rosario Aragüés and Carlos Sagüés, Universidad de Zaragoza. 

The purpose of this project is to provide basic reference designs, parameter values and protocol configurations so that anyone interested in using EDC algorithms can get them working easily. 

EDC protocols are a family of algorithms whose purpose is to compute the average of a set of local scalar time-varying signals distributed over a network. Each node in the network has access to its local signal and can communicate with its neighbor nodes. The EDC basic blocks share a single scalar value per node and compute the average signal and its derivatives. The philosophy behind the protocols here is analogous to an exact differentiator vs. a high gain observer. In this case, EDC protocols are the counter-part to classical linear average dynamic consensus, which are only exact with vanishing signals. In contrast, EDC protocols are exact over a broader class of signals, usually with bounded derivatives.

All protocols have the general structure containing:
- **Local signals** "u_i(t)": Each local signal is only accessed locally at each node "i".
- **Goal signal**: A global quantity of interest, function of the local signals. For example, the average of all local signals. The goal of the protocol is to compute (estimate) such signal in a "fully" distributed and decentralized way.
- **Protocol order** "m": Determines the order of the high-order sliding mode. This is determined by the m-th derivative of the signals known to be bounded. Also, this determines how many derivatives of the average signal can be computed by the protocol.
- **Protocol's internal state** "x_{i,mu}": Each node "i" has internal variables "x_{i,0},...,x_{i,m}" whose dynamics determine the protocol.
- **Outputs "y_{i,mu}"**:  These are the actual outputs of the protocol at node "i". After the protocol converges, "y_{i,mu}" converges to the mu-th derivative of the goal signal.

The main protocols are enlisted as follows:
- **EDCHO**:  This is the most basic EDC block. It has the same structure as the [standard homogeneous exact differentiator](https://www.tandfonline.com/doi/abs/10.1080/0020717031000099029) extended to the context of dynamic consensus. This protocol can achieve EDC even if the local signals don't vanish, provided some high-order derivative is bounded. The main drawback is that the initial conditions for the protocol must all add up to zero. The previous can be satisfied trivially if all nodes start at zero. However, if the network conditions change (disconnection/connection of agents), this condition is broken, and the protocol diverges. The theoretical details are provided in our paper either at the [publisher link](https://www.sciencedirect.com/science/article/abs/pii/S0005109821002703) or in [arxiv](https://arxiv.org/abs/2202.03012). *If you use this protocol in academic work, please cite the publisher version of our article as*:

```bibtex
@article{edcho2021,
  title = {EDCHO: High order exact dynamic consensus},
  journal = {Automatica},
  volume = {131},
  pages = {109750},
  year = {2021},
  issn = {0005-1098},
  author = {Rodrigo Aldana-López and Rosario Aragüés and Carlos Sagüés}
}
```

- **REDCHO**: This can be used as the standard EDC block. It solves the initial condition problem of EDCHO, being robust to the disconnection/connection of agents. Moreover, EDCHO can be recovered from REDCHO by a simple parameter selection. The main drawback compared to EDCHO is that all derivatives up to m must be bounded now. Also, the [tunning procedure](#tunning-procedure) is more involved. The theoretical details are provided in our paper either at the [publisher link](https://www.sciencedirect.com/science/article/pii/S0005109822001686?via%3Dihub) or in [arxiv](https://arxiv.org/abs/2204.12344). *If you use this protocol in academic work, please cite the publisher version of our article as*:

```bibtex
@article{redcho2022,
  title = {REDCHO: Robust Exact Dynamic Consensus of High Order},
  journal = {Automatica},
  volume = {141},
  pages = {110320},
  year = {2022},
  issn = {0005-1098},
  author = {Rodrigo Aldana-López and Rosario Aragüés and Carlos Sagüés},
}
```

- **Modulated EDCHO/REDCHO**: This protocol version modulates the local signals to start from the trivial signal 0 and deforms them towards the actual goal signal of interest after a prescribed time. For appropriate tunning, the protocol begins at consensus (at the useless zero signal) but maintains consensus while the signals are being deformed. The result is that the protocol is already at consensus when the deformation finishes. The previous allows the protocol to converge in a *prescribed time*. The main drawback is that this protocol requires more conservative (more significant gains) for a smaller prescribed deadline. The theoretical details are provided in our paper (**comming soon**).

- **MDVO**: The Modulated Distributed Virtual Observer. In this case, the nodes are separated in leaders and followers. The followers don't have a local time-varying signal. The goal signal is the average of the leaders signals only. The MDVO performs the computation based on two modulated EDCHO/REDCHO blocks. The actual output of the MDVO is the ratio of the previous block outputs. The theoretical details are provided in our paper (**comming soon**).

---
## Test files
We provide several test files to showcase distinct aspects of the EDC protocols.
- **edcho_standard_dynamic_consensus.m**

A standard test for the EDCHO protocol. Local signals are sinusoidal. After the experiment has finished, only the first output is plotted, showing how all agents converge to a consensus towards the average signal.

- **edcho_components_vs_vector.m**

Same as the standard test for the EDCHO protocol. However, we use two ways of writing the protocol. Either the full version: all agents add up their contributions according to their neighbors, using the adjacency matrix. Or the compact version is used: here, we use the incidence matrix to write the protocol in the compact vector version as in the paper. Both simulations result in the same curves. This comparison is used only to show numerically how these two representations of the protocol are equivalent.


- **edcho_derivatives.m**

Same as the standard test for the EDCHO protocol. However, all outputs are plotted, showing how EDCHO also manages to recover the derivatives of the average signal.

- **redcho_standard_dynamic_consensus.m**

Same as the standard test for the EDCHO protocol. However, we use REDCHO instead. Now, the initial conditions can be arbitrary.

- **redcho_derivatives.m**

Same as *edcho_derivatives.m* but with REDCHO instead of EDCHO.

- **modulating_standard_test.m**

Same as *redcho_standard_dynamic_consensus.m*  but with the modulating REDCHO instead. Now, the protocol converges before (strictly at) a prescribed time.

- **mdvo_standard_test.m**

In this test, we use two modulated REDCHO blocks for follower nodes to compute the average of a set of leader nodes.

---
## Tuning procedure <a name="tunning-procedure" />

In the test files, we already provide some parameters which work well in most cases. These might differ from the EDCHO/REDCHO articles since we have been experimenting with other tunning procedures. The original EDCHO/REDCHO tunning ensures sufficiently big gains k<sub>0</sub>,...k<sub>m</sub>" exist. According to the EDCHO paper, these gains are related to the expected exact differentiator gains. However, we have found a simple procedure to tune the gains for most scenarios:

### **Tuning EDCHO**
The gains "k0,...,km" are chosen as coefficients of a Hurtwitz polynomial, just as if it was a linear observer. Moreover, we use a scale value "r" to move the fictitious poles "r" times to the left (increasing the gains k0,...,km) accordingly. For example, if m=4, the polynomial with coefficients 1,10,35,50,4 has poles at -1,-2,-3,-4. Hence, we can set the gains as:

>r = 2; % gain scaling
>
>k = [24,50,35,10].*[r^1, r^2 , r^3, r^4];

The previous is motivated by a similar tunning procedure working for the standard homogeneous differentiator. 

**Time step vs. "r" vs. local signals dynamics tradeoff**: As local signals change faster, higher gains will be required. Hence, when setting faster signals, one can increase "r" directly. However, big signals may cause significant numerical chattering, mainly at the high order states. Thus, the time step may be decreased to counteract the chattering. The previous is equivalent to increasing the frequency of communication between nodes. This rule can be summarized as iterating over:

>faster local signals -> increase "r" -> decrease time step "h"

### **Tuning REDCHO**
A similar tunning rule as in EDCHO. The "k0,...,km" gains are chosen similarly, with a scale factor "r". However, a new set of gains "g0,...,gm" are introduced. For simplicity, we can set g = g0 = ... = gm. We have found no advantage of using different gains yet. Thus, we have an interplay between the following quantities:

- *Local signals dynamics*: how fast these signals change. In the case of sinusoidal, this is determined by the frequency and amplitude of the signals.

- *scale factor "r"*: Scale to increase "k0,...,km". Determines the converges towards consensus.

- *gain g*: Gain for "g0,...,gm". A bigger value of g makes the mismatch in the initial conditions vanish faster.

- *time step h*: determines the Euler step in the simulation.

Increasing "g" makes the protocol converge faster when initial conditions are arbitrary. However, a bigger "g", require bigger "r". Thus the tunning procedure consists of iterating over the following rules.

>faster local signals -> increase "r" -> decrease time step "h"

>bigger "g" -> increase "r" -> decrease time step "h"


