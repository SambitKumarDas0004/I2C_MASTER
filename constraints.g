# =====================================================
# I2C MASTER – CORRECTED SDC CONSTRAINTS
# (Cadence Genus / Innovus compatible)
# =====================================================

# -----------------------------------------------------
# 1. Primary System Clock
# -----------------------------------------------------
# clk = 100 MHz → 10 ns
create_clock -name sys_clk \
             -period 10.000 \
             -waveform {0 5} \
             [get_ports clk]

# Clock quality
set_clock_uncertainty 0.20 [get_clocks sys_clk]
set_clock_transition  0.10 [get_clocks sys_clk]
set_clock_latency     0.50 [get_clocks sys_clk]


# -----------------------------------------------------
# 2. Generated Clock (SCL)
# -----------------------------------------------------
# scl_out toggles on every posedge clk → clk/2
# FSM is clocked on negedge scl_out

create_generated_clock \
    -name scl_clk \
    -source [get_ports clk] \
    -divide_by 2 \
    -edges {1 3} \
    [get_pins master/scl_out]

# Generated clock quality
set_clock_uncertainty 0.25 [get_clocks scl_clk]
set_clock_transition  0.15 [get_clocks scl_clk]


# -----------------------------------------------------
# 3. Input Delays (Synchronous to sys_clk)
# -----------------------------------------------------
set_input_delay -clock sys_clk -max 3.0 \
    [get_ports {start bus_addr_master[*] bus_in_master[*]}]

set_input_delay -clock sys_clk -min 0.5 \
    [get_ports {start bus_addr_master[*] bus_in_master[*]}]


# -----------------------------------------------------
# 4. Output Delays
# -----------------------------------------------------
# bus_out_master is updated in SCL clock domain
set_output_delay -clock scl_clk -max 3.0 \
    [get_ports bus_out_master[*]]

set_output_delay -clock scl_clk -min 0.5 \
    [get_ports bus_out_master[*]]


# -----------------------------------------------------
# 5. I2C Open-Drain Lines (Asynchronous)
# -----------------------------------------------------
# SDA and SCL are protocol wires, not timing endpoints

set_false_path -from [get_ports {sda scl}]
set_false_path -to   [get_ports {sda scl}]

# DO NOT mark as ideal networks (unsafe for ASIC)


# -----------------------------------------------------
# 6. Clock Domain Crossing (CDC Protection)
# -----------------------------------------------------
# Prevent incorrect timing between sys_clk and scl_clk

set_clock_groups -asynchronous \
    -group {sys_clk} \
    -group {scl_clk}


# -----------------------------------------------------
# 7. Drive & Load Modeling
# -----------------------------------------------------
# Input drive strength
set_drive 2 [get_ports {start bus_addr_master[*] bus_in_master[*]}]

# Output loading
set_load 0.10 [get_ports bus_out_master[*]]
set_load 0.20 [get_ports {sda scl}]


# -----------------------------------------------------
# 8. Remove Unsafe False Paths
# -----------------------------------------------------
# 'start' is synchronous — DO NOT false path it
# (Handled via input delay constraints)


# =====================================================
# End of Corrected SDC
# =====================================================

