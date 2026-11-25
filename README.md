# Nand to Tetris - I (ETCCNT301): Capstone Project
### Make the Computer Draw a Box

* **Student Name:** Sanchit
* **Roll Number:** `2501730475`
* **Personal Constant ($K$):** `75` (Last two digits of roll number)
* **Department:** School of Engineering & Technology, K.R. Mangalam University

---

## Project Overview

This repository contains the complete implementation of the **Hack Computer**, a **two-pass Hack Assembler** written in Python, and an interactive **Hack Assembly screen-drawing program (`Box.asm`)**. When executed on the Hack CPU Emulator, pressing and holding any keyboard key renders a black rectangle at the assigned screen coordinates, and releasing the key clears it back to white.

### Personalized Parameters ($K = 75$)

| Parameter | Formula / Rule | Value |
| :--- | :--- | :--- |
| **Personal Number ($K$)** | Last two digits of Roll No. (`2501730475`) | **`75`** |
| **Part B Extra Feature** | $K \pmod 3 = 75 \pmod 3 = 0$ | **Export all labels & variables to `symbols.txt`** |
| **Box Starting Row** | $\text{Row} = K$ | **Row `75`** |
| **Box Height** | Fixed by specification | **`20` rows** (Rows `75` to `94`) |
| **Box Width** | $16 \times ((K \pmod 4) + 1) = 16 \times (3 + 1)$ | **`64` pixels** (`4` consecutive 16-bit words/row) |
| **Screen Base Address** | $\text{SCREEN} + (32 \times 75) = 16384 + 2400$ | **`RAM[18784]`** |

---

## Repository Structure

```text
capstone/
├── CPU.hdl          # Hack Central Processing Unit (ALU, A/D registers, jump logic)
├── Memory.hdl       # Unified address space (RAM16K, Screen memory map, Keyboard)
├── Computer.hdl     # Top-level Hack computer integrating ROM32K, CPU, and Memory
├── assembler.py     # Two-pass Hack Assembler with K mod 3 = 0 symbol table export
├── symbols.txt      # Exported label & variable decimal address mappings
├── Box.asm          # Hack assembly program drawing a 64x20 box at row 75
├── Box.hack         # 16-bit binary machine code compiled via assembler.py
└── README.md        # Project documentation and verification summary
```

---

## Part A: Hack Computer Hardware (`CPU.hdl`, `Memory.hdl`, `Computer.hdl`)

The hardware architecture connects the processor, memory-mapped I/O, and instruction memory:
* **`Memory.hdl`:** Routes 15-bit addresses across `RAM16K` (`0x0000–0x3FFF`), `Screen` (`0x4000–0x5FFF`), and `Keyboard` (`0x6000`).
* **`CPU.hdl`:** Decodes A-instructions and C-instructions, executes ALU operations, updates `A` and `D` registers, and resolves conditional jumps (`JGT`, `JEQ`, `JGE`, `JLT`, `JNE`, `JLE`, `JMP`).
* **`Computer.hdl`:** Connects `ROM32K`, `CPU`, and `Memory` synchronized by the global `reset` signal.

### Hardware Verification
All five official Nand2Tetris test scripts passed in the Hardware Simulator with zero comparison differences:
* `Memory.tst` — Passed
* `CPU.tst` — Passed
* `ComputerAdd.tst` — Passed
* `ComputerMax.tst` — Passed
* `ComputerRect.tst` — Passed

---

## Part B: Two-Pass Python Assembler (`assembler.py`)

`assembler.py` translates symbolic `.asm` programs into 16-bit binary `.hack` machine code without external dependencies:
1. **Preprocessing:** Strips inline `//` comments and whitespace/blank lines.
2. **Pass 1 (Symbol Resolution):** Maps `(LABEL)` declarations to their exact ROM instruction addresses.
3. **Pass 2 (Code Generation):** Encodes A-instructions (`0vvvvvvvvvvvvvvv`, allocating new variables sequentially starting at `RAM[16]`) and C-instructions (`111accccccdddjjj`).
4. **Custom Feature ($K \pmod 3 = 0$):** Writes all user-defined labels and allocated RAM variables with their decimal addresses to `symbols.txt`.

### Usage
```bash
python assembler.py <Program.asm>
```

### Benchmark Verification
| Benchmark | Generated Output | Instructions | Official Assembler Match |
| :--- | :--- | :--- | :--- |
| `Add.asm` | `Add.hack` | 6 | Exact Match |
| `Max.asm` | `Max.hack` | 16 | Exact Match |
| `Rect.asm` | `Rect.hack` | 25 | Exact Match |
| `Pong.asm` | `Pong.hack` | 27,483 | Exact Match |

---

## Part C: Interactive Box Program (`Box.asm` & `Box.hack`)

`Box.asm` continuously polls `@KBD` (`RAM[24576]`):
* When a key is held down (`KBD != 0`), it writes `-1` (`1111111111111111`) across 4 consecutive 16-bit words (`64` pixels) per row for `20` rows starting at `RAM[18784]` (Row `75`), advancing by `32` words per row.
* When the key is released (`KBD == 0`), it writes `0` across the same region to clear the box.

### How to Run
1. Compile `Box.asm` using the custom assembler:
   ```bash
   python assembler.py Box.asm
   ```
2. Open the **Nand2Tetris CPU Emulator**, load `Box.hack` into ROM, set speed to **Fast**, and click **Run**.
3. Enable the keyboard input and press/hold any key to display the `64 × 20` black box at row `75`.