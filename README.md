# Vehicular Platooning Simulation Framework

This repository provides a modular MATLAB framework for simulating and analyzing connected vehicle platoons. The system includes components for:

- Initial condition generation (pre-platooning phase)
- Distributed control of follower vehicles
- Communication topology modeling
- Performance evaluation (comfort, safety, fuel, etc.)

---

## 📦 Modules

### 🚦 Initializer

Located in [`initializer/`](initializer/), this module simulates the leader trajectory and follower behavior before platooning begins. It outputs:

- Initial states for all follower vehicles
- Leader’s state at the time of platoon trigger

Useful for seamless integration into your downstream platoon controller.

---

## 📄 License

MIT License

---

## 🛠 MATLAB Version

Tested on MATLAB R2023a.

---

## 📬 Contact

Maintained by [Your Name]

