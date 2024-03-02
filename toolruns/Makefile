#===================================================================
#
# Makefile
# --------
# Makefile for building running the SNOW-Vi core and
# top simulation targets. There is also support for linting.
#
#
# Copyright (c) 2024, Assured AB
# Joachim Strömbergson
#
# Redistribution and use in source and binary forms, with or
# without modification, are permitted provided that the following
# conditions are met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in
#    the documentation and/or other materials provided with the
#    distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#===================================================================

# Source files.
AES_ROUND_SRC =../src/rtl/snow_vi_aes_round.v ../src/rtl/snow_vi_aes_sbox.v
TB_AES_ROUND_SRC =../src/tb/tb_snow_vi_aes_round.v

CORE_SRC =../src/rtl/snow_vi_core.v $(AES_ROUND_SRC)
TB_CORE_SRC =../src/tb/tb_snow_vi_core.v

TOP_SRC =../src/rtl/snow_vi.v $(CORE_SRC)
TB_TOP_SRC =../src/tb/tb_snow_vi.v


# Tools and flags.
CC=iverilog
CC_FLAGS= -Wall

LINT=verilator
LINT_FLAGS = +1364-2001ext+ --lint-only  -Wall -Wno-fatal -Wno-DECLFILENAME


# Targets abd build rules.
all: top.sim core.sim aes_round.sim


top.sim: $(TB_TOP_SRC) $(TOP_SRC)
	$(CC) $(CC_FLAGS) -o $@ $^


core.sim: $(TB_CORE_SRC) $(CORE_SRC)
	$(CC) $(CC_FLAGS) -o $@ $^


aes_round.sim: $(TB_AES_ROUND_SRC) $(AES_ROUND_SRC)
	$(CC) $(CC_FLAGS) --o $@ $^


lint:  $(TOP_SRC)
	$(LINT) $(LINT_FLAGS) $(TOP_SRC)


clean:
	rm -f top.sim
	rm -f core.sim
	rm -f aes_round.sim


help:
	@echo "Supported targets:"
	@echo "------------------"
	@echo "all:           Build all simulation targets."
	@echo "top.sim:       Build Poly1305 top level simulation target."
	@echo "core.sim:      Build Poly1305 core simulation target."
	@echo "aes_round.sim: Build Poly1305 poly block simulation target."
	@echo "lint:          Lint the RTL source."
	@echo "clean:         Remove build targets."

#===================================================================
# EOF Makefile
#===================================================================
