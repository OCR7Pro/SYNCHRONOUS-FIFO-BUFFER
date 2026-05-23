# Synchronous FIFO Buffer

A fully synthesizable **Synchronous First-In-First-Out (FIFO) Buffer** implemented in Verilog HDL. Designed and simulated using **Xilinx Vivado**, this project demonstrates a modular RTL design with separate read logic, write logic, and memory components integrated through a top-level module.

---

## Project Overview

A FIFO (First-In, First-Out) buffer is a fundamental hardware structure used in digital design for data buffering between modules operating at different rates or for decoupling data producers and consumers. This synchronous FIFO operates on a **single shared clock**, making it ideal for same-clock-domain communication.

### Key Specifications

| Parameter        | Value         |
|------------------|---------------|
| Data Width       | 8 bits        |
| FIFO Depth       | 8 locations   |
| Pointer Width    | 4 bits        |
| Clock Type       | Synchronous (single clock) |
| Reset Type       | Synchronous Active-High    |
| Full Detection   | MSB inversion method       |
| Empty Detection  | Pointer equality method    |

---

## Architecture

The design follows a **modular, hierarchical architecture** with three sub-modules instantiated inside a top-level wrapper:

```
sync_fifo_top
├── fifo_memory       → Dual-port synchronous RAM (8 x 8-bit)
├── write_logic       → Write pointer control + FULL flag generation
└── read_logic        → Read pointer control + EMPTY flag generation
```

### Block Diagram

```
         ┌─────────────────────────────────────────┐
         │             sync_fifo_top                │
         │                                          │
wr_data ─►─────────────► fifo_memory ──────────────►─ rd_data
wr_enable►─┐             (8x8 RAM)                  │
rd_enable►─┤                                        │
         │ │  wr_ptr   ┌─write_logic─┐   full       │
         │ └──────────►│  (wr ctrl)  ├──────────────►─ full
         │             └─────────────┘              │
         │  rd_ptr    ┌──read_logic──┐   empty      │
         │ ┌─────────►│  (rd ctrl)  ├──────────────►─ empty
         │ │          └─────────────┘              │
clk, reset connected to all sub-modules            │
         └─────────────────────────────────────────┘
```

---

## File Structure

```
SYNCHRONOUS-FIFO-BUFFER/
│
├── README.md                       ← Project documentation (this file)
│
├── sync_fifo_top.v                 ← Top-level module (integrates all sub-modules)
├── fifo_memory.v                   ← FIFO RAM memory array (8 x 8-bit)
├── write_logic.v                   ← Write pointer + FULL flag logic
├── read_logic.v                    ← Read pointer + EMPTY flag logic
│
├── sync_fifo_top_tb.v              ← Testbench (functional simulation)
└── sync_fifo_top_tb_behav.wcfg    ← Vivado waveform configuration file
```

---

## Module Descriptions

### 1. `sync_fifo_top` — Top-Level Module

The top-level wrapper that instantiates and connects all three sub-modules. It also generates the gated enable signals to prevent writes when full and reads when empty.

| Port        | Direction | Width | Description                    |
|-------------|-----------|-------|--------------------------------|
| `clk`       | Input     | 1     | System clock                   |
| `reset`     | Input     | 1     | Synchronous active-high reset  |
| `wr_enable` | Input     | 1     | Write enable                   |
| `rd_enable` | Input     | 1     | Read enable                    |
| `wr_data`   | Input     | 8     | Data to write                  |
| `full`      | Output    | 1     | FIFO full flag                 |
| `empty`     | Output    | 1     | FIFO empty flag                |
| `rd_data`   | Output    | 8     | Data read from FIFO            |

---

### 2. `fifo_memory` — Dual-Port Synchronous RAM

Implements an 8-location, 8-bit wide register array. Write and read operations are both clocked on the rising edge. Read data is registered (synchronous read).

- Write: On `posedge clk`, if `wr_enable` is asserted, data is written to `mem[wr_ptr[2:0]]`
- Read: On `posedge clk`, if `rd_enable` is asserted, data at `mem[rd_ptr[2:0]]` is output to `rd_data`

---

### 3. `write_logic` — Write Pointer & FULL Flag

Manages the 4-bit write pointer and generates the `full` status flag.

- **Write Pointer**: Increments on every valid write (`wr_enable & ~full`)
- **FULL Detection**: Uses the **MSB inversion method** — FIFO is full when the MSB of `wr_ptr` is the inverse of `rd_ptr`'s MSB, and the lower 3 bits are equal:
  ```
  full = ({~wr_ptr[3], wr_ptr[2:0]} == rd_ptr)
  ```

---

### 4. `read_logic` — Read Pointer & EMPTY Flag

Manages the 4-bit read pointer and generates the `empty` status flag.

- **Read Pointer**: Increments on every valid read (`rd_enable & ~empty`)
- **EMPTY Detection**: FIFO is empty when both pointers are equal:
  ```
  empty = (rd_ptr == wr_ptr)
  ```

---

## Testbench

The testbench `sync_fifo_top_tb.v` validates the design through the following test cases:

### Test Case 3 — Write Rate > Read Rate (Fill Test)
- **Write every cycle**, read every other cycle
- Net fill rate: +1 item every 2 clock cycles
- FIFO depth 8 → fills in approximately 16 clock cycles
- Checks for correct assertion of the `full` flag

### Test Case 4 — Read Rate > Write Rate (Drain Test)
- **Read every cycle**, write every other cycle
- Net drain rate: −1 item every 2 clock cycles
- Starts from full FIFO (continuing from Case 3)
- Checks for correct assertion of the `empty` flag

### Simulation Parameters

| Parameter      | Value       |
|----------------|-------------|
| Timescale      | 1ns / 1ps   |
| Clock Period   | 10ns (100 MHz) |
| Loop Iterations | 20 cycles per case |

---

## Tools & Environment

- **HDL Language**: Verilog (IEEE 1364-2001)
- **Simulator / Synthesizer**: Xilinx Vivado Design Suite
- **Waveform Viewer**: Vivado Simulator (`.wcfg` config included)
- **Target Technology**: FPGA (generic — no device-specific constraints)

---

## How to Simulate

### In Xilinx Vivado

1. Create a new **RTL Project** in Vivado.
2. Add all `.v` source files:
   - `sync_fifo_top.v`, `fifo_memory.v`, `write_logic.v`, `read_logic.v`
3. Add the testbench:
   - `sync_fifo_top_tb.v` (set as simulation source)
4. Load the waveform configuration:
   - Open `sync_fifo_top_tb_behav.wcfg` in the Simulation window
5. Run **Behavioral Simulation** → click **Run All**
6. Observe `full`, `empty`, `rd_data`, `wr_data`, `rd_ptr`, and `wr_ptr` waveforms

### Expected Output (Console)

```
--- Starting Case 3: Write Rate > Read Rate ---
Time: XXXns | FIFO became FULL at count XX
--- Starting Case 4: Read Rate > Write Rate ---
Time: XXXns | FIFO became EMPTY at count XX
```

---

## Design Notes

- **Pointer Width (4-bit) vs Memory Depth (8)**: The extra MSB in each pointer is used solely for distinguishing full vs empty conditions — preventing ambiguity when both pointers would otherwise be equal in both states.
- **Synchronous Read**: Read data is registered, introducing a 1-cycle read latency. This is a standard trade-off for synchronous FIFO designs targeting FPGA block RAM primitives.
- **No Gray Coding**: Since this is a synchronous (single-clock) design, Gray code encoding of pointers is not needed (that is required only in asynchronous/dual-clock FIFOs).

---


