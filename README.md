
# Evaluating TCP vs. UDP in Centralized Multi-Robot Communication using Star Topology

## 📜 Overview
This project presents a **MATLAB-based simulation framework** that evaluates the performance of **TCP (Transmission Control Protocol)** and **UDP (User Datagram Protocol)** in a **centralized multi-robot communication system** configured in a **star topology**.  
It was the foundation of a **peer-reviewed IEEE conference paper** presented at **IEEE INDISCON 2025**.

The simulation provides a practical, extensible tool for researchers and engineers to analyze the **trade-offs between reliability, latency, and throughput** in communication protocols for robotic networks.

---

## 🚀 Key Features
- **MATLAB-based simulation framework** for centralized multi-robot systems.
- **Star topology communication model** with a single hub coordinating all communication.
- **Realistic network impairments**: packet loss, jitter, and delay.
- **Protocol-specific modelling**: TCP acknowledgments, retransmissions, and UDP lightweight delivery.
- **Five test scenarios** covering one-to-one, one-to-all, sequential, and parallel communication.
- **Performance Metrics**: Latency, Packet Delivery Ratio (PDR), Throughput, Retransmissions, and Loss Rate.
- **Research-focused tool** for benchmarking and protocol selection in robotic applications.

---

## 📂 Project Structure
```plaintext
├── src/
│   ├── tcp_udp_simulation.m        # MATLAB code implementing TCP/UDP simulation
│   ├── topology_config.m           # Topology setup with robot and hub configuration
│   ├── metrics_calculation.m       # Extracts latency, PDR, retransmissions, throughput
│   └── visualization.m             # Graphical plots for communication flows
├── docs/
│   ├── IEEE_INDISCON_2025_Paper.pdf  # Accepted IEEE paper
│   └── Presentation.pptx             # Conference presentation slides
└── README.md
```

---

## 🔍 Simulation Methodology
- **Robots**: Six autonomous nodes connected via a central hub.
- **Protocols**:
  - TCP: Connection-oriented, acknowledgment-based, retransmissions.
  - UDP: Connectionless, lightweight, minimal latency.
- **Network Faults**: 
  - Packet loss: Bernoulli model.
  - Delay & jitter: Gaussian model.
- **Scenarios**:
  1. One-to-one communication.
  2. Broadcast (one-to-all).
  3. Many-to-one aggregation.
  4. Sequential message transmission.
  5. Parallel multi-destination communication.

---

## 📊 Results
| Scenario | Avg Latency (sec) | PDR (%) | Retransmissions |
|----------|------------------|---------|-----------------|
| 1        | 0.20             | 100.0   | 0               |
| 2        | 0.28             | 96.7    | 3               |
| 3        | 0.33             | 93.3    | 4               |
| 4        | 0.22             | 100.0   | 0               |
| 5        | 0.35             | 91.7    | 5               |

TCP ensures higher reliability but increases latency, while UDP provides faster performance at the cost of packet loss.

---

## 🛠️ Tech Stack
- **Programming Language**: MATLAB
- **Simulation Approach**: Event-driven with random network faults
- **Visualization**: MATLAB plotting tools
- **Topology**: Centralized hub-and-spoke

---

## 📢 Research Contribution
This project introduces a **lightweight, customizable, and reproducible framework** for robotic communication research. It was **presented at IEEE INDISCON 2025** and lays the foundation for:
- Hybrid protocol switching research.
- Fault-tolerant robotic communication studies.
- Integration with physical robots for hardware-in-the-loop testing.

---

## 📜 Citation
If you use this work, please cite:
```
K. Chaitanya Sai, K. Nagendra, R. P. Desai, "Evaluating TCP vs. UDP in Centralized Multi-Robot Communication using Star Topology," 
IEEE INDISCON 2025.
```

---

## 🔗 Links
- **IEEE INDISCON 2025 Publication**: [To be updated]
- **Conference Presentation**: `docs/Presentation.pptx`
- **Paper**: `docs/IEEE_INDISCON_2025_Paper.pdf`

---

## 🤝 Contributors
- [Chaitanya Sai Kurapati](mailto:av.en.u4cse22121@av.students.amrita.edu)
- K. Nagendra
- Ravishankar Prakash Desai

---

## 📜 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
