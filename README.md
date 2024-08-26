# APB Slave
This repository delves into designing and testing of a APB slave module.
1. [ABSTRACT](#abstract)
2. [INTRODUCTION](#introduction)
3. [ARCHITECTURE](#architecture)
4. [STATE DIAGRAM](#state-diagram)
5. [TEST CASES](#test-cases)
6. [KEY CONTRIBUTORS](#key-contributors)<br/>
[REFERENCES](#references)
## ABSTRACT
This project illustrates AMBA APB slave architectural design. Nowadays, the SoC (System on Chip) uses AMBA (Advanced Microcontroller Bus Architecture). The Advanced Peripheral Bus (APB) is one of the components of the AMBA bus architecture. APB is known to have low bandwidth and a low performance bus is used to connect the peripherals like UART, Timer and some other peripheral devices to the bus architecture. The APB protocol is not pipelined. The APB protocol relates a signal transition to the rising edge of the clock to signify the integration of APB peripherals into any design flow. The design is created using Verilog and is tested using a testbench.

## INTRODUCTION
The Advanced Microcontroller Bus Architecture (AMBA) is an open standard for on-chip interconnect specification for designing high-performance embedded microcontrollers. It was developed by ARM and has become a widely adopted standard in the semiconductor industry. AMBA includes several bus protocols, including:
•	Advanced Peripheral Bus (APB): A low-power interface for connecting low-bandwidth peripherals. It is optimized for minimal power consumption and reduced interface complexity.
•	APB follows a non-pipelined design, meaning that transactions must complete before a new one can start, leading to straightforward control logic but potentially higher latency compared to pipelined protocols.
•	Aditional way of verification is simulation-based. As the innovation in technology improved unpredictability of IC's has been expanded. Subsequently, time spent in verification additionally been expanded. System on Chip (SoC) correspondence, significantly affects framework execution, power scattering, and time to advertise. Low power dissipation is the main focus for system designer as well as the researcher’s community. The design of Advanced Peripheral Bus regulator deals the exchanges between the master and slave devices. 
•	The APB shows an indication of progress to the positive edge of the clock, to improve the joining of APB peripherals into any arrangement stream. Each move takes in any event two cycles. The Master and Slave AMBA APB (Advanced Peripheral Bus) is an exceptionally adaptable and configurable confirmation IP that can be handily coordinated into any SOC check environment. The plan and usage of APB convention utilizing Verilog Language and verification utilizing Verilog Testbench.
![image](https://github.com/user-attachments/assets/afbaa179-0ecb-420f-a95a-d52581b1af0f) <br/>
## ARCHITECTURE
![image](https://github.com/user-attachments/assets/f417dee5-9806-4a93-93df-dcf93c6b87a1)<br/>                  
The APB slave consists of several key components, each playing a crucial role and function:
**1. Address Decoder:** <br/>
Function:Determines which register or memory location within the slave is being accessed based on the address signal from the APB master.<br/>
Operation: Compares the address provided by the master against predefined address ranges and generates select signals for the appropriate registers.<br/>
Role: Ensures that the correct register is enabled for read or write operations.<br/>
**2. Register Set:** <br/>
Function: Stores the data to be read from or written to by the APB master.<br/>
Operation: Contains data, status, or control registers that are mapped to specific addresses and can be accessed via the APB interface.<br/>
Role: Serves as the storage area for configuration and data exchange between the master and the slave device.<br/>
**3. APB Interface Logic:** <br/>
Function: Manages the communication protocol between the APB master and the slave device.
Operation: Handles the handshake signals (PSEL, PENABLE, PREADY, PWRITE) and ensures correct data transfer on the PWDATA and PRDATA lines.
Role: Ensures compliance with the APB protocol, facilitating smooth data transfer and synchronization.
**4. Read Data Path:** <br/>
Function: Transfers data from the slave registers to the APB master during read operations.<br/>
Operation: Captures the data from the selected register based on the address decoder and provides it to the master via the PRDATA line.<br/>
Role: Facilitates the reading of data by the master, ensuring that the correct data is outputted when requested.<br/>
**5. Write Data Path:** <br/>
Function: Transfers data from the APB master to the slave registers during write operations.<br/>
Operation: Takes the data from the PWDATA line and writes it into the appropriate register based on the address decoder and control signals.<br/>
Role: Allows the master to update the contents of the slave’s registers with new data.<br/>
**6. PREADY Signal Generation:** <br/>
Function: Indicates to the APB master when the slave is ready to complete the current transfer.<br/>
Operation: Asserts the PREADY signal once the slave has completed the read or write operation, ensuring proper timing and synchronization.<br/>
Role: Coordinates the timing of data transfers, allowing the master to know when it can proceed to the next transaction.<br/>
**7. PSLVERR Signal Generation:** <br/>
Function: Signals any error conditions to the APB master.<br/>
Operation: Asserts the PSLVERR signal when an error occurs, such as accessing an invalid address or a failed transfer.<br/>
Role: Provides error detection and reporting, enabling robust error handling by the master.<br/>
**8. State Machine:** <br/>
Function: Controls the operational states of the APB slave, managing different phases of data transfer.<br/>
Operation: Transitions between states (idle, setup, access) based on inputs like PSEL, PENABLE, and PREADY.<br/>
Role: Coordinates the slave's operations, ensuring that each step in the data transfer process occurs in the correct sequence.<br/>
**Address Decoding Logic**<br/>
Address Decoder: A logic block that decodes the PADDR signal to determine which register or peripheral within the slave is being accessed. It generates appropriate enable signals for internal modules or registers.<br/>
**State Machine**<br/>
•	Setup Phase: The initial phase where PSEL is asserted, and the address and control signals are provided.<br/>
•	Access Phase: The phase where PENABLE is asserted, allowing data transfer (read/write) based on the PWRITE signal. The state machine controls transitions between these phases.<br/>
**Data Path Logic**<br/>
•	Write Logic: Handles the process of writing data from the PWDATA bus to the appropriate register or memory location within the slave.<br/>
•	Read Logic: Retrieves data from the internal registers or memory and places it on the PRDATA bus during a read operation.<br/>
## STATE DIAGRAM
IDLE, SETUP, and ACCESS states are the three states. The fundamental state machine that depicts how a peripheral bus operates is shown in Figure. <br/>
![image](https://github.com/user-attachments/assets/34859401-ef36-4ef1-b769-3cb2317e5d3b)<br/>
**1.Idle State:** <br/>
Description: The APB slave remains in the Idle state when no transfer is occurring. <br/>
Signals: In this state, PSEL (Peripheral Select) is low, indicating that the slave is not selected by the master, and no operations are happening. <br/>
Transition: The slave stays in the Idle state until the master asserts PSEL to initiate a transfer, which triggers a transition to the Setup state. <br/>
**2. Setup State:** <br/>
Description: The Setup state is the initial phase of a transfer, where the address, control, and write data (if applicable) are prepared. <br/>
Signals: During this state, PSEL is high (indicating the slave is selected), PENABLE is low, and PADDR, PWRITE, and PWDATA (if writing) are valid. <br/>
Transition: The transition from the Setup state to the Access state occurs when the master asserts PENABLE. This signals the slave that the address and control signals are stable and valid, allowing the operation to proceed. <br/>
**3. Access State:** <br/>
Description: The Access state is where the actual data transfer takes place. The slave either reads data from or writes data to its registers, depending on the operation type. <br/>
Signals: In this state, both PSEL and PENABLE are high. If it’s a write operation, PWDATA is transferred to the selected register. If it’s a read operation, the data is placed on PRDATA. <br/>
Completion: The PREADY signal is asserted by the slave when the operation is completed, indicating to the master that the transfer is successful. <br/>
Transition: After the Access state, the system typically transitions back to the Idle state if the master desserts PSEL. If the master needs to perform another transfer immediately, it can go back to the Setup state directly from Access by deserting PENABLE while keeping PSEL high. <br/>
### State transition flow <br/>
a. Idle → Setup: When PSEL goes high, the slave moves from Idle to Setup, beginning the transfer process.<br/>
b. Setup → Access: Upon PENABLE going high, the slave enters the Access state, where the actual data read/write occurs.<br/>
c. Access → Idle: After the transfer is complete and PSEL is deserted (goes low), the slave returns to the Idle state, ready for the next transfer.<br/>
d. Access → Setup: If the master keeps PSEL high and desserts PENABLE, the system might move back to the Setup state to prepare for a new operation.<br/>

## TEST CASES
![image](https://github.com/user-attachments/assets/b6e64948-4750-4e6f-baaa-949af47aa74a)<br/>
Test Case Execution Summary:<br/>
•	**Test Case 1:** Successfully wrote 0xDEADBEEF to address 0x10 and read back the same value. <br/>Status: Passed<br/>
•	**Test Case 2:** Successfully wrote 0xCAFEBABE to address 0x20 and read back the same value. <br/>Status: Passed<br/>
•	**Test Case 3:** Verified reading from address 0x10 after writing 0x12345678 to address 0x30. <br/>Status: Passed<br/>
•	**Test Case 4:** Multiple writes to addresses 0x40, 0x50, and 0x60 with correct data read back. <br/>Status: Passed<br/>
•	**Test Case 5:** Read data from addresses 0x40, 0x50, and 0x60 confirming sequential writes.<br/> Status: Passed<br/>
•	**Test Case 6:** Wrote 0xFEEDFACE to address 0x70 and confirmed successful read.<br/> Status: Passed<br/>
•	**Test Case 7:** Verified writing and reading 0xAAAAAAAA to/from address 0x80.<br/> Status: Passed<br/>
## KEY CONTRIBUTORS
1. Chandan Kumar N S
2. Chandan S
3. Deekshith G S
4. Shivashankarayya Mathad
## REFERENCES
* N.Venkateswara Rao, PV Chandrika, Abhishek Kumar and Sowmya Reddy,“ Design of AMBA based AHB2APB protocol for efficient utilization of AHB and APB”, International Research Journal of Engineering and Technology (IRJET), Volume 07, Issue 03, pp. 2395- 0072, 2020.
* Vaishnavi R.K, Bindu.S and Sheik Chandbasha, “Design and Verification of APB Protocol by using System Verilog and Universal Verification Methodology”, International Research Journal of Engineering and Technology (IRJET), Volume 06, Issue 06, pp. 2395- 0072, 2019.
* Vaishnavi R.K, Bindu.S and Sheik Chandbasha, “Design and Verification of APB Protocol by using System Verilog and Universal Verification Methodology”, International Research Journal of Engineering and Technology (IRJET), Volume 06, Issue 06, pp. 2395- 0072, 2019.
* M. Kiran Kumar, Amrita Sajja and Dr. Fazal Noorbasha, “Design and FPGA Implementation of AMBA APB Bridge with Clock Skew Minimization Technique”, IOSR Journal of VLSI and Signal Processing (IOSR-JVSP), Volume 7, Issue 3, pp. 42-45, 2017.
* Kiran Rawat, Kanika Sahni and Sujata Pandey, “RTL Implementation for AMBA ASB APB Protocol at System on Chip level”, IEEE International Conference on Signal Processing and Integrated Networks (SPIN), 2015.
* Roopa.M, Vani.R.M and P.V.Hunagund, “Design of Low Bandwidth Peripherals Using High Performance Bus Architecture”, ELSEVIER, International Conference Communication Technology and System Design, 2011.
* Chenghai Ma, Zhijun Liu and Xiaoyue Ma, “Design and Implementation of APB Bridge based on AMBA 4.0”, IEEE, International Conference on Consumer Electronics, Communications and Networks (CECNet), 2011.
* Muhammad Hafeez and Azilah Saparon, “IP Core of Serial Peripheral Interface (SPI) with AMBA APB Interface”, IEEE 9th Symposium on Computer Applications & Industrial Electronics (ISCAIE), 2019.





