# Fault-Tolerant Digital Twin in Elixir

This project implements a fault-tolerant particle filter digital twin using Elixir.  
It simulates a nuclear power plant (e.g., reactor + heat exchanger) and demonstrates real-time resilience by running multiple Elixir processes for state estimation.  
If one process fails, the rest continue running, maintaining a degraded but functional digital twin.

---

## 🔹 Key Features
- **Particle filter-based state estimation** with uncertainty  
- **Fault-tolerant supervision tree**—if one process crashes, the twin continues running  
- **Real-time visualization** using a Python plotting script  
- Modular design for experimenting with fault injection and resilience  

---

## 🔹 Why This Matters
Safety-critical systems in industrial control and autonomous environments must withstand failures without losing core functionality.  
This project explores how Elixir’s fault-tolerant design can provide resilience for digital twins in ICS/OT applications.

---

## 🔹 Getting Started

### 1. Requirements
- **Elixir** (>= 1.14)  
- **Python 3** with `matplotlib` installed  

### 2. Clone this Repository
```bash
git clone https://github.com/YOUR_USERNAME/elixir-fault-tolerant-digital-twin.git
cd elixir-fault-tolerant-digital-twin
```


