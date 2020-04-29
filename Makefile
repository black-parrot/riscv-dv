
BSG_CADENV_DIR ?=
-include $(BSG_CADENV_DIR)/cadenv.mk

export RISCV_GCC     ?= $(BP_EXTERNAL_DIR)/bin/$(CROSS_COMPILE)gcc
export RISCV_OBJCOPY ?= $(BP_EXTERNAL_DIR)/bin/$(CROSS_COMPILE)objcopy

RISCVDV_TEST_LIST = \
  riscv_arithmetic_basic_test \
  riscv_mmu_stress_test \
  riscv_privileged_mode_rand_test \
  riscv_rand_instr_test \
  riscv_loop_test \
  riscv_rand_jump_test \
  riscv_no_fence_test \
  riscv_sfence_exception_test \
  riscv_illegal_instr_test \
  riscv_full_interrupt_test$a

all: $(addprefix generate., $(RISCVDV_TEST_LIST))

generate.%:
	$(PYTHON) run.py --steps gen,gcc_compile --simulator vcs --iterations 1 -o out/ \
		-ct user_extension -cs user_extension -tn $* --isa rv64gc --mabi lp64

clean:
	rm -rf out*
	rm -rf ucli*