# --- VASM ---
VASM_BIN = vasmm68k_mot
VASM_INC_PREFIX = -I
VASM_OUT_FLAG = -o
VASM_FLAGS = -I $(ASM_SYS_INCLUDES)

# map output format for compiler
VASM_C_GCC_OUT = -Fhunk
VASM_C_VBCC_OUT = -Fhunk
VASM_C_SASC_OUT = -Fhunk
VASM_C_AROS_GCC_OUT = -Felf

# select assembler
AXB_ASM ?= VASM
