# CSCE 3301 – Computer Architecture  
**Fall 2025**  

## Project 1: femtoRV32  
### RISC-V FPGA Implementation and Testing  

---
[🔗 View Block Diagram on draw.io](https://drive.google.com/file/d/1gZo5aAjyp70mv1yOmbNhKu9LxNPKf0Rx/view?usp=sharing)

### Team Members  
- Mahinour Abdelgawad
- Joudy Elgayar

---

## Milestone 1 : ✅
- [x] Team formation

---

## Milestone 2  
**Deadline:** Monday November 10

**Checklist:**  
- [x] Single cycle datapath block diagram
- [ ] Verilog descriptions supporting all of the RV32I instructions 
- [ ] Basic test cases covering all supported instructions
- [ ] A readme.txt file that contains student names as well as release notes (issues, assumptions, what works, what does not work, etc.)
- [ ] A journal folder that contain the journal file of each team member
- [ ] A PDF report documenting your design (including a schematic of the proposed datapath), your implementation, any issues encountered, solutions, screenshots of test waveforms, etc

No thorough testing is required at this stage.
Testing on FPGA is optional at this stage.

**MS2 Progress List:**
- [x] Add I-Type support
- [ ] Test I-Type instructions
- [x] Add B-Type support
- [x] Test B-Type instructions
- [x] Add J-Type support
- [ ] Test J-Type instructions
- [x] Add S-Type support
- [ ] Test S-Type instructions
- [x] Add U-Type support
- [ ] Test U-Type instructions
- [x] Handle ECALL, EBREAK, PAUSE, FENCE, and FENCE.TSO 
- [ ] Test ECALL, EBREAK, PAUSE, FENCE, and FENCE.TSO 

---

## Milestone 3  
**Deadline:** Thursday November 20  

**Checklist:**  
- [ ] Pipelined datapath block diagram  
- [ ] Verilog descriptions
- [ ]  pipeline design must use a single single-ported memory for both instructions and data
- [ ] Report including proof of
thorough FPGA testing (covering all 42 instructions and hazard situations) and any bonus features you intend to submit. 
- [ ] 2 Bonus features
- [ ] Complying with the posted coding guidelines
- [ ] Following the required submission directory structure

---
---
# Requirements

You are required to implement a **RISC-V processor** and test it on the **Nexys A7 trainer kit**.  
Your implementation must satisfy the following:

---

### 1. Instruction Set Support
- The processor must support the **RV32I base integer instruction set** according to the specifications found here:  
  🔗 [RISC-V Specifications (Ratified)](https://riscv.org/specifications/ratified/)
- All **42 user-level instructions** (listed in *Chapter 35, pages 609–610* of  
  *“The RISC-V Instruction Set Manual Volume I: Unprivileged Architecture” (Version 20250508)*)  
  and explained in *Chapter 2* of the same document must be implemented **as described** in the specifications.
- **Exceptions:**  
  The following five instructions — `ECALL`, `EBREAK`, `PAUSE`, `FENCE`, and `FENCE.TSO` —  
  should be interpreted as **halting instructions** that **end program execution**  
  (i.e., prevent the **program counter (PC)** from being updated further).

---

### 2. Pipeline and Hazard Handling
- The implementation must be **pipelined**.  
- It must include **correct hazard handling** (data, structural, and control hazards as applicable).

---

### 3. Memory Architecture
- Use a **single memory** for both **data and instructions**.  
- The memory must be:
  - **Single-ported**
  - **Byte-addressable**
- This design introduces **structural hazards** that can degrade performance and increase the **effective CPI**.
- A valid solution is to **issue one instruction every 2 clock cycles** (effective CPI = 2).  
  Doing so ensures that **memory accesses** from different instructions **never occur in the same clock cycle**.

---

### 4. Execution Cycle Structure
This can be seen as the CPU executing each instruction in **6 cycles**, divided into **3 stages**.  
Each stage uses **2 clock cycles** (`C0` and `C1`):

- **Stage 0:** Instruction Fetch (`C0`) and Registers Read (`C1`)  
- **Stage 1:** ALU Operation (`C0`) and Memory Read/Write (`C1`)  
- **Stage 2:** Register Write Back (`C0`) — `C1` is *not used* by this stage

---

### 5. Testing Requirements
- You should provide a **set of test cases** demonstrating:
  - Full support of **all instructions**
  - Handling of **all hazard scenarios**
- Optionally, you may use code segments from the **RISC-V official compliance test suite**, found here:  
  🔗 [RISC-V Compliance Test Suite – rv32i_m/I](https://gitlab.com/incoresemi/riscof/-/tree/master/riscof/suite/rv32i_m/I)

---
---

# Final Submission

The **zip file** must include the following:

- [ ] **`readme.txt`** — contains:
  - Student names
  - Release notes (issues, assumptions, what works, what does not work, etc.)

- [ ] **`journal/` folder** — contains the **journal file of each team member**

- [ ] **`verilog/` folder** — contains **all Verilog descriptions**

- [ ] **`test/` folder** — contains **all files used for testing**

- [ ] **PDF report** — documents your design, including:
  - A schematic of the proposed datapath  
  - Implementation details  
  - Issues encountered and solutions  
  - Screenshots of test waveforms  
  - Any additional supporting documentation


# References
[🔗 RV32I Base Instruction Set](https://five-embeddev.com/riscv-user-isa-manual/Priv-v1.12/instr-table.html)
