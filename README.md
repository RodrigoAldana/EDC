# EDC_sim

This is the code for the Exact Dynamic Consensus (EDC) project by Rodrigo Aldana-López. EDC protocols are a family of algorithms whose purpose is to make compute the average of a set of local scalar time-varying signals, distributed over a network. Each node in the  network has access to its own local signal and can communicate with its neighbor nodes.

The EDC basic blocks share a single scalar value per node and compute not only the average signal but also its derivatives.

The philosophy behind the protocols here is analogous to an exact differentiator vs a high gain observer. In this case, EDC protocols are the counter-part to classical linear average dynamic consensus, which are only exact with vanishing signals, whereas EDC protocols are exact over a wider class of signals, usually with bounded derivatives.

All protocols have the general structure containing:
- **Local signals** "u_i(t)": Each local signal is only accesed locally at each node "i"
- **Goal signal**: A global quantity of interest function of the local signals. For example the average of all local signals. The goal of the protocol is to compute (estimate) such signal in a "fully" distributed and descentralized way.
- **Protocol order** "m": Determines the order of the high order sliding mode. This is determined by the m-th derivative of the signals known to be bounded. Also, this determines how many derivatives of the average signal can be computed by the protocol.
- **Protocol's internal state** "x_{i,mu}": Each node "i" has internal variables "x_{i,0},...,x_{i,m}" whose dynamics determine the protocol.
- **Outputs "y_{i,mu}"**: These are the actual outputs of the protocol at node "i". After the protocol converge, "y_{i,mu}" have converged to the mu-th derivative of the goal signal.

The main protocols are enlisted as follows:
- **EDCHO**: This is the most basic EDC block. It has the same structure as the [standard homogeneous exact differentiator](https://www.tandfonline.com/doi/abs/10.1080/0020717031000099029) extended to the context of dynamic consensus. This protocol can achieve EDC even if the local siganls don't vanish, provided some high order derivative is bounded. The main drawback is that the initial conditions for the protocol must all add up to zero. This can be complied trivially if all nodes start at zero. However, if the network conditions change (disconnection/connection of agents) this condition is broken and the protocol diverges. The theoretical details are provided in our paper either at the [publisher link](https://www.sciencedirect.com/science/article/abs/pii/S0005109821002703) or in [arxiv](https://arxiv.org/abs/2202.03012). *Please cite the publisher version*.

- **REDCHO**: This can be used as the standard EDC block. It solves the initial condition problem of EDCHO, being robust to disconnection/connection of agents. Moreover, EDCHO can be recovered from REDCHO by a simple parameter selection. The main drawback with respect to EDCHO is that now, all derivatives up to m must be bounded. Also, the [tunning procedure](#tunning-procedure) is more involved. The theoretical details are provided in our paper either at the [publisher link](https://www.sciencedirect.com/science/article/pii/S0005109822001686?via%3Dihub) or in [arxiv](https://arxiv.org/abs/2204.12344). *Please cite the publisher version*. 

- **Modulated EDCHO/REDCHO**: This version of the protocol modulates the local signals to start from the trivial signal 0, and deform the signals towards the actual signal of interest after a prescribed time. For appropriate tunning, the protocol starts at consensus (at the useless zero signal) but maintains consensus while the signals are being deformed. The result is that when the deformation finishes, the protocol is already at consensus. This allows the protocol to converge in a *prescribed time*. The main drawback is that this protocol requires more conservative (greater gains) for smaller prescribed deadline.  The theoretical details are provided in our paper (**comming soon**).

- **MDVO**: The Modulated Distributed Virtual Observer. In this case, the nodes are separated in leaders and followers. The followers don't have a local time-varying signal. The goal signal is the average of the leaders signals only. The MDVO performs the computation based on two modulated EDCHO/REDCHO blocks. The actual output of the MDVO is the ratio of the previous block outputs. The theoretical details are provided in our paper (**comming soon**).

---
## Test files
We provide several test files to showcase disctinct aspects of the EDC protocols.
- >edcho_standard_dynamic_consensus.m
asd

- >edcho_components_vs_vector.m

asd

- >edcho_derivatives.m

asd

- >redcho_standard_dynamic_consensus.m

asd

- >redcho_derivatives.m

asd

- >modulating_standard_test.m

asd

- >mdvo_standard_test.m

asd



---
## Tuning procedure <a name="tunning-procedure" />
