# Fault-Tolerant Digital Twin in Elixir

This project implements a **fault-tolerant particle filter digital twin** using Elixir, designed to demonstrate real-time resilience for ICS/OT systems.

## 🔹 Key Features
- Distributed particle filter with fault tolerance  
- Supervision trees for process recovery  
- Real-time measurement integration over UDP  
- Deployment tested on BeagleBone Black running Kry10 OS  

## 🔹 Why This Matters
Safety-critical systems in industrial control and autonomous environments must withstand failures without losing core functionality. This project explores how **actor-model concurrency in Elixir** can provide a foundation for resilient digital twins.

## 🔹 Status
Currently runs with 1000 particles distributed across 5 processes. If one process fails, estimation continues with the remaining 800 particles.

## 🔹 Next Steps
- Document architecture and workflows  
- Add test cases and fault injection scenarios  
- Provide deployment instructions for Kry10 OS  

More details and code will be added soon.
